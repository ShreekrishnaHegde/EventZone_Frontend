import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../models/auth_response.dart';
import '../../storage/storage.dart';

class AuthService {
  final _baseUrl = dotenv.env['BASE_URL']!;
  final Storage _storage = Storage();

  Future<AuthResponse?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final auth = AuthResponse.fromJson(json);
      await _storage.saveToken(auth.token);
      return auth;
    }
    throw Exception('Login failed');
  }

  Future<AuthResponse?> signupAttendee(String email, String password,String fullname) async {

    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/signup/attendee'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password,'fullname':fullname}),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final auth = AuthResponse.fromJson(json);
      await _storage.saveToken(auth.token);
      return auth;
    }
    else{
      print("Error: ${response.body}");
    }
    throw Exception('Signup failed');
  }
  Future<AuthResponse?> signupHost( String email, String password,String fullname) async {

    final response = await http.post(
      Uri.parse('$_baseUrl/api/auth/signup/host'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password,'fullname':fullname}),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final auth = AuthResponse.fromJson(json);
      await _storage.saveToken(auth.token);
      return auth;
    }
    throw Exception('Signup failed');
  }


  Future<AuthResponse?> getCurrentUser() async {
    final token = await _storage.getToken();
    if (token == null) return null;

    final payload = jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(token.split(".")[1]))),
    );

    return AuthResponse(
      token: token,
      email: payload["sub"],
      role: payload["role"],
    );
  }

  Future<void> logout() => _storage.deleteToken();
}