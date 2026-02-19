import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddHallScreen extends StatefulWidget {
  const AddHallScreen({Key? key}) : super(key: key);

  @override
  State<AddHallScreen> createState() => _AddHallScreenState();
}

class _AddHallScreenState extends State<AddHallScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _ownerPhoneController = TextEditingController();
  final TextEditingController _ownerWhatsappController = TextEditingController();
  final TextEditingController _bookingTimeController = TextEditingController();

  String selectedCategory = "Wedding";
  DateTime? selectedDate;
  File? imageFile;

  // ===== Pick Image =====
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  // ===== Pick Date =====
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // ===== Save Hall to Firestore =====
  Future<void> _saveHall() async {
    if (!_formKey.currentState!.validate()) return;

    String imageUrl = imageFile != null ? imageFile!.path : '';

    await FirebaseFirestore.instance.collection('halls').add({
      "name": _nameController.text.trim(),
      "location": _locationController.text.trim(),
      "description": _descriptionController.text.trim(),
      "price": _priceController.text.trim(),
      "image": imageUrl,
      "category": selectedCategory,
      "availableDate": selectedDate?.toString(),

      // ===== OWNER FIELDS =====
      "ownerPhone": _ownerPhoneController.text.trim(),
      "ownerWhatsapp": _ownerWhatsappController.text.trim(),
      "bookingTime": _bookingTimeController.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Hall added successfully!")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Hall"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ===== Hall Name =====
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Hall Name",
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? "Enter hall name" : null,
              ),

              const SizedBox(height: 15),

              // ===== Location =====
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: "Location",
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? "Enter location" : null,
              ),

              const SizedBox(height: 15),

              // ===== Price =====
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Price (per day)",
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? "Enter price" : null,
              ),

              const SizedBox(height: 15),

              // ===== Description =====
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? "Enter description" : null,
              ),

              const SizedBox(height: 15),

              // ===== Owner Phone =====
              TextFormField(
                controller: _ownerPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Owner Phone Number",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // ===== Owner WhatsApp =====
              TextFormField(
                controller: _ownerWhatsappController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Owner WhatsApp Number (with country code)",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // ===== Booking Time =====
              TextFormField(
                controller: _bookingTimeController,
                decoration: const InputDecoration(
                  labelText: "Booking Time (e.g. 9:00 AM - 8:00 PM)",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // ===== Category Dropdown =====
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: ["Wedding", "Conference", "Birthday", "Others"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => selectedCategory = val);
                },
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              // ===== Available Date =====
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    selectedDate != null
                        ? "Available Date: ${selectedDate!.toString().split(' ')[0]}"
                        : "Select Available Date",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // ===== Pick Image =====
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: imageFile != null
                      ? Image.file(imageFile!, fit: BoxFit.cover)
                      : const Center(child: Text("Tap to select image")),
                ),
              ),

              const SizedBox(height: 25),

              // ===== Save Button =====
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveHall,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Add Hall",
                    style: TextStyle(fontSize: 18),
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
