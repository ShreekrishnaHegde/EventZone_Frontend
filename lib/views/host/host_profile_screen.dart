import 'package:eventzone_frontend/service/host_service/host_profile_service.dart';
import 'package:flutter/material.dart';

import '../../models/host_profile.dart';

class HostProfileScreen extends StatefulWidget {
  const HostProfileScreen({super.key});

  @override
  State<HostProfileScreen> createState() => _HostProfileScreenState();
}

class _HostProfileScreenState extends State<HostProfileScreen> {
  final _hostProfileService=HostProfileService();
  late Future<HostProfile> _profileFuture;
  @override
  void initState() {
    super.initState();
    _profileFuture = _hostProfileService.fetchProfile();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Host Profile"),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<HostProfile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final profile = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildReadOnlyField("Email", profile.email),
              _buildReadOnlyField("Role", profile.role),
              _buildReadOnlyField("Club Name", profile.clubName),
              _buildReadOnlyField("Description", profile.clubDescription),
              _buildReadOnlyField("Phone", profile.phoneNumber),
              _buildReadOnlyField("Website", profile.website),
              _buildReadOnlyField("Instagram", profile.instagram),
              _buildReadOnlyField("LinkedIn", profile.linkedin),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                onPressed: () {
                  // Navigate to edit screen (optional)
                },
                child: const Text("Edit Profile"),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        readOnly: true,
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
