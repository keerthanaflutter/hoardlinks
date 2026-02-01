
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hoardlinks/core/constants/loginToken_constant.dart';
import 'package:hoardlinks/views/dashboard/dashboardoriginal_screen.dart.dart';
import 'package:hoardlinks/views/home/chitty/chittydetails_screen.dart';


// class PushnotificationService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   Future<void> initFCM() async {
//     try {
//       // 1️⃣ Ask permission to show notifications
//       final settings = await _firebaseMessaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//       print("🔔 Permission status: ${settings.authorizationStatus}");

//       // 2️⃣ Get FCM token and save it
//       final token = await _firebaseMessaging.getToken();
//       if (token != null) {
//         print("🔥 FCM TOKEN: $token");
//         await AuthStorage.saveFcmToken(token);  // Save FCM token in SharedPreferences
//       }

//       // 🔄 Listen for token refresh
//       FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
//         print("🔄 FCM TOKEN REFRESHED: $newToken");
//         await AuthStorage.saveFcmToken(newToken);  // Save the refreshed token
//       });

//       // 3️⃣ Foreground message handler (when the app is in the foreground)
//       FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//         print("📩 Foreground: ${message.notification?.title}");
//         // You can perform further actions, like showing a notification or updating the UI
//       });

//       // 4️⃣ Notification tapped handler (when the app is in the background or killed)
//       FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//         print("📬 Opened app from notification: ${message.notification?.title}");
//         _navigateToNotification(message);
//       });

//       // 5️⃣ Handle notification tap when the app is completely killed
//       final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//       if (initialMessage != null) {
//         print("📬 App opened from killed state: ${initialMessage.notification?.title}");
//         _navigateToNotification(initialMessage);
//       }
//     } catch (e) {
//       print("❌ FCM init error: $e");
//     }
//   }

//   // Navigate based on notification data
//   void _navigateToNotification(RemoteMessage message) {
//     final data = message.data;
//     final String? type = data['type'];
//     final String? chittyId = data['chitty_id'];
//     final String? memberId = data['member_id'];
//     final String? title = message.notification?.title;
//     final String? body = message.notification?.body;

//     // Based on notification type, navigate to the appropriate screen
//     if (type == 'ChittyApproved') {
//       AppNavigator.navigatorKey.currentState?.push(
//         MaterialPageRoute(
//           builder: (_) => ChittyDetailsScreen(
//             chittyId: int.parse(chittyId!),  // Pass the chittyId to the screen
//           ),
//         ),
//       );
//     } else if (type == 'ChittyRejected') {
//       // Navigate to DashboardScreen and set the tab to ChittyScreen
//       AppNavigator.navigatorKey.currentState?.push(
//         MaterialPageRoute(
//           builder: (_) => DashboardScreen(selectedIndex: 2), // Navigate to ChittyScreen (index 2)
//         ),
//       );
//     } else {
//       // Fallback screen if type is not recognized
//       // AppNavigator.navigatorKey.currentState?.push(
//       //   MaterialPageRoute(
//       //     builder: (_) => NotificationScreen(
//       //       title: title,
//       //       body: body,
//       //     ),
//       //   ),
//       // );
//     }
//   }
// }



import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushnotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  
  // 1️⃣ Initialize Local Notifications Plugin
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();

  Future<void> initFCM() async {
    try {
      // 2️⃣ Request Permissions
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // 3️⃣ Setup Local Notifications for Foreground
      await _initLocalNotifications();

      // 4️⃣ Get and Save Token
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        print("🔥 FCM TOKEN: $token");
        // await AuthStorage.saveFcmToken(token);
      }

      // 5️⃣ Handle Foreground Messages (THE FIX)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("📩 Foreground Message Received");
        
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        // Manually show the notification popup
        if (notification != null && android != null) {
          _localNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel', // id
                'High Importance Notifications', // title
                importance: Importance.max,
                priority: Priority.high,
                icon: android.smallIcon, // Use app icon
              ),
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
            payload: message.data.toString(), // Optional: for tap handling
          );
        }
      });

      // 6️⃣ Handle Background/Killed Clicks
      FirebaseMessaging.onMessageOpenedApp.listen(_navigateToNotification);
      
      final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        _navigateToNotification(initialMessage);
      }

    } catch (e) {
      print("❌ FCM init error: $e");
    }
  }

  // Helper to initialize local notification settings
  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    
    const initSettings = InitializationSettings(
      android: androidSettings, 
      iOS: iosSettings
    );

    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // Handle tap on foreground notification if needed
      },
    );
  }

  void _navigateToNotification(RemoteMessage message) {
    final data = message.data;
    final String? type = data['type'];
    final String? chittyId = data['chitty_id'];

    if (type == 'ChittyApproved' && chittyId != null) {
      AppNavigator.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => ChittyDetailsScreen(chittyId: int.parse(chittyId)),
        ),
      );
    } else if (type == 'ChittyRejected') {
      AppNavigator.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => const DashboardScreen(selectedIndex: 2),
        ),
      );
    }
  }
}

class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}