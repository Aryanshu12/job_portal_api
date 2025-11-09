import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_response_model.dart';
import '../models/otp_response_model.dart';
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = 'https://job-portal-my15.onrender.com/api/auth';

  static Future<AuthResponseModel> register(String name, String email, String password, String role) async {
    final res = await http.post(Uri.parse('\$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password, 'role': role}),
    );
    return AuthResponseModel.fromJson(_decode(res.body));
  }

  static Future<AuthResponseModel> login(String email, String password) async {
    final res = await http.post(Uri.parse('\$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return AuthResponseModel.fromJson(_decode(res.body));
  }

  static Future<OtpResponseModel> verifyOtp(String email, String otp) async {
    final res = await http.post(Uri.parse('\$baseUrl/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );
    return OtpResponseModel.fromJson(_decode(res.body));
  }

  static Future<OtpResponseModel> resendOtp(String email) async {
    final res = await http.post(Uri.parse('\$baseUrl/resend-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return OtpResponseModel.fromJson(_decode(res.body));
  }

  static Future<OtpResponseModel> assignRole(String email, String role, {String? token}) async {
    final headers = {'Content-Type': 'application/json'};
    if (token != null) headers['Authorization'] = 'Bearer \$token';
    final res = await http.post(Uri.parse('\$baseUrl/assign-role'),
      headers: headers,
      body: jsonEncode({'email': email, 'role': role}),
    );
    return OtpResponseModel.fromJson(_decode(res.body));
  }

  static Future<OtpResponseModel> forgotPassword(String email) async {
    final res = await http.post(Uri.parse('\$baseUrl/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return OtpResponseModel.fromJson(_decode(res.body));
  }

  static Future<OtpResponseModel> resetPassword(String email, String otp, String newPassword) async {
    final res = await http.post(Uri.parse('\$baseUrl/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp, 'newPassword': newPassword}),
    );
    return OtpResponseModel.fromJson(_decode(res.body));
  }

  static Future<AuthResponseModel> refreshToken(String refreshToken) async {
    final res = await http.post(Uri.parse('\$baseUrl/refresh-token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );
    return AuthResponseModel.fromJson(_decode(res.body));
  }

  static Future<OtpResponseModel> logout(String refreshToken) async {
    final res = await http.post(Uri.parse('\$baseUrl/logout'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );
    return OtpResponseModel.fromJson(_decode(res.body));
  }

  static Map<String, dynamic> _decode(String body) {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return {'error': body};
    }
  }
}
