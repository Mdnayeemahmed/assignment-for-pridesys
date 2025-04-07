import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'serverkey.dart';

class PushNotificationService {

  Future<void> sendPushNotification(List<String> tokens, String title, String body) async {
    final get = get_server_key();
    String servertoken = await get.server_token();

    log(tokens.toString());
    final url = Uri.parse('https://fcm.googleapis.com/v1/projects/assignment-6b580/messages:send');

    try {
      for (String token in tokens) {
        final response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $servertoken',
          },
          body: jsonEncode(<String, dynamic>{
            "message": {
              "token": token, // Using token for each user
              "notification": {
                "body": body,
                "title": title,
              },
              "data": {"id": "12345"}
            }
          }),
        );

        if (response.statusCode == 200) {
          print('Notification sent successfully to $token!');
        } else {
          print('Failed to send notification to $token: ${response.body}');
        }
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
