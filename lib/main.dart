import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_service.dart';
import 'user_repository.dart';
import 'notification_service.dart';

import 'user_model.dart';

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
      title: 'Firebase Auth Demo',
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



class LoginRegisterScreen extends StatefulWidget {
  final AuthService authService;
  final UserRepository userRepository;
  final NotificationService notificationService;

  const LoginRegisterScreen({
    super.key,
    required this.authService,
    required this.userRepository,
    required this.notificationService,
  });

  @override
  _LoginRegisterScreenState createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = '';
  String _password = '';

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      User? user;

      if (_isLogin) {
        // Login logic
        user = await widget.authService.signIn(_email, _password);
        if (user == null) {
          throw Exception('Login failed - no user returned');
        }
      } else {
        // Registration logic
        user = await widget.authService.register(_email, _password);
        if (user == null) {
          throw Exception('Registration failed - no user returned');
        }

        // Save user to Firestore
        await widget.userRepository.saveUser(user);

        // Send notification to all other users
        try {
          await widget.notificationService.sendNotificationToAllUsers(
            'New User Registered',
            'A new user with email $_email has joined!',
            user.uid,
            {'type': 'new_user', 'userId': user.uid},
          );
        } catch (notificationError) {
          print('Failed to send notification: $notificationError');
          // Notification failure shouldn't block registration
        }
      }

      // If we got here, authentication was successful
      // You might want to navigate to home screen here
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));

    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password';
          break;
        case 'email-already-in-use':
          errorMessage = 'This email is already registered';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak';
          break;
        default:
          errorMessage = 'Authentication failed: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: ${e.toString()}')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                value!.isEmpty ? 'Please enter email' : null,
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                value!.isEmpty ? 'Please enter password' : null,
                onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_isLogin ? 'Login' : 'Register'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: Text(_isLogin
                    ? 'Need an account? Register'
                    : 'Have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class UserListScreen extends StatelessWidget {
  final UserRepository userRepository;
  final AuthService authService;

  const UserListScreen({
    super.key,
    required this.userRepository,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<AppUser>>(
        stream: userRepository.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data ?? [];

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.email),
                subtitle: Text('Joined: ${user.createdAt.toString()}'),
              );
            },
          );
        },
      ),
    );
  }
}