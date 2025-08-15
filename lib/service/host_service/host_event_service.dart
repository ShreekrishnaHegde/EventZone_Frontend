import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../models/event_model.dart';
import '../../storage/storage.dart';

class EventService {
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

  Future<bool> createOrUpdateEvent({
    String? eventId,
    required String title,
    required String description,
    required DateTime date,
    required String location,
    required String time,
    File? imageFile,
  }) async {
    final uri = Uri.parse(
      eventId == null
          ? '$_baseUrl/api/events/create'
          : '$_baseUrl/api/events/$eventId',
    );

    final token = await storage.getToken();
    final request = http.MultipartRequest(
      eventId == null ? 'POST' : 'PUT',
      uri,
    );


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


  Future<Event> updateEvent(String id, Event event) async {
    final res = await http.put(
      Uri.parse("$_baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(event.toJson()),
    );

    if (res.statusCode == 200) {
      return Event.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("Failed to update event");
    }
  }

  Future<void> deleteEvent(String id) async {
    final res = await http.delete(Uri.parse("$_baseUrl/$id"));
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception("Failed to delete event");
    }
  }

  Future<String> uploadImage(File file) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://localhost:8080/api/events/upload"), // backend upload endpoint
    );
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return respStr; // image URL returned from backend
    } else {
      throw Exception("Image upload failed");
    }
  }
}
