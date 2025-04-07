import 'package:flutter/material.dart';

class AuthModeToggle extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onPressed;

  const AuthModeToggle({
    super.key,
    required this.isLogin,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text.rich(
        TextSpan(
          text: isLogin ? "Don't have an account? " : 'Already have an account? ',
          children: [
            TextSpan(
              text: isLogin ? 'Sign Up' : 'Sign In',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}