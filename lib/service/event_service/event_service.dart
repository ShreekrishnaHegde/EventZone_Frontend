import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../models/event_model.dart';
import '../../storage/storage.dart';
import '../auth_service/auth_service.dart';


class EventService {
  final String _baseUrl = dotenv.env['BASE_URL']!;
  final AuthService _authService = AuthService();
  final storage=Storage();

  Future<List<Event>> fetchAllEvents() async {
    final token = await storage.getToken();
    final response = await http.get(
      Uri.parse("$_baseUrl/all"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Event.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load events");
    }
  }

  Future<List<Event>> fetchRegisteredEvents() async {
    final token = await storage.getToken();
    final response = await http.get(
      Uri.parse("$_baseUrl/registered"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Event.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load registered events");
    }
  }

  Future<void> registerForEvent(int eventId) async {
    final token = await storage.getToken();
    final response = await http.post(
      Uri.parse("$_baseUrl/register/$eventId"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to register for event");
    }
  }
}
