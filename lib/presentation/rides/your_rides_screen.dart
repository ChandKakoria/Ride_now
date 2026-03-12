import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakhi_yatra/presentation/widgets/ride_card.dart';
import 'package:sakhi_yatra/providers/rides_provider.dart';
import 'package:sakhi_yatra/core/api_response.dart';
import 'package:sakhi_yatra/presentation/rides/widgets/ride_list_status_view.dart';
import 'package:sakhi_yatra/presentation/widgets/common_app_bar.dart';

class YourRidesScreen extends StatefulWidget {
  const YourRidesScreen({super.key});
  @override
  State<YourRidesScreen> createState() => _YourRidesScreenState();
}

class _YourRidesScreenState extends State<YourRidesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (!_tabController.indexIsChanging) _fetchData();
      });
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  void _fetchData() {
    if (_tabController.index == 0)
      context.read<RidesProvider>().fetchMyRides();
    else
      context.read<RidesProvider>().fetchBookedRides();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(
        automaticallyImplyLeading: false,
        title: const Text("Your rides"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: _buildTabBar(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildTabContent(true), _buildTabContent(false)],
      ),
    );
  }

  Widget _buildTabBar() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(16),
    ),
    child: TabBar(
      controller: _tabController,
      padding: const EdgeInsets.all(4),
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      labelColor: const Color(0xFF003B4D),
      unselectedLabelColor: Colors.grey[600],
      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      tabs: const [
        Tab(text: "My Rides"),
        Tab(text: "Requested"),
      ],
    ),
  );

  Widget _buildTabContent(bool isMyRides) => Consumer<RidesProvider>(
    builder: (context, provider, _) {
      final res = isMyRides ? provider.myRides : provider.bookedRides;
      if (res.status == Status.LOADING)
        return const Center(child: CircularProgressIndicator());
      if (res.status == Status.ERROR)
        return RideListStatusView(
          title: "Error",
          subtitle: res.message ?? "Failed to fetch",
          icon: Icons.error_outline,
          onRetry: _fetchData,
          isError: true,
        );
      final rides = res.data ?? [];
      if (rides.isEmpty)
        return RideListStatusView(
          title: isMyRides ? "No rides created" : "No booked rides",
          subtitle: isMyRides
              ? "Rides you publish appear here"
              : "Rides you book appear here",
          icon: isMyRides
              ? Icons.directions_car_outlined
              : Icons.bookmarks_outlined,
          onRetry: _fetchData,
        );
      return RefreshIndicator(
        onRefresh: () async => _fetchData(),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: rides.length,
          itemBuilder: (c, i) => RideCard(isMyRide: isMyRides, ride: rides[i]),
        ),
      );
    },
  );
}
