import 'package:flutter/material.dart';
import 'package:sakhi_yatra/providers/ride_search_provider.dart';
import 'package:provider/provider.dart';
import 'package:sakhi_yatra/presentation/widgets/ride_card.dart';
import 'package:intl/intl.dart';
import 'package:sakhi_yatra/core/app_strings.dart';
import 'package:sakhi_yatra/presentation/rides/widgets/ride_list_status_view.dart';
import 'package:sakhi_yatra/presentation/widgets/shared_gradient_background.dart';
import 'package:sakhi_yatra/presentation/widgets/common_app_bar.dart';

class AllRidesScreen extends StatelessWidget {
  const AllRidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SharedGradientBackground(
        child: Consumer<RideSearchProvider>(
          builder: (context, provider, child) {
            final rides = provider.searchResults;
            if (rides.isEmpty) {
              return const RideListStatusView(
                title: AppStrings.noRidesFound,
                subtitle: AppStrings.tryDifferentSearch,
                icon: Icons.search_off,
                onRetry: _dummyRetry,
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateHeader(context, provider.selectedDate),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: rides.length,
                    itemBuilder: (context, index) =>
                        RideCard(ride: rides[index]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static void _dummyRetry() {}

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final provider = context.watch<RideSearchProvider>();
    final source = provider.source ?? "Source";
    final destination = provider.destination ?? "Destination";

    return CommonAppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${_getShortName(source)} \u2192 ${_getShortName(destination)}"),
          Text(
            "${DateFormat('EEE, d MMM').format(provider.selectedDate)}, ${provider.passengerCount} passenger",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
              fontSize: 13,
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        TextButton(
          onPressed: () {},
          child: Text(
            "Filter",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: Theme.of(context).dividerColor, height: 1),
      ),
    );
  }

  String _getShortName(String f) =>
      f.contains(',') ? f.split(',').first.trim() : f;

  Widget _buildDateHeader(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final dateStr =
        (date.day == now.day &&
            date.month == now.month &&
            date.year == now.year)
        ? "Today"
        : DateFormat('EEEE, d MMMM').format(date);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Text(
        dateStr,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
