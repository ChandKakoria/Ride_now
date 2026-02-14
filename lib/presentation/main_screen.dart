import 'package:flutter/material.dart';
import 'package:ride_now/presentation/search/ride_search_screen.dart';
import 'package:ride_now/presentation/publish/publish_screen.dart';
import 'package:ride_now/presentation/rides/your_rides_screen.dart';

import 'package:ride_now/presentation/inbox/inbox_screen.dart';
import 'package:ride_now/presentation/profile/profile_screen.dart';
import 'package:liquid_glass_bottom_bar/liquid_glass_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    RideSearchScreen(),
    PublishScreen(),
    YourRidesScreen(),
    InboxScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: LiquidGlassBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        activeColor: const Color(0xFF00A3E0),
        items: const [
          LiquidGlassBottomBarItem(icon: Icons.directions_car, label: "Ride"),
          LiquidGlassBottomBarItem(
            icon: Icons.add_circle_outline,
            activeIcon: Icons.add_circle,
            label: "Create Ride",
          ),
          LiquidGlassBottomBarItem(icon: Icons.local_taxi, label: "My Rides"),
          LiquidGlassBottomBarItem(
            icon: Icons.chat_bubble_outline,
            activeIcon: Icons.chat_bubble,
            label: "Inbox",
          ),
          LiquidGlassBottomBarItem(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
