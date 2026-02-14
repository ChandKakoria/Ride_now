import 'package:flutter/material.dart';
import 'package:ride_now/presentation/search/mock_data.dart';
import 'package:ride_now/presentation/rides/cancel_ride_bottom_sheets.dart';

class RideDetailsScreen extends StatelessWidget {
  final RideData ride;

  const RideDetailsScreen({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF003B4D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Ride details",
          style: TextStyle(
            color: Color(0xFF003B4D),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              bottom: 100,
            ), // Space for bottom button
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Header
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Text(
                    "Thursday, 5 February", // Hardcoded date matching design for now, or could pass date
                    style: TextStyle(
                      color: Color(0xFF003B4D),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Timeline Section
                _buildTimeline(context),
                const SizedBox(height: 16),
                Divider(thickness: 8, color: Colors.grey[100]),

                // Passenger & Price
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "1 passenger",
                        style: TextStyle(
                          color: Color(0xFF003B4D),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "\u20B9 ${ride.price?.toStringAsFixed(2) ?? '0.00'}",
                        style: TextStyle(
                          color: Color(0xFF003B4D),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 8, color: Colors.grey[100]),

                // Ad Banner Placeholder
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 60,
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        // Mock Ad content
                        Container(width: 60, color: Colors.purple[100]),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Delta Exchange - 1 Lac* Cash...",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Refer...",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(thickness: 8, color: Colors.grey[100]),

                // Driver Section
                _buildDriverSection(),

                Divider(height: 1, color: Colors.grey[200]),

                // Cancellation Policy / Extra Info
                if (ride.cancellationTrend != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          ride.cancellationTrend!,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 40),
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) =>
                            const CancelRideReasonBottomSheet(),
                      );
                    },
                    child: const Text(
                      "Cancel your ride",
                      style: TextStyle(
                        color: Colors.red, // Destructive action color
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    "Report this ride",
                    style: TextStyle(
                      color: Color(0xFF00A3E0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),

          // Bottom Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Book Action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A3E0), // Cyan Blue
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flash_on, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Book",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Time Column
            SizedBox(
              width: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ride.startTime,
                    style: const TextStyle(
                      color: Color(0xFF003B4D),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ride.duration,
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                  const Spacer(), // Pushes end time to bottom
                  Text(
                    ride.endTime,
                    style: const TextStyle(
                      color: Color(0xFF003B4D),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Timeline Line
            Column(
              children: [
                _buildTimelineNode(isStart: true),
                Expanded(
                  child: Container(
                    width: 4,
                    color: Colors.grey[300], // Light gray line
                  ),
                ),
                // If there is an intermediate stop, we could add a node here
                // For now just consistent line as per design
                _buildTimelineNode(isStart: false),
              ],
            ),
            const SizedBox(width: 16),

            // Address Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Start
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            ride.startCity,
                            style: const TextStyle(
                              color: Color(0xFF003B4D),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.map_outlined,
                            size: 16,
                            color: Colors.blue[300],
                          ), // Map icon placeholder
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ride.startAddress,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                  // Intermediate Stop (Yamuna Nagar)
                  if (ride.intermediateCity != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        ride.intermediateCity!,
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    )
                  else
                    // Placeholder for spacing if no intermediate
                    const SizedBox(height: 20),

                  // End
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            ride.endCity,
                            style: const TextStyle(
                              color: Color(0xFF003B4D),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.map_outlined,
                            size: 16,
                            color: Colors.blue[300],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ride.endAddress,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineNode({required bool isStart}) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF003B4D), width: 2),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildDriverSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Color(0xFFE0F7FA), // Light cyan bg
                    child: Icon(Icons.person, color: Colors.grey, size: 30),
                  ),
                  if (ride.isVerifiedProfile)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ride.driverName,
                    style: const TextStyle(
                      color: Color(0xFF003B4D),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.grey, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "${ride.rating.toStringAsFixed(2)}/5 - ${ride.ratingCount} ratings",
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
          if (ride.isVerifiedProfile)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                children: [
                  const Icon(Icons.verified_user, color: Colors.blue, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    "Verified Profile",
                    style: TextStyle(color: Colors.grey[700], fontSize: 15),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
