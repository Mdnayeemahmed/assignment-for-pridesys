import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/user_repository.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/notification_service.dart';
import '../../widgets/widgets.dart';

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
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _isLogin = ValueNotifier<bool>(true);
  final _isLoading = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    // _isLogin and _isLoading should not be disposed here
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _isLoading.value = true;

    try {
      final email = _emailController.text;
      final password = _passwordController.text;
      User? user;

      if (_isLogin.value) {
        user = await widget.authService.signIn(email, password);
      } else {
        user = await widget.authService.register(email, password);
        await widget.userRepository.saveUser(user!);

        try {
          await widget.notificationService.sendNotificationToAllUsers(
            'New User Registered',
            'A new user with email $email has joined!',
            user.uid,
            {'type': 'new_user', 'userId': user.uid},
          );
        } catch (e) {
          debugPrint('Notification error: $e');
        }
      }

      // On success, navigate to home screen
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));

    } on FirebaseAuthException catch (e) {
      _showAuthError(e);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void _showAuthError(FirebaseAuthException e) {
    final errorMessage = switch (e.code) {
      'invalid-email' => 'Invalid email address',
      'user-disabled' => 'This account has been disabled',
      'user-not-found' => 'No user found with this email',
      'wrong-password' => 'Incorrect password',
      'email-already-in-use' => 'This email is already registered',
      'weak-password' => 'Password must be at least 6 characters',
      _ => 'Authentication failed: ${e.message}',
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }

  void _toggleAuthMode() {
    _formKey.currentState?.reset();
    _isLogin.value = !_isLogin.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              ValueListenableBuilder<bool>(
                valueListenable: _isLogin,
                builder: (context, isLogin, _) {
                  return AuthHeader(isLogin: isLogin);
                },
              ),
              const SizedBox(height: 40),
              AuthForm(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
              ),
              const SizedBox(height: 24),
              ValueListenableBuilder<bool>(
                valueListenable: _isLoading,
                builder: (context, isLoading, _) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: _isLogin,
                    builder: (context, isLogin, _) {
                      return PrimaryButton(
                        isLoading: isLoading,
                        text: isLogin ? 'Sign In' : 'Sign Up',
                        onPressed: _submit,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<bool>(
                valueListenable: _isLogin,
                builder: (context, isLogin, _) {
                  return AuthModeToggle(
                    isLogin: isLogin,
                    onPressed: _toggleAuthMode,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
