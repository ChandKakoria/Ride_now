import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import 'package:ride_bridge_car/presentation/search/ride_search_screen.dart';
import 'package:ride_bridge_car/presentation/publish/publish_screen.dart';
import 'package:ride_bridge_car/presentation/rides/your_rides_screen.dart';
import 'package:ride_bridge_car/presentation/inbox/inbox_screen.dart';
import 'package:ride_bridge_car/presentation/profile/profile_screen.dart';
import 'package:liquid_glass_bottom_bar/liquid_glass_bottom_bar.dart';
import 'package:ride_bridge_car/core/app_strings.dart';
import 'package:ride_bridge_car/providers/rides_provider.dart';
import 'package:ride_bridge_car/providers/user_provider.dart';
import 'package:ride_bridge_car/presentation/widgets/shared_gradient_background.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ride_bridge_car/services/user_service.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _syncFcmToken();
  }

  Future<void> _syncFcmToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await UserService().updateFcmToken(token);
      }
    } catch (e) {
      if (kDebugMode) print("Error syncing FCM token: $e");
    }
  }

  final List<Widget> _screens = const [
    RideSearchScreen(),
    PublishScreen(),
    YourRidesScreen(),
    InboxScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: Scaffold(
        extendBody: true,
        body: SharedGradientBackground(
          child: IndexedStack(index: _currentIndex, children: _screens),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          child: LiquidGlassBottomBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              if (index == _currentIndex) return;
              print("MainScreen: Tab $index clicked");
              setState(() => _currentIndex = index);
              if (index == 2) {
                context.read<RidesProvider>().fetchMyRides();
                context.read<RidesProvider>().fetchBookedRides();
              }
              if (index == 4) context.read<UserProvider>().fetchProfile();
            },
            activeColor: Theme.of(context).colorScheme.onPrimary,
            items: const [
              LiquidGlassBottomBarItem(
                icon: Icons.search_sharp,
                activeIcon: Icons.search_outlined,
                label: "Find Ride",
              ),
              LiquidGlassBottomBarItem(
                icon: Icons.local_taxi_outlined,
                activeIcon: Icons.local_taxi,
                label: AppStrings.titleMyRides,
              ),
              LiquidGlassBottomBarItem(
                icon: Icons.add_circle_outline,
                activeIcon: Icons.add_circle,
                label: AppStrings.titlePublishRide,
              ),

              LiquidGlassBottomBarItem(
                icon: Icons.chat_bubble_outline,
                activeIcon: Icons.chat_bubble,
                label: "Chats",
              ),
              LiquidGlassBottomBarItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: AppStrings.titleProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
