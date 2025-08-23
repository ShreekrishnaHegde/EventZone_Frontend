import 'dart:convert';

class Event {
  String? id;
  final String? publicId;
  String title;
  String description;
  DateTime date;
  String? location;
  String? time;
  String? eventImageUrl;

  Event({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    this.location,
    this.time,
    this.eventImageUrl,
    this.publicId
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id']?.toString(),
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      time: json['time'],
      eventImageUrl: json['eventImageUrl'],
      publicId: json['publicId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "date": date.toIso8601String(),
      "location": location,
      "time": time,
    };
  }
}
