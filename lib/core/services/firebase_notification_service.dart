// import 'dart:convert';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'dart:io';
//
// class FirebaseNotificationService {
//   FirebaseNotificationService._();
//   static final FirebaseNotificationService instance =
//   FirebaseNotificationService._();
//
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications =
//   FlutterLocalNotificationsPlugin();
//
//   /// Initialize Firebase Messaging and Local Notifications
//   Future<void> initialize() async {
//     try {
//       await _requestPermission();
//       await _initializeLocalNotifications();
//       await _createNotificationChannel();
//
//       _setupMessageHandlers();
//
//       debugPrint('Firebase Notification Service initialized successfully');
//     } catch (e) {
//       debugPrint('Error initializing Firebase Notification Service: $e');
//     }
//   }
//
//   /// Request notification permissions
//   Future<void> _requestPermission() async {
//     if (Platform.isIOS) {
//       final settings = await _firebaseMessaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//       debugPrint('Notification permission status: ${settings.authorizationStatus}');
//     } else if (Platform.isAndroid && (await _firebaseMessaging.getNotificationSettings()).authorizationStatus != AuthorizationStatus.authorized) {
//       // Android 13+
//       await _firebaseMessaging.requestPermission();
//     }
//   }
//
//   /// Initialize local notifications
//   Future<void> _initializeLocalNotifications() async {
//     const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iosSettings = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//
//     const initSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );
//
//     await _localNotifications.initialize(
//       onDidReceiveNotificationResponse: _onNotificationTapped, settings: initSettings,
//     );
//   }
//
//   /// Create notification channel (Android 8+)
//   Future<void> _createNotificationChannel() async {
//     if (Platform.isAndroid) {
//       const androidChannel = AndroidNotificationChannel(
//         'default_channel',
//         'Default Notifications',
//         description: 'General notifications for Educology',
//         importance: Importance.high,
//       );
//       await _localNotifications
//           .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(androidChannel);
//     }
//   }
//
//   /// Setup foreground/background message handlers
//   void _setupMessageHandlers() {
//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
//     _handleInitialMessage();
//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//   }
//
//   /// Foreground messages
//   Future<void> _handleForegroundMessage(RemoteMessage message) async {
//     debugPrint('Foreground message received: ${message.messageId}');
//     if (message.notification != null) {
//       await _showLocalNotification(message);
//     }
//   }
//
//   /// Show local notification
//   Future<void> _showLocalNotification(RemoteMessage message) async {
//     const androidDetails = AndroidNotificationDetails(
//       'default_channel',
//       'Default Notifications',
//       channelDescription: 'General notifications for Educology',
//       importance: Importance.high,
//       priority: Priority.high,
//       showWhen: true,
//       icon: '@mipmap/ic_launcher',
//     );
//
//     const iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//
//     const notificationDetails =
//     NotificationDetails(android: androidDetails, iOS: iosDetails);
//
//     await _localNotifications.show(
//         id: message.hashCode,
//         title: message.notification?.title ?? 'Educology',
//         body: message.notification?.body ?? '',
//         payload: jsonEncode(message.data),
//         notificationDetails: notificationDetails
//     );
//   }
//
//   /// Handle notification tap (background)
//   void _handleNotificationTap(RemoteMessage message) {
//     debugPrint('Notification tapped: ${message.messageId}');
//     _navigateBasedOnPayload(message.data);
//   }
//
//   /// Handle app launch from terminated state
//   Future<void> _handleInitialMessage() async {
//     final initialMessage = await _firebaseMessaging.getInitialMessage();
//     if (initialMessage != null) {
//       debugPrint('App opened from notification: ${initialMessage.messageId}');
//       _navigateBasedOnPayload(initialMessage.data);
//     }
//   }
//
//   /// Local notification tap
//   void _onNotificationTapped(NotificationResponse response) {
//     if (response.payload != null) {
//       try {
//         final data = jsonDecode(response.payload!) as Map<String, dynamic>;
//         _navigateBasedOnPayload(data);
//       } catch (e) {
//         debugPrint('Error parsing notification payload: $e');
//       }
//     }
//   }
//
//   /// Navigate based on payload
//   void _navigateBasedOnPayload(Map<String, dynamic> data) {
//     final type = data['type'] as String?;
//     final route = data['route'] as String?;
//     debugPrint('Notification payload - type: $type, route: $route');
//
//     if (route != null && route.isNotEmpty) {
//       Get.toNamed(route);
//     } else {
//       // switch (type) {
//       //   case 'donation':
//       //     break;
//       //   case 'reward':
//       //     break;
//       //   case 'profile':
//       //     break;
//       //   default:
//       //     debugPrint('Unknown notification type: $type');
//       // }
//     }
//   }
//
//   void onTokenRefresh(Function(String) callback) {
//     _firebaseMessaging.onTokenRefresh.listen(callback);
//   }
//
//   Future<void> deleteToken() async {
//     await _firebaseMessaging.deleteToken();
//   }
//
//   Future<void> subscribeToTopic(String topic) async {
//     await _firebaseMessaging.subscribeToTopic(topic);
//   }
//
//   Future<void> unsubscribeFromTopic(String topic) async {
//     await _firebaseMessaging.unsubscribeFromTopic(topic);
//   }
// }
//
// /// Background handler must be a top-level function
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   debugPrint('Background message: ${message.messageId}');
//   debugPrint('Title: ${message.notification?.title}');
//   debugPrint('Body: ${message.notification?.body}');
//   debugPrint('Data: ${message.data}');
//
//   // Optional: show local notification even in background
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   const androidDetails = AndroidNotificationDetails(
//     'default_channel',
//     'Default Notifications',
//     channelDescription: 'General notifications for Educology',
//     importance: Importance.high,
//     priority: Priority.high,
//     showWhen: true,
//   );
//
//   const iosDetails = DarwinNotificationDetails(
//     presentAlert: true,
//     presentBadge: true,
//     presentSound: true,
//   );
//
//   const notificationDetails =
//   NotificationDetails(android: androidDetails, iOS: iosDetails);
//
//   await flutterLocalNotificationsPlugin.show(
//     id: message.hashCode,
//     title: message.notification?.title ?? 'Educology',
//     body: message.notification?.body ?? '',
//     payload: jsonEncode(message.data),
//     notificationDetails: notificationDetails
//   );
// }
