import 'package:flutter/material.dart';

class RidePassengerInfo extends StatelessWidget {
  final int totalSeats;
  final int bookedSeats;
  final int availableSeats;
  final double price;

  const RidePassengerInfo({
    super.key,
    required this.totalSeats,
    required this.bookedSeats,
    required this.availableSeats,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$totalSeats seats total",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "$bookedSeats booked, $availableSeats available",
                style: TextStyle(
                  color: Theme.of(context).disabledColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Text(
            "\u20B9 ${price.toStringAsFixed(2)}",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
