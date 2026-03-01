import 'package:flutter/material.dart';
import 'package:ride_now/presentation/login/login_screen.dart';
import 'package:ride_now/presentation/main_screen.dart';
import 'package:ride_now/services/local_storage_service.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? token = LocalStorageService.getToken();

    // If token exists, user is already logged in
    if (token != null && token.isNotEmpty) {
      return const MainScreen();
    }

    // Otherwise, show login screen
    return const LoginScreen();
  }
}
