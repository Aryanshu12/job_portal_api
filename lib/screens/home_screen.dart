import 'package:flutter/material.dart';
import '../utils/token_helper.dart';
import '../api/api_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});

  Future<void> logout(BuildContext context) async {
    final refresh = await TokenHelper.getRefreshToken();
    if (refresh != null) {
      try {
        final res = await ApiService.logout(refresh);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message ?? res.error ?? 'Logged out')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: \$e')));
      }
    }
    await TokenHelper.clearTokens();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) =>  LoginScreen()), (r) => false);
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
      body:  Center(child: Text('Welcome to Job Portal!')),
    );
  }
}
