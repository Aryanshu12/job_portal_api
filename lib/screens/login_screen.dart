import 'dart:convert';
import 'package:flutter/material.dart';
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
  String selectedRole = 'user';
  final List<String> roles = ['user', 'candidate', 'recruiter'];
  bool isLoading = false;

  Future<void> login() async {
    setState(() => isLoading = true);
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      final res = await ApiService.login(email, password);
      final data = jsonDecode(res.body);

      if (res.statusCode == 200 && data['token'] != null) {
        final token = data['token'];
        final refresh = data['refreshToken'] ?? data['refresh_token'] ?? null;
        await TokenHelper.saveTokens(token, refresh);
        // assign role
        await ApiService.assignRole(email, selectedRole, token: token);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) =>  HomeScreen()),
        );
      } else {
        final message = data['error'] ?? data['message'] ?? 'Login failed';
        if (message.toString().toLowerCase().contains('not verified')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              action: SnackBarAction(
                label: 'Resend OTP',
                onPressed: () => resendOtp(email),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> resendOtp(String email) async {
    try {
      final res = await ApiService.resendOtp(email);
      final data = jsonDecode(res.body);
      final msg = data['message'] ?? data['error'] ?? 'OTP resent';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
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
            TextField(
              controller: emailController,
              decoration:  InputDecoration(labelText: 'Email'),
            ),
             SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration:  InputDecoration(labelText: 'Password'),
            ),
             SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: selectedRole,
              items: roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (v) => setState(() => selectedRole = v!),
              decoration:  InputDecoration(labelText: 'Role'),
            ),
             SizedBox(height: 20),
            isLoading
                ?  CircularProgressIndicator()
                : ElevatedButton(onPressed: login, child:  Text('Login')),
             SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  SignUpScreen())),
              child:  Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
