import 'package:flutter/material.dart';
import 'package:ride_now/presentation/search/ride_details_screen.dart';
import 'package:intl/intl.dart';

class RideCard extends StatelessWidget {
  final Map<String, dynamic>? rideMap;

  const RideCard({super.key, this.rideMap});

  @override
  Widget build(BuildContext context) {
    if (rideMap == null) return const SizedBox.shrink();

    final pickupTime = _parseTime(rideMap!['pickup_time']);
    final dropoffTime = _parseTime(rideMap!['dropoff_time']);
    final price = rideMap!['price']?.toDouble() ?? 0.0;
    final driverName = rideMap!['created_by'] ?? "Unknown";
    final passengers = rideMap!['passenger_count'] ?? 0;

    // Status color
    Color statusColor = const Color(0xFF003B4D);
    if (rideMap!['status'] == 'requested') {
      statusColor = Colors.orange;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RideDetailsScreen(rideMap: rideMap!),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Times
                  Column(
                    children: [
                      Text(
                        pickupTime,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF003B4D),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        dropoffTime,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF003B4D),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Route line
                  Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF0072FF),
                            width: 2,
                          ),
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 40,
                        color: const Color(0xFF0072FF).withOpacity(0.3),
                      ),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF0072FF),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Locations & Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pickup Location",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 35),
                        const Text(
                          "Dropoff Location",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  // Price
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "\u20B9${price.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF003B4D),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          rideMap!['status']?.toUpperCase() ?? "UNKNOWN",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.grey[100]),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFF0072FF).withOpacity(0.1),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFF0072FF),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driverName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003B4D),
                        ),
                      ),
                      Text(
                        "$passengers seats available",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
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
}
