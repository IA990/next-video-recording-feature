import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8000'; // Adjust for emulator/device
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Save JWT token securely
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  // Read JWT token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // Delete JWT token (logout)
  static Future<void> deleteToken() async {
    await _storage.delete(key: 'jwt_token');
  }

  // Register user
  static Future<bool> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('\$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  // Login user and save token
  static Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('\$baseUrl/login'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'username': username,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await saveToken(data['access_token']);
      return true;
    }
    return false;
  }

  // Get auth headers with token
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer \$token',
    };
  }
}
