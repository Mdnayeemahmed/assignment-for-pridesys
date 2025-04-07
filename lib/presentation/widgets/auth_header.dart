import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final bool isLogin;

  const AuthHeader({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          isLogin ? 'Welcome Back' : 'Create Account',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isLogin ? 'Sign in to continue' : 'Get started with us',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
