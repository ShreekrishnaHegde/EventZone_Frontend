import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  File? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: _selectedDate ?? DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select date and time")),
        );
        return;
      }

      // Combine date and time
      final DateTime eventDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      // Upload logic here...
      print("Event Name: ${_nameController.text}");
      print("Description: ${_descriptionController.text}");
      print("Location: ${_locationController.text}");
      print("DateTime: $eventDateTime");
      print("Image selected: ${_image != null}");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event submitted")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Event"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Event Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Event Name"),
                validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 12),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
                validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 12),

              // Location
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: "Location"),
                validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 12),

              // Date Picker
              Row(
                children: [
                  // Expanded(
                  //   child: Text(_selectedDate == null
                  //       ? "No date chosen"
                  //       : DateFormat('yyyy-MM-dd').format(_selectedDate!)),
                  // ),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text("Pick Date"),
                  ),
                ],
              ),

              // Time Picker
              Row(
                children: [
                  Expanded(
                    child: Text(_selectedTime == null
                        ? "No time chosen"
                        : _selectedTime!.format(context)),
                  ),
                  TextButton(
                    onPressed: _pickTime,
                    child: const Text("Pick Time"),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.grey.shade200,
                  ),
                  child: _image == null
                      ? const Center(child: Text("Tap to pick image"))
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 20),
              // Submit Button
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.send),
                label: const Text("Add"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
