import 'package:flutter/material.dart';
import 'package:ride_now/providers/ride_search_provider.dart';
import 'package:provider/provider.dart';
import 'package:ride_now/presentation/widgets/ride_card.dart';
import 'package:intl/intl.dart';

class AllRidesScreen extends StatelessWidget {
  const AllRidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background
      appBar: _buildAppBar(context),
      body: Consumer<RideSearchProvider>(
        builder: (context, provider, child) {
          final rides = provider.searchResults;

          if (rides.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    "No rides found",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Try different locations or dates",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
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
                  itemBuilder: (context, index) {
                    return RideCard(rideMap: rides[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final provider = Provider.of<RideSearchProvider>(context, listen: false);
    final source = provider.source ?? "Source";
    final destination = provider.destination ?? "Destination";

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
        onPressed: () {
          Navigator.pop(context);
        },
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
          const SizedBox(height: 2),
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
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: Colors.grey[200], height: 1.0),
      ),
    );
  }

  String _getShortName(String fullPath) {
    if (fullPath.contains(',')) {
      return fullPath.split(',').first.trim();
    }
    return fullPath;
  }

  Widget _buildDateHeader(DateTime date) {
    String dateStr = "Results";
    final now = DateTime.now();
    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      dateStr = "Today";
    } else {
      dateStr = DateFormat('EEEE, d MMMM').format(date);
    }

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
