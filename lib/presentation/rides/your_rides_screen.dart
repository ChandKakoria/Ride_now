import 'package:flutter/material.dart';
import 'package:ride_now/presentation/widgets/ride_card.dart';
import 'package:ride_now/presentation/search/mock_data.dart';

class YourRidesScreen extends StatelessWidget {
  const YourRidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Your rides",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            labelColor: Color(0xFF00A3E0),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF00A3E0),
            tabs: [
              Tab(text: "Upcoming"),
              Tab(text: "Past"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Upcoming Rides
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mockRides.length, // Using mock data for demo
              itemBuilder: (context, index) {
                return RideCard(ride: mockRides[index]);
              },
            ),
            // Past Rides (Empty for demo or duplicate mock)
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 1,
              itemBuilder: (context, index) {
                return RideCard(ride: mockRides[0]); // Just showing one
              },
            ),
          ],
        ),
      ),
    );
  }
}
