import 'package:flutter/material.dart';
import 'package:ride_now/core/models/booking_model.dart';

class BookedPassengersList extends StatelessWidget {
  final List<BookingModel> bookedUsers;

  const BookedPassengersList({super.key, required this.bookedUsers});

  @override
  Widget build(BuildContext context) {
    if (bookedUsers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text(
            "Booked Passengers",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003B4D),
            ),
          ),
        ),
        ListView.separated(
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
                backgroundColor: const Color(0xFF4CAF50).withOpacity(0.1),
                child: const Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
              ),
              title: Text(
                booking.name ?? "Unknown",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003B4D),
                ),
              ),
              trailing: const Text(
                "BOOKED",
                style: TextStyle(
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
