import 'dart:convert';
import 'package:flutter/material.dart';
import '../api/api_service.dart';
import 'verify_otp_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedRole = 'JOBSEEKER';
  final List<String> roles = ['JOBSEEKER', 'JOBGIVER'];
  bool isLoading = false;

  Future<void> signup() async {
    setState(() => isLoading = true);
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final role = selectedRole;

    try {
      final res = await ApiService.register(name, email, password, role);
      if (res.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message!)));
      }
      // after signup, navigate to verify OTP
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => VerifyOtpScreen(email: email)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: \$e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            const SizedBox(height: 12),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedRole,
              items: roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (v) => setState(() => selectedRole = v!),
              decoration: const InputDecoration(labelText: 'Role'),
            ),
            const SizedBox(height: 20),
            isLoading ? const CircularProgressIndicator() : ElevatedButton(onPressed: signup, child: const Text('Sign Up')),
          ],
        ),
      ),
    );
  }
}
