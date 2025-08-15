import 'dart:convert';

import 'package:eventzone_frontend/models/attendee_profile.dart';
import 'package:eventzone_frontend/storage/storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AttendeeProfileService{
  final _baseUrl=dotenv.env['BASE_URL']!;
  final storage=Storage();

  Future<AttendeeProfile> fetchProfile() async{
    final token = await storage.getToken();
    if (token == null) throw Exception("Not Logged in ");

    final response = await http.get(
      Uri.parse("$_baseUrl/api/attendee/profile"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return AttendeeProfile.fromJson(json.decode(response.body));
    } else {
      print("Fetch profile failed: ${response.body}");
      throw Exception("Failed to load profile");
    }
  }


}