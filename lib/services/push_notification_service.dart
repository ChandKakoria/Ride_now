import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sakhi_yatra/main.dart'; // To access navigatorKey

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background message received: ${message.messageId}");
}

class PushNotificationService {
  static Future<void> init() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');

    // Enable foreground notifications on iOS
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Register Background Handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // A. When App is OPEN (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground notification received: \${message.data}");
      
      // Since Android does NOT show banner notifications when the app is in the foreground,
      // we can show an in-app SnackBar to display the notification title and body.
      if (message.notification != null && navigatorKey.currentState?.context != null) {
        final context = navigatorKey.currentState!.context;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${message.notification?.title ?? ''}\n${message.notification?.body ?? ''}",
            ),
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'View',
              onPressed: () {
                _handleMessage(message);
              },
            ),
          ),
        );
      } else {
        // If there's no visible notification body, handle the logic silently as requested
        _handleMessage(message);
      }
    });

    // B. When App is in BACKGROUND and opened by click
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Background notification opened: \${message.data}");
      _handleNavigation(message);
    });

    // C. When App is CLOSED (Terminated) and opened by click
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print("Terminated notification opened: \${initialMessage.data}");
      // Introduce a slight delay so the navigator is fully ready after startup
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleNavigation(initialMessage);
      });
    }
  }

  static void _handleMessage(RemoteMessage message) {
    // Optionally show a local notification or snackbar here if desired.
    // The user instruction mostly cares about navigation on click, which 
    // for foreground can also trigger if requested, but typically foreground 
    // deep linking should probably prompt the user or just navigate if that's the desired UX.
    if (message.data['type'] == 'ride') {
      String? rideId = message.data['rideId'];
      if (rideId != null && navigatorKey.currentState != null) {
        // According to user request:
        // Navigator.pushNamed(context, "/rideDetails", arguments: rideId);
        navigatorKey.currentState!.pushNamed("/rideDetails", arguments: rideId);
      }
    }
  }

  static void _handleNavigation(RemoteMessage message) {
    if (message.data['type'] == 'ride') {
      String? rideId = message.data['rideId'];
      if (rideId != null && navigatorKey.currentState != null) {
        navigatorKey.currentState!.pushNamed("/rideDetails", arguments: rideId);
      }
    }
  }
}
