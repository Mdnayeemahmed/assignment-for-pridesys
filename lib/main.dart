import 'package:assignment/presentation/ui/user_list/user_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/services/auth_service.dart';
import 'data/services/service_locator.dart';
import 'presentation/ui/auth/login_register_screen.dart';
import 'core/user_repository.dart';
import 'data/services/notification_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();
  final UserRepository _userRepository = UserRepository();
  final NotificationService _notificationService = NotificationService();

  MyApp({super.key}) {
    _notificationService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StreamBuilder<User?>(
        stream: _authService.user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return UserListScreen(
              userRepository: _userRepository,
              authService: _authService,
            );
          }
          return LoginRegisterScreen(
            authService: _authService,
            userRepository: _userRepository,
            notificationService: _notificationService,
          );
        },
      ),
    );
  }
}






