import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui';

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

  bool notificationsEnabled = true;

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
      "availableDate": selectedDate?.toIso8601String(),
      "ownerPhone": _ownerPhoneController.text.trim(),
      "ownerWhatsapp": _ownerWhatsappController.text.trim(),
      "bookingTime": _bookingTimeController.text.trim(),
      "status": "Available", // new field for booking status
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Hall added successfully!")),
    );

    // Clear form
    _formKey.currentState!.reset();
    setState(() {
      imageFile = null;
      selectedDate = null;
      selectedCategory = "Wedding";
    });
  }

  // ===== Glass Style Button =====
  Widget _glassButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white30),
              boxShadow: [
                BoxShadow(
                  color: Colors.purpleAccent.withOpacity(0.2),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===== Hall Card =====
  Widget _hallCard(DocumentSnapshot hall) {
    final hallData = hall.data() as Map<String, dynamic>;
    final availableDateStr = hallData['availableDate'] ?? '';
    DateTime? hallDate;
    if (availableDateStr.isNotEmpty) hallDate = DateTime.tryParse(availableDateStr);

    bool isExpired = hallDate != null && hallDate.isBefore(DateTime.now());

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: hallData['image'] != ''
            ? Image.file(File(hallData['image']), width: 60, height: 60, fit: BoxFit.cover)
            : const Icon(Icons.photo, size: 60, color: Colors.grey),
        title: Text(
          hallData['name'] ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Status: ${isExpired ? 'Unavailable' : hallData['status']}\nAvailable Date: ${hallDate != null ? hallDate.toLocal().toString().split(' ')[0] : 'Not set'}\nTime: ${hallData['bookingTime'] ?? 'Not set'}",
        ),
        trailing: isExpired
            ? const Icon(Icons.block, color: Colors.red)
            : const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }

  // ===== Notification Toggle =====
  Widget _notificationToggle() {
    return SwitchListTile(
      title: const Text("Enable Booking Notifications"),
      value: notificationsEnabled,
      onChanged: (val) => setState(() => notificationsEnabled = val),
      secondary: const Icon(Icons.notifications),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add & Manage Halls"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add_business), label: "Add Hall"),
          BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: "Offers"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Owner"),
        ],
        onTap: (index) {
          // Placeholder for navigation logic
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: "Hall Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val == null || val.isEmpty ? "Enter hall name" : null,
                  ),
                  const SizedBox(height: 12),
                  // Location
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: "Location",
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val == null || val.isEmpty ? "Enter location" : null,
                  ),
                  const SizedBox(height: 12),
                  // Price
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Price (per day)",
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val == null || val.isEmpty ? "Enter price" : null,
                  ),
                  const SizedBox(height: 12),
                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Booking Time
                  TextFormField(
                    controller: _bookingTimeController,
                    decoration: const InputDecoration(
                      labelText: "Booking Time (e.g., 9AM-8PM)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Category
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
                  const SizedBox(height: 12),
                  // Date
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
                            ? "Available Date: ${selectedDate!.toLocal().toString().split(' ')[0]}"
                            : "Select Available Date",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Image Picker
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
                  const SizedBox(height: 20),
                  // Glass-style Add Hall Button
                  _glassButton("Add Hall", _saveHall),
                  const SizedBox(height: 20),
                  // Notification Toggle
                  _notificationToggle(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const Divider(thickness: 1.2),
            const SizedBox(height: 10),
            // ===== Real-time Halls List =====
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('halls').orderBy('availableDate', descending: false).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final halls = snapshot.data!.docs;
                if (halls.isEmpty) return const Text("No halls added yet.");
                return Column(
                  children: halls.map((hall) => _hallCard(hall)).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}