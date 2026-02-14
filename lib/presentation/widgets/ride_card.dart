import 'package:flutter/material.dart';
import 'package:ride_now/presentation/search/mock_data.dart';
import 'package:ride_now/presentation/search/ride_details_screen.dart';

class RideCard extends StatelessWidget {
  final RideData ride;

  const RideCard({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    final isFull = ride.isFull;
    final textColor = isFull ? Colors.grey[400] : const Color(0xFF003B4D);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RideDetailsScreen(ride: ride),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Section: Time, Route, Price
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Times
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ride.startTime,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            ride.duration,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Text(
                          ride.endTime,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // Route Line Visualization
                    Column(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: isFull
                                  ? Colors.grey[300]!
                                  : const Color(0xFF003B4D),
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 2,
                            color: isFull
                                ? Colors.grey[300]
                                : const Color(0xFF003B4D),
                          ),
                        ),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: isFull
                                ? Colors.grey[300]!
                                : const Color(0xFF003B4D),
                            border: Border.all(
                              color: isFull
                                  ? Colors.grey[300]!
                                  : const Color(0xFF003B4D),
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // Cities
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ride.startCity,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Text(
                            ride.endCity,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Price or Status
                    if (ride.isFull)
                      const Text(
                        "Full",
                        style: TextStyle(
                          color: Color(0xFF003B4D),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      Text(
                        "\u20B9 ${ride.price?.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: const Color(0xFF003B4D),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Divider(height: 1, color: Colors.grey[200]),
            // Bottom Section: Driver Info
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[200],
                    child: Icon(Icons.person, color: Colors.grey[400]),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.driverName,
                        style: TextStyle(
                          color: isFull ? Colors.grey[400] : Colors.grey[800],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 14,
                            color: isFull ? Colors.grey[300] : Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            ride.rating.toString(),
                            style: TextStyle(
                              color: isFull
                                  ? Colors.grey[300]
                                  : Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (ride.instantBook)
                    Icon(Icons.bolt, color: Colors.grey[400]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
