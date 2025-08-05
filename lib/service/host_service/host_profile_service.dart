import 'dart:convert';
import 'dart:io';
import 'package:eventzone_frontend/storage/storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

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

  Future<bool> updateProfile({
    required String clubName,
    required String description,
    required String phoneNumber,
    required String website,
    required String instagram,
    required String linkedin,
    File? logoImage,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/host/profile/update');
    final token = await storage.getToken();

    final request = http.MultipartRequest('PUT', uri);

    // Add JSON-encoded form data as one field
    final Map<String, dynamic> profileData = {
      "clubName": clubName,
      "clubDescription": description,
      "phoneNumber": phoneNumber,
      "website": website,
      "instagram": instagram,
      "linkedin": linkedin,
    };

    request.files.add(
      http.MultipartFile.fromString(
        'data',
        jsonEncode(profileData),
        contentType: MediaType('application', 'json'),
      ),
    );

    // Add image if selected
    if (logoImage != null) {
      final mimeType = lookupMimeType(logoImage.path);
      final mimeSplit = mimeType?.split('/') ?? ['image', 'jpeg'];

      request.files.add(
        await http.MultipartFile.fromPath(
          'logo',
          logoImage.path,
          contentType: MediaType(mimeSplit[0], mimeSplit[1]),
        ),
      );
    }

    request.headers['Authorization'] = 'Bearer $token';

    final response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      final body = await response.stream.bytesToString();
      throw Exception('Failed to update profile: $body');
    }
  }

}