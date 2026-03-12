import 'package:flutter/material.dart';
import 'package:sakhi_yatra/core/models/ride_model.dart';
import 'package:intl/intl.dart';

class RideCardRouteInfo extends StatelessWidget {
  final RideModel ride;
  final Color color;
  const RideCardRouteInfo({super.key, required this.ride, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                _formatTime(ride.pickupTime),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF003B4D),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                _formatTime(ride.dropoffTime),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF003B4D),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          _buildVisualRoute(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ride.pickupLocation ?? "Pickup",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF003B4D),
                  ),
                ),
                const SizedBox(height: 35),
                Text(
                  ride.dropoffLocation ?? "Dropoff",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF003B4D),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "\u20B9${(ride.price ?? 0).toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF003B4D),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  (ride.status ?? "OPEN").toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVisualRoute() => Column(
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF0072FF), width: 2),
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
  );

  String _formatTime(String? t) {
    if (t == null) return "--:--";
    try {
      return DateFormat('HH:mm').format(DateTime.parse(t));
    } catch (_) {
      return "--:--";
    }
  }
}

class RideCardUserInfo extends StatelessWidget {
  final RideModel ride;
  const RideCardUserInfo({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF0072FF).withOpacity(0.1),
            child: const Icon(Icons.person, color: Color(0xFF0072FF), size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ride.createdByName ?? "Unknown",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003B4D),
                ),
              ),
              Text(
                "${ride.availableSeats ?? ride.passengerCount ?? 0} seats available",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}
