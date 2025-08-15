import 'dart:io';

import 'package:flutter/material.dart';

import '../../models/attendee_profile.dart';
import '../../service/attendee_service/attendee_profile_service.dart';

class AttendeeProfileScreen extends StatefulWidget {
  const AttendeeProfileScreen({super.key});

  @override
  State<AttendeeProfileScreen> createState() => _AttendeeProfileScreenState();


}

class _AttendeeProfileScreenState extends State<AttendeeProfileScreen> {
  final _attendeeProfileService = AttendeeProfileService();
  late Future<AttendeeProfile> _profileFuture;
  final _formKey = GlobalKey<FormState>();


  final TextEditingController _fullnameController=TextEditingController();
  final TextEditingController _collegeNameController=TextEditingController();
  final TextEditingController _branchNameController=TextEditingController();
  final TextEditingController _USNController=TextEditingController();


  File? _logoImage;

  InputDecoration buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: Colors.grey.shade100,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(16.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF140447), width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: const Color(0xFF140447),
    minimumSize: const Size(double.infinity, 50),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  );
  @override
  void initState() {
    super.initState();
    _profileFuture = _attendeeProfileService.fetchProfile();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendee Profile"),
        backgroundColor: const Color(0xFF140447),
      ),
      body: FutureBuilder<AttendeeProfile>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final profile = snapshot.data!;
          _fullnameController.text=profile.fullname;
          _collegeNameController.text=profile.collegeName;
          _branchNameController.text=profile.branchName;
          _USNController.text=profile.USN;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // GestureDetector(
                  //   onTap: () => _showImageOptions(profile.clubLogo),
                  //   child: CircleAvatar(
                  //     radius: 50,
                  //     backgroundColor: Colors.grey[300],
                  //     backgroundImage: _logoImage != null
                  //         ? FileImage(_logoImage!) as ImageProvider
                  //         : (profile.clubLogo != null && profile.clubLogo!.isNotEmpty
                  //         ? NetworkImage(profile.clubLogo)
                  //         : null),
                  //     child: _logoImage == null && (profile.clubLogo.isEmpty)
                  //         ? const Icon(Icons.add_a_photo, size: 30, color: Colors.grey)
                  //         : null,
                  //   ),
                  // ),

                  const SizedBox(height: 20),

                  TextFormField(
                    readOnly: true,
                    initialValue: profile.email,
                    decoration: buildInputDecoration("Email", Icons.email),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    readOnly: true,
                    initialValue: profile.role,
                    decoration: buildInputDecoration("Role", Icons.person),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _fullnameController,
                    decoration: buildInputDecoration("Full Name", Icons.home),
                    validator: (value) => value == null || value.isEmpty ? "Enter Full name" : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _collegeNameController,
                    maxLines: 3,
                    decoration: buildInputDecoration("College", Icons.description),
                    validator: (value) => value == null || value.isEmpty ? "Enter College Name" : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _branchNameController,
                    decoration: buildInputDecoration("Branch", Icons.phone),
                    validator: (value) => value == null || value.isEmpty ? "Enter branch name" : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _USNController,
                    decoration: buildInputDecoration("USN", Icons.language),
                    validator: (value) => value == null || value.isEmpty ? "Enter USN" : null,
                  ),
                  const SizedBox(height: 12),

                  ElevatedButton.icon(
                    style: raisedButtonStyle,
                    // onPressed: _saveProfile,
                    onPressed: (){},
                    icon: const Icon(Icons.save),
                    label: const Text("Save Profile"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
