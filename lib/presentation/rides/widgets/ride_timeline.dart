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
            _buildTimesColumn(context),
            _buildTimelineIndicator(context),
            const SizedBox(width: 16),
            _buildLocationsColumn(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTimesColumn(BuildContext context) {
    return SizedBox(
      width: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatTime(pickupTime),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            _formatTime(dropoffTime),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineIndicator(BuildContext context) {
    return Column(
      children: [
        _buildTimelineNode(context),
        Expanded(
          child: Container(
            width: 4,
            color: Theme.of(context).disabledColor.withOpacity(0.2),
          ),
        ),
        _buildTimelineNode(context),
      ],
    );
  }

  Widget _buildTimelineNode(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).primaryColor, width: 2),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildLocationsColumn(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            pickupLocation ?? "Pickup Location",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            dropoffLocation ?? "Dropoff Location",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
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
