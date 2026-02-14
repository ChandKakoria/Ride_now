import 'package:flutter/material.dart';
import 'mock_data.dart';
import 'package:ride_now/presentation/widgets/ride_card.dart';

class AllRidesScreen extends StatelessWidget {
  const AllRidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: mockRides.length,
              itemBuilder: (context, index) {
                return RideCard(ride: mockRides[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20),
        onPressed: () {
          // Navigation pop would go here
        },
      ),
      titleSpacing: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Greater Noi... \u2192 Panipat, Ha...", // \u2192 is right arrow
            style: TextStyle(
              color: Color(0xFF003B4D), // Dark Cyan/Blue color
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "Today, 1 passenger",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text(
            "Filter",
            style: TextStyle(
              color: Color(0xFF00A3E0), // Cyan/Blue
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: Colors.grey[200], height: 1.0),
      ),
    );
  }

  Widget _buildDateHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Text(
        "Today",
        style: TextStyle(
          color: const Color(0xFF003B4D),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
