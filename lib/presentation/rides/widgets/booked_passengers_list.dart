import 'package:flutter/material.dart';
import 'package:sakhi_yatra/core/models/booking_model.dart';

class BookedPassengersList extends StatelessWidget {
  final List<BookingModel> bookedUsers;

  const BookedPassengersList({super.key, required this.bookedUsers});

  @override
  Widget build(BuildContext context) {
    if (bookedUsers.isEmpty) return const SizedBox.shrink();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bookedUsers.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final booking = bookedUsers[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : null,
            child: const Icon(Icons.check_circle, color: Colors.green),
          ),
          title: Text(
            booking.name ?? "Unknown",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          trailing: const Text(
            "BOOKED",
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        );
      },
    );
  }
}
