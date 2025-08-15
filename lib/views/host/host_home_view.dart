import 'package:eventzone_frontend/service/auth_service/auth_service.dart';
import 'package:flutter/material.dart';

import '../../service/auth_service/auth_gate.dart';
import 'add_event_screen.dart';
import 'host_profile_screen.dart';

class HostHomeView extends StatefulWidget {
  const HostHomeView({super.key});

  @override
  State<HostHomeView> createState() => _HostHomeViewState();
}

class _HostHomeViewState extends State<HostHomeView> {
  final _authService = AuthService();

  void _logout(BuildContext context) async {
    _authService.logout();
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    if (index == 1) {
      // Add Event button tapped
      _navigateToAddEventScreen();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _navigateToAddEventScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEventScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Host Home"),
        backgroundColor: Colors.deepPurple,
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
      body: Center(
        child: Text("Host screen index: $_selectedIndex"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex == 1 ? 0 : _selectedIndex, // don't highlight center button
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.indigo,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 28,
              ),
            ),
            label: '', // No label for center button
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'My Events',
          ),
        ],
      ),
    );
  }
}
