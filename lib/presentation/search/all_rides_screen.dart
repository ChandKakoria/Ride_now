import 'package:flutter/material.dart';
import 'package:ride_now/providers/ride_search_provider.dart';
import 'package:provider/provider.dart';
import 'package:ride_now/presentation/widgets/ride_card.dart';
import 'package:intl/intl.dart';
import 'package:ride_now/core/app_strings.dart';
import 'package:ride_now/presentation/rides/widgets/ride_list_status_view.dart';
import 'package:ride_now/presentation/widgets/shared_gradient_background.dart';

class AllRidesScreen extends StatelessWidget {
  const AllRidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                _buildDateHeader(provider.selectedDate),
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

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${_getShortName(source)} \u2192 ${_getShortName(destination)}",
            style: const TextStyle(
              color: Color(0xFF003B4D),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "${DateFormat('EEE, d MMM').format(provider.selectedDate)}, ${provider.passengerCount} passenger",
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text(
            "Filter",
            style: TextStyle(
              color: Color(0xFF00A3E0),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: Colors.grey[200], height: 1),
      ),
    );
  }

  String _getShortName(String f) =>
      f.contains(',') ? f.split(',').first.trim() : f;

  Widget _buildDateHeader(DateTime date) {
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
        style: const TextStyle(
          color: Color(0xFF003B4D),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
