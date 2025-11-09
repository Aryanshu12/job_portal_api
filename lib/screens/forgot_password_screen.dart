import 'dart:convert';
import 'package:flutter/material.dart';
import '../api/api_service.dart';
import 'reset_password_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  bool isLoading = false;

  Future<void> forgotPassword() async {
    setState(() => isLoading = true);
    final email = emailController.text.trim();
    try {
      final res = await ApiService.forgotPassword(email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message ?? res.error ?? 'OTP sent')));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResetPasswordScreen(email: email)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: \$e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enter your registered email to receive a password reset OTP.'),
            const SizedBox(height: 12),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            isLoading ? const CircularProgressIndicator() : ElevatedButton(onPressed: forgotPassword, child: const Text('Send OTP')),
          ],
        ),
      ),
    );
  }
}
