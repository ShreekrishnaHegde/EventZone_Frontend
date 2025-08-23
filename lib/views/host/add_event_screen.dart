import 'dart:io';
import 'package:eventzone_frontend/service/host_service/host_event_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../models/event_model.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _capacityController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  File? _poster;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: _selectedDate ?? DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _pickPoster() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) setState(() => _poster = File(pickedFile.path));
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select date and time")),
      );
      return;
    }
    final newEvent = Event(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      date: _selectedDate!, // keep date separate
      location: _locationController.text.trim(),
      time:
      "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}", // keep time separate
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    bool success = false;

    try {
      success = await HostEventService().createEvent(eventData: newEvent,imageFile: _poster);
    } finally {
      Navigator.pop(context); // remove loading indicator
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Event created successfully")),
      );
      Navigator.pop(context, true); // return true to refresh previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong. Please try again.")),
      );
    }
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  InputDecoration buildInputDecoration(String labelText,) {
    return InputDecoration(
      border: UnderlineInputBorder(),
      labelText: labelText,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(16.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF140447), width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.5),
        borderRadius: BorderRadius.circular(16.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0),
        borderRadius: BorderRadius.circular(16.0),
      ),
      // prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: Colors.grey.shade100,
    );
  }
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Color(0xFF140447),
    minimumSize: Size(double.infinity,50),
    // padding: EdgeInsets.symmetric(horizontal: 100),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  );
  Widget buildTextField({
    required String label,
    TextEditingController? controller,
    bool obscure=false,
    IconData? icon,
    int maxLines=1,
    TextInputType? keyboardType,
    String? Function(String?)? validator
  }){
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: buildInputDecoration(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Event"),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField(
                label: "Event Title",
                controller: _titleController,
                icon: Icons.title,
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              buildTextField(
                label: "Description",
                controller: _descriptionController,
                maxLines: 3,
                icon: Icons.description,
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              buildTextField(
                label: "Location",
                controller: _locationController,
                icon: Icons.location_on,
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),
              buildTextField(
                label: "Capacity",
                controller: _capacityController,
                icon:Icons.people,
                validator: (v) {
                  if (v != null && v.isNotEmpty) {
                    if (int.tryParse(v) == null) {
                      return "Enter a valid number";
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _sectionTitle("Event Date"),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? "No date selected"
                          : DateFormat('yMMMd').format(_selectedDate!),
                      style: TextStyle(
                          fontSize: 15,
                          color: _selectedDate == null
                              ? Colors.grey
                              : theme.colorScheme.onSurface),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today_outlined, size: 18),
                    label: const Text("Pick"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _sectionTitle("Event Time"),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedTime == null
                          ? "No time selected"
                          : _selectedTime!.format(context),
                      style: TextStyle(
                          fontSize: 15,
                          color: _selectedTime == null
                              ? Colors.grey
                              : theme.colorScheme.onSurface),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _pickTime,
                    icon: const Icon(Icons.access_time, size: 18),
                    label: const Text("Pick"),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Poster Upload
              _sectionTitle("Event Poster"),
              GestureDetector(
                onTap: _pickPoster,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _poster == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add_a_photo,
                          size: 40, color: Colors.grey),
                      SizedBox(height: 8),
                      Text("Tap to upload poster"),
                    ],
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(_poster!, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: const Icon(Icons.send),
                label: const Text("Create Event"),
                style: raisedButtonStyle,
              )
            ],
          ),
        ),
      ),
    );
  }
}
