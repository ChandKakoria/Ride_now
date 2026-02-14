import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_now/providers/ride_search_provider.dart';
import 'package:ride_now/providers/create_ride_provider.dart';

import 'package:ride_now/presentation/login/login_screen.dart';

import 'dart:io';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:ride_now/services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }
  }
  await LocalStorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RideSearchProvider()),
        ChangeNotifierProvider(create: (_) => CreateRideProvider()),
      ],
      child: MaterialApp(
        title: 'Ride Now',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00A3E0)),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
