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
      final ImagePicker picker = ImagePicker();
      final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null && mounted) {
        setState(() {
          _logoImage = File(picked.path);
        });
      }
    } else {
      // Optional: ask before removing
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

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // You would call _hostProfileService.updateProfile(...) here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile saved successfully!")),
      );
    }
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

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter $label";
          }
          return null;
        },
      ),
    );
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
                  // Logo Avatar Section with Tap-to-Add/Delete
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
                  _buildReadOnlyField("Email", profile.email),
                  _buildReadOnlyField("Role", profile.role),
                  _buildTextField("Club Name", _clubNameController),
                  _buildTextField("Description", _descriptionController, maxLines: 3),
                  _buildTextField("Phone", _phoneController),
                  _buildTextField("Website", _websiteController),
                  _buildTextField("Instagram", _instagramController),
                  _buildTextField("LinkedIn", _linkedinController),

                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: _saveProfile,
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
