import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:sakhi_yatra/providers/ride_search_provider.dart';
import 'package:sakhi_yatra/providers/create_ride_provider.dart';
import 'package:sakhi_yatra/providers/rides_provider.dart';
import 'package:sakhi_yatra/providers/user_provider.dart';
import 'package:sakhi_yatra/providers/vehicle_provider.dart';
import 'package:sakhi_yatra/providers/connectivity_provider.dart';
import 'package:sakhi_yatra/providers/theme_provider.dart';

import 'package:sakhi_yatra/presentation/login/login_screen.dart';
import 'package:sakhi_yatra/presentation/root_screen.dart';
import 'package:sakhi_yatra/presentation/main_screen.dart';
import 'package:sakhi_yatra/presentation/search/ride_details_screen.dart';
import 'package:sakhi_yatra/services/push_notification_service.dart';

import 'dart:io';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:sakhi_yatra/services/local_storage_service.dart';
import 'package:sakhi_yatra/core/theme/app_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await PushNotificationService.init();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

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
        ChangeNotifierProvider(create: (_) => RidesProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Sakhi Yatra',
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: '/',
            builder: (context, child) {
              return Consumer<ConnectivityProvider>(
                builder: (context, connectivity, _) {
                  return Stack(
                    children: [
                      child!,
                      if (!connectivity.isConnected)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Material(
                            color: Colors.red,
                            child: SafeArea(
                              bottom: false,
                              child: Container(
                                height: 30,
                                alignment: Alignment.center,
                                child: const Text(
                                  'No Internet Connection',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              );
            },
            routes: {
              '/': (context) => const RootScreen(),
              '/login': (context) => const LoginScreen(),
              '/main': (context) => const MainScreen(),
              '/rideDetails': (context) => const RideDetailsScreen(),
            },
          );
        },
      ),
    );
  }
}
