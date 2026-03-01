import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RideTimeline extends StatelessWidget {
  final String? pickupTime;
  final String? dropoffTime;
  final String? pickupLocation;
  final String? dropoffLocation;

  const RideTimeline({
    super.key,
    this.pickupTime,
    this.dropoffTime,
    this.pickupLocation,
    this.dropoffLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTimesColumn(),
            _buildTimelineIndicator(),
            const SizedBox(width: 16),
            _buildLocationsColumn(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimesColumn() {
    return SizedBox(
      width: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatTime(pickupTime),
            style: const TextStyle(
              color: Color(0xFF003B4D),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            _formatTime(dropoffTime),
            style: const TextStyle(
              color: Color(0xFF003B4D),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineIndicator() {
    return Column(
      children: [
        _buildTimelineNode(),
        Expanded(child: Container(width: 4, color: Colors.grey[300])),
        _buildTimelineNode(),
      ],
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

  Widget _buildLocationsColumn() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            pickupLocation ?? "Pickup Location",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF003B4D),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            dropoffLocation ?? "Dropoff Location",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF003B4D),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String? timeStr) {
    if (timeStr == null) return "--:--";
    try {
      final dt = DateTime.parse(timeStr);
      return DateFormat('HH:mm').format(dt);
    } catch (e) {
      return "--:--";
    }
  }
}
