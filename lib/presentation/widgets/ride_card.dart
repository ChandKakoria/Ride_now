import 'package:flutter/material.dart';
import 'package:ride_bridge_car/core/models/ride_model.dart';
import 'package:ride_bridge_car/presentation/search/ride_details_screen.dart';
import 'package:ride_bridge_car/presentation/widgets/ride_card_components.dart';

class RideCard extends StatelessWidget {
  final RideModel? ride;
  final bool isMyRide;
  const RideCard({super.key, this.ride, this.isMyRide = false});

  @override
  Widget build(BuildContext context) {
    if (ride == null) return const SizedBox.shrink();
    final statusColor = _getStatusColor(context, ride!.status);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (c) => RideDetailsScreen(ride: ride!, isMyRide: isMyRide),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.08)
                : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            RideCardRouteInfo(ride: ride!, color: statusColor),
            Divider(height: 1, color: Theme.of(context).dividerColor),
            RideCardUserInfo(ride: ride!),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(BuildContext context, String? s) {
    final str = s?.toLowerCase() ?? "open";
    if (str == 'booked') return Colors.green;
    if (str == 'requested') return Colors.orange;
    if (str == 'cancelled') return Colors.red;
    return Theme.of(context).primaryColor;
  }
}
