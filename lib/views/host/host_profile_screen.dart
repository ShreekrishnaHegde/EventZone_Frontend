import 'dart:io';
import 'dart:ui';

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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();

  File? _logoImage;

  @override
  void initState() {
    super.initState();
    _profileFuture = _hostProfileService.fetchProfile();

  }

  void _showImageOptions(String? currentImageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Stack(
          children: [
            // Blurred background
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),

            // Main Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Circular profile image
                Center(
                  child: CircleAvatar(
                    radius: 90,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: currentImageUrl != null && currentImageUrl.isNotEmpty
                        ? NetworkImage(currentImageUrl)
                        : null,
                    child: currentImageUrl == null || currentImageUrl.isEmpty
                        ? const Icon(Icons.account_circle, size: 80, color: Colors.grey)
                        : null,
                  ),
                ),

                const SizedBox(height: 40),

                // Action buttons at the bottom
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Delete Icon
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.black.withOpacity(0.6),
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent, size: 26),
                          onPressed: () async {
                            Navigator.pop(context);
                            await _deleteProfileImage();
                          },
                        ),
                      ),

                      // Edit Icon
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.black.withOpacity(0.6),
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white, size: 26),
                          onPressed: () async {
                            Navigator.pop(context);
                            await _pickNewImage();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }


  Future<void> _pickNewImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null && mounted) {
      setState(() {
        _logoImage = File(picked.path);
      });

      try {
        final success = await _hostProfileService.updateProfile(
          clubName: _nameController.text,
          description: _descriptionController.text,
          phoneNumber: _phoneController.text,
          website: _websiteController.text,
          instagram: _instagramController.text,
          linkedin: _linkedinController.text,
          logoImage: _logoImage,
        );

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile picture updated")),
          );
          setState(() {
            _profileFuture = _hostProfileService.fetchProfile(); // Refresh
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to upload image: $e")),
        );
      }
    }
  }

  Future<void> _deleteProfileImage() async {
    try {
      final success = await _hostProfileService.updateProfile(
        clubName: _nameController.text,
        description: _descriptionController.text,
        phoneNumber: _phoneController.text,
        website: _websiteController.text,
        instagram: _instagramController.text,
        linkedin: _linkedinController.text,
        logoImage: null, // triggers Cloudinary deletion
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile picture removed")),
        );
        setState(() {
          _logoImage = null;
          _profileFuture = _hostProfileService.fetchProfile(); // Refresh
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete image: $e")),
      );
    }
  }


  void _saveProfile() async {
    // if (_formKey.currentState!.validate()) {
      try {
        final success = await _hostProfileService.updateProfile(
          clubName: _nameController.text,
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
          _nameController.text = profile.name;
          _descriptionController.text = profile.description;
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
                    onTap: () => _showImageOptions(profile.logoUrl),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _logoImage != null
                          ? FileImage(_logoImage!) as ImageProvider
                          : (profile.logoUrl != null && profile.logoUrl!.isNotEmpty
                          ? NetworkImage(profile.logoUrl)
                          : null),
                      child: _logoImage == null && (profile.logoUrl.isEmpty)
                          ? const Icon(Icons.add_a_photo, size: 30, color: Colors.grey)
                          : null,
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
                    initialValue: "HOST",
                    decoration: buildInputDecoration("Role", Icons.person),
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _nameController,
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
