import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RideHeader extends StatelessWidget {
  final String? pickupTime;
  final String? status;

  const RideHeader({super.key, this.pickupTime, this.status});

  @override
  Widget build(BuildContext context) {
    final date = _parseDate(pickupTime);
    final statusStr = status?.toLowerCase() ?? "open";

    final Color statusColor;
    if (statusStr == 'booked') {
      statusColor = Colors.green;
    } else if (statusStr == 'requested') {
      statusColor = Colors.orange;
    } else {
      statusColor = Theme.of(context).primaryColor;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor.withOpacity(0.2)),
            ),
            child: Text(
              statusStr.toUpperCase(),
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
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
