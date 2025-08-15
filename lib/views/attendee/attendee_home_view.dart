import 'package:flutter/material.dart';
import '../../models/event_model.dart';
import '../../service/auth_service/auth_gate.dart';
import '../../service/auth_service/auth_service.dart';
import '../../service/event_service/event_service.dart';
import '../host/host_profile_screen.dart';

class AttendeeHomeView extends StatefulWidget {
  const AttendeeHomeView({super.key});

  @override
  State<AttendeeHomeView> createState() => _AttendeeHomeViewState();
}

class _AttendeeHomeViewState extends State<AttendeeHomeView> {
  final _authService = AuthService();
  final EventService _eventService = EventService();
  int _selectedIndex = 0;

  final List<Widget> _pages = [];
  void _logout(BuildContext context) async {
    _authService.logout();
  }
  @override
  void initState() {
    super.initState();
    // Pages for nav bar
    _pages.addAll([
      AllEventsScreen(eventService: _eventService),
      RegisteredEventsScreen(eventService: _eventService),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? "All Events" : "My Registered Events"),
        backgroundColor: Colors.deepPurple,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'All Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Registered',
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Text(
                      'H',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Colors.lightBlue,
                      ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HostProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: (){
                _logout(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => AuthGate()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AllEventsScreen extends StatelessWidget {
  final EventService eventService;
  const AllEventsScreen({super.key, required this.eventService});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: eventService.fetchAllEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No events found"));
        }

        final events = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.event),
                title: Text(event.title),
                // subtitle: Text(event.clubName),
                trailing: ElevatedButton(
                  onPressed: () async {
                    try {
                      // await eventService.registerForEvent(event.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Registered successfully")),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $e")),
                      );
                    }
                  },
                  child: const Text("Register"),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class RegisteredEventsScreen extends StatelessWidget {
  final EventService eventService;
  const RegisteredEventsScreen({super.key, required this.eventService});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: eventService.fetchRegisteredEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No registered events"));
        }

        final events = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text(event.title),
                // subtitle: Text(event.clubName),
              ),
            );
          },
        );
      },
    );
  }
}
