// lib/screens/add_venue_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddVenueScreen extends StatefulWidget {
  const AddVenueScreen({super.key});

  @override
  State<AddVenueScreen> createState() => _AddVenueScreenState();
}

class _AddVenueScreenState extends State<AddVenueScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  void _submit() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final newBooking = {
        "name": _nameController.text,
        "date": DateFormat('dd MMMM yyyy').format(_selectedDate!),
        "status": "Pending", // default status
      };
      Navigator.pop(context, newBooking);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and select a date")),
      );
    }
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: DateTime(today.year + 5),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Venue"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Venue Name",
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? "Enter venue name" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _feeController,
                decoration: const InputDecoration(
                  labelText: "Fee (PKR)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.isEmpty ? "Enter fee" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description (Optional)",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Select Date"),
                subtitle: Text(
                  _selectedDate != null
                      ? DateFormat('dd MMMM yyyy').format(_selectedDate!)
                      : "No date selected",
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _pickDate,
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "Add Venue",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}