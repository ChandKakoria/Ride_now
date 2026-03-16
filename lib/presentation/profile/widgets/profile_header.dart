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
          child: Icon(
            Icons.person,
            size: 40,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$firstName $lastName",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                vehicle != null
                    ? "${vehicle!.name} ${vehicle!.model} (${vehicle!.color})"
                    : "No vehicle added",
                style: TextStyle(
                  fontSize: 14,
                  color: vehicle != null
                      ? (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Theme.of(context).primaryColor)
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
