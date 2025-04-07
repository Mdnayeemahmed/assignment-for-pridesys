import 'dart:developer';

import 'package:assignment/data/services/push_notification_services.dart';
// import 'package:firebase_auth/firebase_auth.dart';
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
    RemoteMessage? initialMessage =
    await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });
  }

  void _handleMessage(RemoteMessage message) {
    print('Message opened: ${message.notification?.title}');
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

  Future<void> sendNotificationToAllUsers(
      String title,
      String body,
      String? excludeUserId,
      Map<String, String>? data,
      ) async {
    try {
      final usersSnapshot = await _firestore.collection('users').get();
      final List<String> tokens = [];

      for (var doc in usersSnapshot.docs) {
        if (excludeUserId == null || doc.id != excludeUserId) {
          final userData = doc.data();
          if (userData['fcmToken'] != null) {
            final fcmToken = userData['fcmToken'];
            if (fcmToken is String) {
              tokens.add(fcmToken);
            } else if (fcmToken is List) {
              tokens.addAll(fcmToken.cast<String>());
            }
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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}




