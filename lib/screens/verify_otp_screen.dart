import 'dart:convert';
import 'package:flutter/material.dart';
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
      if (res.success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message ?? 'Verified')));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>  LoginScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.error ?? 'Verification failed')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: \$e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> resend() async {
    try {
      final res = await ApiService.resendOtp(widget.email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message ?? res.error ?? 'OTP resent')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: \$e')));
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
            Text('Verification for \${widget.email}'),
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
