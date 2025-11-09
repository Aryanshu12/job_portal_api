import 'dart:convert';
import 'package:flutter/material.dart';
import '../api/api_service.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
   ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;

  Future<void> resetPassword() async {
    final otp = otpController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (newPassword != confirm) {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text('Passwords do not match')));
      return;
    }

    setState(() => isLoading = true);
    try {
      final res = await ApiService.resetPassword(widget.email, otp, newPassword);
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final msg = data['message'] ?? 'Password reset successful';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>  LoginScreen()));
      } else {
        final message = data['error'] ?? data['message'] ?? 'Failed';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text('Reset Password')),
      body: Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Reset password for ${widget.email}'),
             SizedBox(height: 12),
            TextField(controller: otpController, decoration:  InputDecoration(labelText: 'Enter OTP')),
             SizedBox(height: 12),
            TextField(controller: newPasswordController, obscureText: true, decoration:  InputDecoration(labelText: 'New Password')),
             SizedBox(height: 12),
            TextField(controller: confirmPasswordController, obscureText: true, decoration:  InputDecoration(labelText: 'Confirm Password')),
             SizedBox(height: 16),
            isLoading ?  CircularProgressIndicator() : ElevatedButton(onPressed: resetPassword, child:  Text('Reset Password')),
          ],
        ),
      ),
    );
  }
}
