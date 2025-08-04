import 'package:flutter/material.dart';

class AttendeeHomeView extends StatefulWidget {
  const AttendeeHomeView({super.key});

  @override
  State<AttendeeHomeView> createState() => _AttendeeHomeViewState();
}

class _AttendeeHomeViewState extends State<AttendeeHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Attendee"
        ),
      ),
    );
  }
}
