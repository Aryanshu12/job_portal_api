import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:job_portal_api/screens/forgot_password_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';
import '../utils/token_helper.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
   LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> login() async {
    setState(() => isLoading = true);
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      final res = await ApiService.login(email, password);
      if (res.token != null) {
        final token = res.token!;
        final refresh = res.refreshToken;
        await TokenHelper.saveTokens(token, refresh);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>  HomeScreen()));
      } else {
        final message = res.error ?? res.message ?? 'Login failed';
        if (message.toLowerCase().contains('not verified')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              action: SnackBarAction(label: 'Resend OTP', onPressed: () => resendOtp(email)),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: \$e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> resendOtp(String email) async {
    try {
      final res = await ApiService.resendOtp(email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message ?? res.error ?? 'OTP resent')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: \$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text('Login')),
      body: Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: emailController, decoration:  InputDecoration(labelText: 'Email')),
             SizedBox(height: 12),
            TextField(controller: passwordController, obscureText: true, decoration:  InputDecoration(labelText: 'Password')),
             SizedBox(height: 20),
            isLoading ?  CircularProgressIndicator() : ElevatedButton(onPressed: login, child:  Text('Login')),
             SizedBox(height: 10),
            TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  SignUpScreen())), child:  Text('Don\'t have an account? Sign Up')),
            TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  ForgotPasswordScreen())), child:  Text('Forgot Password?')),
          ],
        ),
      ),
    );
  }
}
