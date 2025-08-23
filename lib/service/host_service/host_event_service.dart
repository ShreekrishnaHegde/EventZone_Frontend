import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../models/event_model.dart';
import '../../storage/storage.dart';

class HostEventService {
  final _baseUrl = dotenv.env['BASE_URL']!;
  final storage=Storage();

  Future<List<Event>> getAllEvents() async {
    final res = await http.get(Uri.parse(_baseUrl));
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((e) => Event.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch events");
    }
  }

  Future<bool> createEvent({
    Event? eventData,
    File? imageFile,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/events/create');
    final token = await storage.getToken();
    final request = http.MultipartRequest('POST', uri);
    request.files.add(
      http.MultipartFile.fromString(
        'data',
        jsonEncode(eventData),
        contentType: MediaType('application', 'json'),
      ),
    );

    // Image file if provided
    if (imageFile != null) {
      final mimeType = lookupMimeType(imageFile.path);
      final mimeSplit = mimeType?.split('/') ?? ['image', 'jpeg'];

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType(mimeSplit[0], mimeSplit[1]),
        ),
      );
    }
    request.headers['Authorization'] = 'Bearer $token';
    final response = await request.send();
    return response.statusCode == 200 || response.statusCode == 201;
  }


  Future<bool> updateEvent({
    required String title,
    required String description,
    required DateTime date,
    required String location,
    required String time,
    File? imageFile,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/events/update');
    final token = await storage.getToken();
    final request = http.MultipartRequest('PUT', uri);
    final Map<String, dynamic> eventData = {
      "title": title,
      "description": description,
      "date": date.toIso8601String(),
      "location": location,
      "time": time,
    };
    request.files.add(
      http.MultipartFile.fromString(
        'data',
        jsonEncode(eventData),
        contentType: MediaType('application', 'json'),
      ),
    );

    // Image file if provided
    if (imageFile != null) {
      final mimeType = lookupMimeType(imageFile.path);
      final mimeSplit = mimeType?.split('/') ?? ['image', 'jpeg'];

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType(mimeSplit[0], mimeSplit[1]),
        ),
      );
    }
    request.headers['Authorization'] = 'Bearer $token';
    final response = await request.send();
    return response.statusCode == 200 || response.statusCode == 201;
  }

}
