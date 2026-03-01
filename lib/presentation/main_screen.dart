import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_now/presentation/search/ride_search_screen.dart';
import 'package:ride_now/presentation/publish/publish_screen.dart';
import 'package:ride_now/presentation/rides/your_rides_screen.dart';
import 'package:ride_now/presentation/inbox/inbox_screen.dart';
import 'package:ride_now/presentation/profile/profile_screen.dart';
import 'package:liquid_glass_bottom_bar/liquid_glass_bottom_bar.dart';
import 'package:ride_now/core/app_strings.dart';
import 'package:ride_now/providers/rides_provider.dart';
import 'package:ride_now/providers/user_provider.dart';
import 'package:ride_now/presentation/widgets/shared_gradient_background.dart';

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
      backgroundColor: Colors.transparent,
      body: SharedGradientBackground(
        child: IndexedStack(index: _currentIndex, children: _screens),
      ),
      bottomNavigationBar: LiquidGlassBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          print("MainScreen: Tab $index clicked");
          setState(() => _currentIndex = index);
          if (index == 2) {
            context.read<RidesProvider>().fetchMyRides();
            context.read<RidesProvider>().fetchBookedRides();
          }
          if (index == 4) context.read<UserProvider>().fetchProfile();
        },
        activeColor: const Color(0xFF00A3E0), // Vibrant Sky Blue
        items: const [
          LiquidGlassBottomBarItem(
            icon: Icons.directions_car_outlined,
            activeIcon: Icons.directions_car,
            label: "Ride",
          ),
          LiquidGlassBottomBarItem(
            icon: Icons.add_circle_outline,
            activeIcon: Icons.add_circle,
            label: AppStrings.titlePublishRide,
          ),
          LiquidGlassBottomBarItem(
            icon: Icons.local_taxi_outlined,
            activeIcon: Icons.local_taxi,
            label: AppStrings.titleMyRides,
          ),
          LiquidGlassBottomBarItem(
            icon: Icons.chat_bubble_outline,
            activeIcon: Icons.chat_bubble,
            label: "Inbox",
          ),
          LiquidGlassBottomBarItem(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            label: AppStrings.titleProfile,
          ),
        ],
      ),
    );
  }
}
