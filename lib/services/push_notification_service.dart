import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ride_bridge_car/main.dart'; // To access navigatorKey
import 'package:ride_bridge_car/presentation/main_screen.dart';
import 'package:ride_bridge_car/presentation/widgets/top_notification_widget.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background message received: ${message.messageId}");
}

class PushNotificationService {
  static String? currentChatDocId;

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
      print("Foreground notification received: ${message.data}");

      // Prevent showing notification if the user is already in the same chat screen
      if (message.data['type'] == 'chat' &&
          message.data['chatDocId'] == currentChatDocId) {
        return;
      }

      if (message.notification != null &&
          navigatorKey.currentState?.context != null) {
        _showTopNotification(message);
      } else {
        // If there's no visible notification body, handle the logic silently as requested
        _handleMessage(message);
      }
    });

    // B. When App is in BACKGROUND and opened by click
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Background notification opened: ${message.data}");
      _handleNavigationWithRetry(message);
    });

    // C. When App is CLOSED (Terminated) and opened by click
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initialMessage != null) {
      print("Terminated notification opened: ${initialMessage.data}");
      _handleNavigationWithRetry(initialMessage);
    }
  }

  static void _showTopNotification(RemoteMessage message) {
    if (navigatorKey.currentState != null) {
      final overlay = Overlay.of(navigatorKey.currentState!.context);

      late OverlayEntry overlayEntry;
      overlayEntry = OverlayEntry(
        builder: (context) => TopNotificationWidget(
          title: message.notification?.title ?? "New Notification",
          body: message.notification?.body ?? "",
          onTap: () => _handleNavigationWithRetry(message),
          onDismiss: () => overlayEntry.remove(),
        ),
      );

      overlay.insert(overlayEntry);
    }
  }

  static void _handleMessage(RemoteMessage message) {
    _handleNavigationWithRetry(message);
  }

  static void _handleNavigationWithRetry(
    RemoteMessage message, [
    int retryCount = 0,
  ]) {
    if (navigatorKey.currentState == null) {
      if (retryCount < 10) {
        print(
          "Navigator not ready. Retrying navigation... (Attempt ${retryCount + 1})",
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          _handleNavigationWithRetry(message, retryCount + 1);
        });
      } else {
        print("Navigator still not ready after 10 attempts. Giving up.");
      }
      return;
    }

    _executeNavigation(message);
  }

  static void _executeNavigation(RemoteMessage message) {
    print("Executing navigation for payload: ${message.data}");
    final data = message.data;
    final type = data['type'];

    if (type == 'ride') {
      final String? rideId = data['ride_id'] ?? data['rideId'];
      if (rideId != null && navigatorKey.currentState != null) {
        print("Navigating to My Rides -> Ride Details: $rideId");

        // Go to MainScreen with My Rides tab (index 2)
        navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MainScreen(initialIndex: 2),
          ),
          (route) => false,
        );

        // Then push ride details
        Future.delayed(const Duration(milliseconds: 600), () {
          navigatorKey.currentState!.pushNamed(
            "/rideDetails",
            arguments: rideId,
          );
        });
      }
    } else if (type == 'chat') {
      final String? senderId = data['sender_id'] ?? data['senderId'];

      if (senderId != null && navigatorKey.currentState != null) {
        print("Navigating to Inbox tab for sender: $senderId");

        // Go to MainScreen with Inbox tab (index 3)
        navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MainScreen(initialIndex: 3),
          ),
          (route) => false,
        );
      } else {
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MainScreen(initialIndex: 0),
          ),
          (route) => false,
        );
      }
    }
  }
}
