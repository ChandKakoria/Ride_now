import 'package:flutter/material.dart';
import 'package:ride_now/presentation/rides/cancel_ride_bottom_sheets.dart';
import 'package:intl/intl.dart';

class RideDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> rideMap;

  const RideDetailsScreen({super.key, required this.rideMap});

  @override
  Widget build(BuildContext context) {
    final pickupTime = _parseTime(rideMap['pickup_time']);
    final dropoffTime = _parseTime(rideMap['dropoff_time']);
    final price = rideMap['price']?.toDouble() ?? 0.0;
    final driverName = rideMap['created_by'] ?? "Unknown";
    final passengers = rideMap['passenger_count'] ?? 1;
    final date = _parseDate(rideMap['pickup_time']);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF003B4D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Ride details",
          style: TextStyle(
            color: Color(0xFF003B4D),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Text(
                    date,
                    style: const TextStyle(
                      color: Color(0xFF003B4D),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Timeline Section
                _buildTimeline(pickupTime, dropoffTime),
                const SizedBox(height: 16),
                Divider(thickness: 8, color: Colors.grey[100]),

                // Passenger & Price
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$passengers passenger",
                        style: const TextStyle(
                          color: Color(0xFF003B4D),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "\u20B9 ${price.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Color(0xFF003B4D),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 8, color: Colors.grey[100]),

                // Driver Section
                _buildDriverSection(driverName),

                Divider(height: 1, color: Colors.grey[200]),

                const SizedBox(height: 40),
                Center(
                  child: TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) =>
                            const CancelRideReasonBottomSheet(),
                      );
                    },
                    child: const Text(
                      "Cancel your ride",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Book Action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A3E0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flash_on, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Book",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(String pickup, String dropoff) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pickup,
                    style: const TextStyle(
                      color: Color(0xFF003B4D),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    dropoff,
                    style: const TextStyle(
                      color: Color(0xFF003B4D),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                _buildTimelineNode(),
                Expanded(child: Container(width: 4, color: Colors.grey[300])),
                _buildTimelineNode(),
              ],
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pickup Location",
                    style: TextStyle(
                      color: Color(0xFF003B4D),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Dropoff Location",
                    style: TextStyle(
                      color: Color(0xFF003B4D),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineNode() {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF003B4D), width: 2),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildDriverSection(String name) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFFE0F7FA),
            child: Icon(Icons.person, color: Colors.grey, size: 30),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Color(0xFF003B4D),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Row(
                children: [
                  Icon(Icons.star, color: Colors.grey, size: 16),
                  SizedBox(width: 4),
                  Text(
                    "4.5/5 - 12 ratings",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  String _parseTime(String? timeStr) {
    if (timeStr == null) return "--:--";
    try {
      final dt = DateTime.parse(timeStr);
      return DateFormat('HH:mm').format(dt);
    } catch (e) {
      return "--:--";
    }
  }

  String _parseDate(String? timeStr) {
    if (timeStr == null) return "Date unknown";
    try {
      final dt = DateTime.parse(timeStr);
      return DateFormat('EEEE, d MMMM').format(dt);
    } catch (e) {
      return "Date unknown";
    }
  }
}
