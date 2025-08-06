import 'package:flutter/material.dart';

import '../../service/auth_service/auth_service.dart';

class AttendeeHomeView extends StatefulWidget {
  const AttendeeHomeView({super.key});

  @override
  State<AttendeeHomeView> createState() => _AttendeeHomeViewState();
}

class _AttendeeHomeViewState extends State<AttendeeHomeView> {
  List<Map<String, String>> get dummyEvents => [
    {
      "title": "Tech Conference 2025",
      "description": "Join us for the latest in AI, Flutter, and more!",
      "date": "Aug 10, 2025",
    },
    {
      "title": "Music Fest",
      "description": "Experience a night of electrifying live music!",
      "date": "Aug 15, 2025",
    },
    {
      "title": "Startup Pitch Night",
      "description": "Watch startups pitch their next big idea.",
      "date": "Aug 20, 2025",
    },
  ];
  final AuthService _authService=AuthService();
  void _logout(BuildContext context) async {
    await _authService.logout();
    Navigator.pushReplacementNamed(context, '/login'); // Adjust to your login route
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendee Home"),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.person, size: 48, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "Welcome Attendee",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.pop(context); // Close drawer
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile screen coming soon")),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: dummyEvents.length,
          itemBuilder: (context, index) {
            final event = dummyEvents[index];
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  event['title']!,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(event['description']!),
                    const SizedBox(height: 6),
                    Text(
                      "📅 ${event['date']}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
