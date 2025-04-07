import 'package:assignment/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? _currentFcmToken;

  Future<void> saveUser(User user) async {
    try {
      String? fcmToken = await _firebaseMessaging.getToken();
      _currentFcmToken = fcmToken;

      if (fcmToken != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'createdAt': FieldValue.serverTimestamp(),
          'fcmToken': fcmToken,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } else {
        // If no token, still save other user data
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _currentFcmToken = newToken;
        _updateUserToken(user.uid, newToken);
      });
    } catch (e) {
      print('Error saving user: $e');
      rethrow;
    }
  }

  Future<void> checkAndUpdateFcmToken(String userId) async {
    try {
      String? currentToken = await _firebaseMessaging.getToken();

      if (currentToken != null && currentToken != _currentFcmToken) {
        _currentFcmToken = currentToken;
        await _updateUserToken(userId, currentToken);
      }
    } catch (e) {
      print('Error checking FCM token: $e');
      rethrow;
    }
  }

  Future<void> _updateUserToken(String userId, String newToken) async {
    await _firestore.collection('users').doc(userId).update({
      'fcmToken': newToken,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeToken(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'fcmToken': FieldValue.delete(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<AppUser>> getUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return AppUser(
          uid: doc.id,
          email: doc.data()['email'] ?? 'No email',
          createdAt: (doc.data()['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList();
    });
  }
}