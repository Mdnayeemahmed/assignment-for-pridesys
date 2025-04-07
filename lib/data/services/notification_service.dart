import 'dart:developer';

import 'package:assignment/data/services/push_notification_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await _requestPermissions();
    await _setupFCMToken();
    await _initLocalNotifications();
    await _setupInteractedMessage();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false, // For iOS - request full permission immediately
    );

    print('Notification permission status: ${settings.authorizationStatus}');
  }

  Future<void> _setupFCMToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        print("FCM Token: $token");
        await _saveTokenToFirestore(token);
      }

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen(_saveTokenToFirestore);
    } catch (e) {
      print('Error getting FCM token: $e');
    }
  }

  Future<void> _saveTokenToFirestore(String token) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await _firestore.collection('users').doc(userId).update({
          'fcmToken': FieldValue.arrayUnion([token]),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
      },
    );
  }

  Future<void> _setupInteractedMessage() async {
    // Get any messages which caused the application to open from a terminated state
    RemoteMessage? initialMessage =
    await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });
  }

  void _handleMessage(RemoteMessage message) {
    // Handle the message when app is opened from notification
    print('Message opened: ${message.notification?.title}');
    // You can navigate to specific screen based on message data
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'high_importance_channel', // channelId
      'High Importance Notifications', // channelName
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: message.data.toString(),
    );
  }

  // Send push notification to all users (except excluded user)
  Future<void> sendNotificationToAllUsers(
      String title,
      String body,
      String? excludeUserId,
      Map<String, String>? data,
      ) async {
    try {
      // Get all FCM tokens from Firestore (excluding the specified user)
      final usersSnapshot = await _firestore.collection('users').get();
      final List<String> tokens = [];
      log(tokens.toString());

      for (var doc in usersSnapshot.docs) {
        if (excludeUserId == null || doc.id != excludeUserId) {
          final userData = doc.data();
          if (userData['fcmToken'] != null) {
            tokens.addAll((userData['fcmToken'] as List).cast<String>());
          }
        }
      }

      if (tokens.isEmpty) {
        print('No tokens to send notifications to');
        return;
      }
      print('Would send notification to ${tokens.length} devices');
      await PushNotificationService().sendPushNotification(tokens, title, body);

    } catch (e) {
      print('Error sending notifications: $e');
    }
  }
}

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}




