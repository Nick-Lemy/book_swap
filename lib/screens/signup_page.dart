import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/link_text.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  static const Color _bg = Color(0xFF0B1026);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign up to get started',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 48),
              const CustomTextField(
                hintText: 'Full Name',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                hintText: 'Email',
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                hintText: 'Password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                hintText: 'Confirm Password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Create Account',
                onPressed: () {
                  // TODO: Implement sign up
                },
              ),
              const SizedBox(height: 24),
              LinkText(
                leadText: 'Already have an account? ',
                linkText: 'Login',
                onPressed: () => Navigator.pushNamed(context, '/login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
