import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'dart:ui';

class AddHallScreen extends StatefulWidget {
  const AddHallScreen({super.key});

  @override
  State<AddHallScreen> createState() => _AddHallScreenState();
}

class _AddHallScreenState extends State<AddHallScreen> {
  final _formKey = GlobalKey<FormState>();

  // Hall fields
  String name = '';
  String location = '';
  String description = '';
  String price = '';
  String image = 'assets/hall1.jpg'; // Placeholder
  DateTime? availableDate;

  // Owner fields
  String ownerPhone = '';
  String ownerWhatsapp = '';
  String bookingTime = '';

  // Category
  String category = 'Mehndi';
  final List<String> categories = ['Mehndi', 'Barat', 'Walima', 'Mehfil', 'Others'];

  // Dishes & Menus
  final Map<String, List<String>> menus = {
    "Wedding Menu": ["Chicken Biryani", "Mutton Karahi", "Salad", "Dessert"],
    "Birthday Menu": ["Pizza", "Burger", "Cake", "Fries"],
    "Conference Menu": ["Sandwich", "Pasta", "Juice", "Coffee"],
  };
  final Map<String, List<bool>> selectedDishes = {};

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    for (var menu in menus.keys) {
      selectedDishes[menu] = List.filled(menus[menu]!.length, false);
    }
  }

  // TextField builder
  Widget _buildTextField(String label, String value, Function(String) onChanged, TextInputType type,
      {int maxLines = 1}) {
    return TextFormField(
      initialValue: value,
      maxLines: maxLines,
      keyboardType: type,
      onChanged: onChanged,
      validator: (val) => val!.isEmpty ? 'Please enter $label' : null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100.withOpacity(0.8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.deepPurple),
      ),
    );
  }

  // Date picker
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: availableDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.deepPurple),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) setState(() => availableDate = picked);
  }

  // Save hall (local)
  Future<void> _saveHall() async {
    if (!_formKey.currentState!.validate()) return;

    if (availableDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select available date')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      final hallData = {
        "name": name,
        "location": location,
        "description": description,
        "price": price,
        "image": image,
        "category": category,
        "availableDate": availableDate!.toIso8601String(),

        // Owner
        "ownerPhone": ownerPhone,
        "ownerWhatsapp": ownerWhatsapp,
        "bookingTime": bookingTime,

        // Dishes
        "menus": selectedDishes.map((menu, list) {
          final dishes = menus[menu]!;
          List<String> selected = [];
          for (int i = 0; i < list.length; i++) {
            if (list[i]) selected.add(dishes[i]);
          }
          return MapEntry(menu, selected);
        }),
      };

      // Local save / print
      print('Hall saved: $hallData');

      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hall added successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = availableDate != null
        ? DateFormat('dd MMM yyyy').format(availableDate!)
        : 'Select Available Date';

    return Scaffold(
      // Background glass effect
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Add Wedding Hall'),
        backgroundColor: Colors.deepPurple.withOpacity(0.7),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))),
      ),
      body: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset(
              'assets/hall_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.3),
          ),

          // Glass container
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    color: Colors.white.withOpacity(0.25),
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          _buildTextField('Hall Name', name, (val) => name = val, TextInputType.text),
                          const SizedBox(height: 16),
                          _buildTextField('Location', location, (val) => location = val, TextInputType.text),
                          const SizedBox(height: 16),
                          _buildTextField('Description', description, (val) => description = val, TextInputType.text,
                              maxLines: 3),
                          const SizedBox(height: 16),
                          _buildTextField('Price', price, (val) => price = val, TextInputType.number),
                          const SizedBox(height: 16),

                          // Owner fields
                          _buildTextField('Owner Phone', ownerPhone, (val) => ownerPhone = val, TextInputType.phone),
                          const SizedBox(height: 16),
                          _buildTextField('Owner WhatsApp', ownerWhatsapp, (val) => ownerWhatsapp = val, TextInputType.phone),
                          const SizedBox(height: 16),
                          _buildTextField('Booking Time', bookingTime, (val) => bookingTime = val, TextInputType.text),
                          const SizedBox(height: 16),

                          // Date picker
                          GestureDetector(
                            onTap: _pickDate,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.shade100.withOpacity(0.8),
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_month, color: Colors.deepPurple),
                                  const SizedBox(width: 12),
                                  Text(
                                    dateText,
                                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Category dropdown
                          DropdownButtonFormField<String>(
                            value: category,
                            items: categories
                                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => category = val);
                            },
                            decoration: InputDecoration(
                              labelText: 'Function Category',
                              filled: true,
                              fillColor: Colors.grey.shade100.withOpacity(0.8),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                              ),
                              labelStyle: const TextStyle(color: Colors.deepPurple),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // ===== MENUS WITH CHECKBOXES =====
                          ...menus.keys.map((menuName) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(menuName,
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                                const SizedBox(height: 8),
                                ...List.generate(menus[menuName]!.length, (i) {
                                  return CheckboxListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(menus[menuName]![i], style: const TextStyle(fontSize: 14)),
                                    value: selectedDishes[menuName]![i],
                                    onChanged: (val) {
                                      setState(() {
                                        selectedDishes[menuName]![i] = val ?? false;
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading,
                                  );
                                }),
                                const SizedBox(height: 16),
                              ],
                            );
                          }).toList(),

                          // Add Hall Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isSaving ? null : _saveHall,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: isSaving
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text('Add Hall', style: TextStyle(fontSize: 18)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
