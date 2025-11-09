import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../api/api_service.dart';
import 'login_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
   VerifyOtpScreen({super.key, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final otpController = TextEditingController();
  bool isLoading = false;

  Future<void> verifyOtp() async {
    setState(() => isLoading = true);
    try {
      final res = await ApiService.verifyOtp(widget.email, otpController.text.trim());
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final msg = data['message'] ?? 'Verified';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>  LoginScreen()));
      } else {
        final message = data['error'] ?? data['message'] ?? 'Verification failed';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> resend() async {
    try {
      final res = await ApiService.resendOtp(widget.email);
      final data = jsonDecode(res.body);
      final msg = data['message'] ?? data['error'] ?? 'OTP resent';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text('Verify OTP')),
      body: Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Verification for ${widget.email}'),
             SizedBox(height: 12),
            TextField(controller: otpController, decoration:  InputDecoration(labelText: 'Enter OTP')),
             SizedBox(height: 12),
            isLoading ?  CircularProgressIndicator() : ElevatedButton(onPressed: verifyOtp, child:  Text('Verify OTP')),
            TextButton(onPressed: resend, child:  Text('Resend OTP')),
          ],
        ),
      ),
    );
  }
}
