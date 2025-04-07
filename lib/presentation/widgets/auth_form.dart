import 'package:assignment/presentation/widgets/text_input_field.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const AuthForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextInputField(
            controller: emailController,
            label: 'Email',
            icon: Icons.email_outlined,
            validator: (value) => value!.isEmpty ? 'Please enter email' : null,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          TextInputField(
            controller: passwordController,
            label: 'Password',
            icon: Icons.lock_outline,
            obscureText: true,
            validator: (value) => value!.isEmpty ? 'Please enter password' : null,
          ),
        ],
      ),
    );
  }
}
