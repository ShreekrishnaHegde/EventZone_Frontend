import 'dart:convert';
import 'package:eventzone_frontend/storage/storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../models/host_profile.dart';

class HostProfileService{
  final _baseUrl = dotenv.env['BASE_URL']!;
  final storage=Storage();

  Future<HostProfile> fetchProfile() async {
    final token = await storage.getToken();
    if (token == null) throw Exception("Not Logged in ");

    final response = await http.get(
      Uri.parse("$_baseUrl/api/host/profile"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return HostProfile.fromJson(json.decode(response.body));
    } else {
      print("Fetch profile failed: ${response.body}");
      throw Exception("Failed to load profile");
    }
  }
}