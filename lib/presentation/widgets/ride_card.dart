import 'package:flutter/material.dart';
import 'package:sakhi_yatra/core/models/ride_model.dart';
import 'package:sakhi_yatra/presentation/search/ride_details_screen.dart';
import 'package:sakhi_yatra/presentation/widgets/ride_card_components.dart';

class RideCard extends StatelessWidget {
  final RideModel? ride;
  final bool isMyRide;
  const RideCard({super.key, this.ride, this.isMyRide = false});

  @override
  Widget build(BuildContext context) {
    if (ride == null) return const SizedBox.shrink();
    final statusColor = _getStatusColor(ride!.status);
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
            RideCardRouteInfo(ride: ride!, color: statusColor),
            const Divider(height: 1),
            RideCardUserInfo(ride: ride!),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? s) {
    final str = s?.toLowerCase() ?? "open";
    if (str == 'booked') return const Color(0xFF4CAF50);
    if (str == 'requested') return const Color(0xFFFFC107);
    return const Color(0xFF00A3E0);
  }
}
