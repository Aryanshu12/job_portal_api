import 'package:flutter/material.dart';
import '../utils/token_helper.dart';
import '../api/api_service.dart';
import 'login_screen.dart';
import 'dart:convert';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});

  Future<void> logout(BuildContext context) async {
    final refreshToken = await TokenHelper.getRefreshToken();
    if (refreshToken != null) {
      try {
        final res = await ApiService.logout(refreshToken);
        final data = jsonDecode(res.body);
        final msg = data['message'] ?? data['error'] ?? 'Logged out';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
    await TokenHelper.clearTokens();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) =>  LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Home'),
        actions: [
          IconButton(icon:  Icon(Icons.logout), onPressed: () => logout(context)),
        ],
      ),
      body:  Center(child: Text('Welcome to the Job Portal! 🎉')),
    );
  }
}
