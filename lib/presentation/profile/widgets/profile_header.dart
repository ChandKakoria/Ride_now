import 'package:flutter/material.dart';
import 'package:sakhi_yatra/core/models/vehicle_model.dart';

class ProfileHeader extends StatelessWidget {
  final String firstName;
  final String lastName;
  final VehicleModel? vehicle;

  const ProfileHeader({
    super.key,
    required this.firstName,
    required this.lastName,
    this.vehicle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Icon(Icons.person, size: 40, color: Color(0xFF00A3E0)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$firstName $lastName",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003B4D),
                ),
              ),
              Text(
                vehicle != null
                    ? "${vehicle!.name} ${vehicle!.model} (${vehicle!.color})"
                    : "No vehicle added",
                style: TextStyle(
                  fontSize: 14,
                  color: vehicle != null
                      ? const Color(0xFF00A3E0)
                      : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
