import 'package:eventzone_frontend/service/auth_service/auth_service.dart';
import 'package:eventzone_frontend/views/host/my_events_screen.dart';
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
  int _selectedIndex = 0;

  void _logout() {
    _authService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) =>  AuthGate()),
    );
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddEventScreen()),
      );
    }
    else {
      setState(() => _selectedIndex = index);
    }
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const Center(child: Text("Welcome to Host Dashboard"));
      case 2:
        return const MyEventsScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EventZone Host"),
        backgroundColor: Colors.indigo.shade700,
        centerTitle: true,
        elevation: 2,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo.shade700),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.indigo),
              ),
              accountName: const Text("Host User"),
              accountEmail: const Text("host@example.com"),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HostProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey.shade500,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 0 ? Icons.home_rounded : Icons.home_outlined,
              size: _selectedIndex == 0 ? 30 : 26,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF3F51B5), Color(0xFF1A237E)], // Indigo gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.add_rounded,
                size: 28,
                color: Colors.white,
              ),
            ),
            label: "Add",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 2 ? Icons.event_note_rounded : Icons.event_note_outlined,
              size: _selectedIndex == 2 ? 30 : 26,
            ),
            label: "My Events",
          ),
        ],
      )
    );
  }
}
