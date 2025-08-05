import 'dart:io';

import 'package:eventzone_frontend/service/host_service/host_profile_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/host_profile.dart';

class HostProfileScreen extends StatefulWidget {
  const HostProfileScreen({super.key});

  @override
  State<HostProfileScreen> createState() => _HostProfileScreenState();
}

class _HostProfileScreenState extends State<HostProfileScreen> {
  final _hostProfileService = HostProfileService();
  late Future<HostProfile> _profileFuture;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _clubNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();

  File? _logoImage;

  @override
  void initState() {
    super.initState();
    _profileFuture = _hostProfileService.fetchProfile();
  }

  void _handleLogoTap() async {
    if (_logoImage == null) {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null && mounted) {
        setState(() {
          _logoImage = File(picked.path);
        });
      }
    } else {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Remove Logo"),
          content: const Text("Do you want to remove the selected image?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Remove")),
          ],
        ),
      );

      if (confirm == true && mounted) {
        setState(() {
          _logoImage = null;
        });
      }
    }
  }

  void _saveProfile() async {
    // if (_formKey.currentState!.validate()) {
      try {
        final success = await _hostProfileService.updateProfile(
          clubName: _clubNameController.text,
          description: _descriptionController.text,
          phoneNumber: _phoneController.text,
          website: _websiteController.text,
          instagram: _instagramController.text,
          linkedin: _linkedinController.text,
          logoImage: _logoImage,
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated successfully")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update profile: $e")),
        );
      }
    // }
  }


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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Host Profile"),
        backgroundColor: const Color(0xFF140447),
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
          _clubNameController.text = profile.clubName;
          _descriptionController.text = profile.clubDescription;
          _phoneController.text = profile.phoneNumber;
          _websiteController.text = profile.website;
          _instagramController.text = profile.instagram;
          _linkedinController.text = profile.linkedin;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _handleLogoTap,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _logoImage != null ? FileImage(_logoImage!) : null,
                          child: _logoImage == null
                              ? const Icon(Icons.add_a_photo, size: 30, color: Colors.grey)
                              : null,
                        ),
                        if (_logoImage != null)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.white,
                              child: const Icon(Icons.delete, size: 18, color: Colors.redAccent),
                            ),
                          ),
                      ],
                    ),
                  ),
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
                    controller: _clubNameController,
                    decoration: buildInputDecoration("Club Name", Icons.home),
                    validator: (value) => value == null || value.isEmpty ? "Enter club name" : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: buildInputDecoration("Description", Icons.description),
                    validator: (value) => value == null || value.isEmpty ? "Enter description" : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _phoneController,
                    decoration: buildInputDecoration("Phone", Icons.phone),
                    validator: (value) => value == null || value.isEmpty ? "Enter phone" : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _websiteController,
                    decoration: buildInputDecoration("Website", Icons.language),
                    validator: (value) => value == null || value.isEmpty ? "Enter website" : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _instagramController,
                    decoration: buildInputDecoration("Instagram", Icons.camera_alt),
                    validator: (value) => value == null || value.isEmpty ? "Enter Instagram" : null,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _linkedinController,
                    decoration: buildInputDecoration("LinkedIn", Icons.business),
                    validator: (value) => value == null || value.isEmpty ? "Enter LinkedIn" : null,
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    style: raisedButtonStyle,
                    onPressed: _saveProfile,
                    // onPressed: (){},
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
