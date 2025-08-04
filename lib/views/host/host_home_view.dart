import 'package:eventzone_frontend/service/auth_service/auth_service.dart';
import 'package:flutter/material.dart';

class HostHomeView extends StatefulWidget {
  const HostHomeView({super.key});

  @override
  State<HostHomeView> createState() => _HostHomeViewState();
}

class _HostHomeViewState extends State<HostHomeView> {
  final _authService=AuthService();
  void _logout(BuildContext context)async{
    _authService.logout();
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.person, size: 48, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "Welcome Host",
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
      body: Center(
        child: Text(
          "Host"
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // currentIndex: _selectedIndex == 1 ? 0 : _selectedIndex,
        // onTap: _onItemTapped,
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
            label: '', // Empty label for center icon
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
