import 'package:assignment/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> saveUser(User user) async {
    try {
      // Get FCM token
      String? fcmToken = await _firebaseMessaging.getToken();

      await _firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
        'fcmTokens': fcmToken != null ? FieldValue.arrayUnion([fcmToken]) : [],
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Set up token refresh listener
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _updateUserToken(user.uid, newToken);
      });
    } catch (e) {
      print('Error saving user: $e');
      rethrow;
    }
  }

  Future<void> _updateUserToken(String userId, String newToken) async {
    await _firestore.collection('users').doc(userId).update({
      'fcmTokens': FieldValue.arrayUnion([newToken]),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeToken(String userId, String token) async {
    await _firestore.collection('users').doc(userId).update({
      'fcmTokens': FieldValue.arrayRemove([token]),
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
