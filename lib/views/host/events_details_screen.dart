import 'package:flutter/material.dart';

class EventsDetailsScreen extends StatefulWidget {
  const EventsDetailsScreen({super.key});

  @override
  State<EventsDetailsScreen> createState() => _EventsDetailsScreenState();
}

class _EventsDetailsScreenState extends State<EventsDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(
        "Event Details"
      ),
    );
  }
}
