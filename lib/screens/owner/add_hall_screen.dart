import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // ✅ Add this line
import 'dart:ui';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Web ke liye
import 'dart:typed_data';
import 'dart:html' as html;


class AddHallScreen extends StatefulWidget {
  const AddHallScreen({super.key});

  @override
  State<AddHallScreen> createState() => _AddHallScreenState();
}

class _AddHallScreenState extends State<AddHallScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey _invoiceKey = GlobalKey();

  // Hall fields
  String name = '';
  String location = '';
  String description = '';
  String price = '';
  String image = 'assets/hall1.jpg'; // Placeholder
  DateTime? availableDate;
  TimeOfDay? bookingTime;

  // Owner fields
  String ownerPhone = '';
  String ownerWhatsapp = '';

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

  // Saved halls
  final List<Map<String, dynamic>> addedHalls = [];

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    for (var menu in menus.keys) {
      selectedDishes[menu] = List.filled(menus[menu]!.length, false);
    }
  }

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

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: availableDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (picked != null) setState(() => availableDate = picked);
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: bookingTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => bookingTime = picked);
  }

  void _saveHall() {
    if (!_formKey.currentState!.validate()) return;

    if (availableDate == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please select available date')));
      return;
    }
    if (bookingTime == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please select booking time')));
      return;
    }

    setState(() => isSaving = true);

    final hallData = {
      "name": name,
      "location": location,
      "description": description,
      "price": price,
      "image": image,
      "category": category,
      "availableDate": availableDate,
      "bookingTime": bookingTime,
    };

    setState(() {
      addedHalls.add(hallData);
      isSaving = false;
      name = '';
      location = '';
      description = '';
      price = '';
      ownerPhone = '';
      ownerWhatsapp = '';
      bookingTime = null;
      availableDate = null;
      selectedDishes.forEach((key, value) => value.fillRange(0, value.length, false));
    });
  }

  Color _statusColor(DateTime date, TimeOfDay time) {
    final now = DateTime.now();
    final hallDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return hallDateTime.isBefore(now) ? Colors.red : Colors.green;
  }

  String _statusText(DateTime date, TimeOfDay time) {
    final now = DateTime.now();
    final hallDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return hallDateTime.isBefore(now) ? "Expired" : "Booked";
  }

  // ===== Share or Download Invoice =====
  Future<void> _shareInvoice(GlobalKey key) async {
    try {
      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      if (kIsWeb) {
        // Web: Download
        final blob = html.Blob([pngBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..download = 'hall_invoice.png'
          ..style.display = 'none';
        html.document.body!.children.add(anchor);
        anchor.click();
        html.document.body!.children.remove(anchor);
        html.Url.revokeObjectUrl(url);
      } else {
        // Mobile: Share
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/hall_invoice.png').writeAsBytes(pngBytes);
        await Share.shareXFiles([XFile(file.path)], text: 'Check out this hall!');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error sharing invoice: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText =
        availableDate != null ? DateFormat('dd MMM yyyy').format(availableDate!) : 'Select Date';
    final timeText = bookingTime != null ? bookingTime!.format(context) : 'Select Time';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Add Wedding Hall'),
        backgroundColor: Colors.deepPurple.withOpacity(0.7),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SizedBox.expand(child: Image.asset('assets/hall_bg.jpg', fit: BoxFit.cover)),
          Container(color: Colors.black.withOpacity(0.3)),
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
                    child: ListView(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildTextField('Hall Name', name, (val) => name = val, TextInputType.text),
                              const SizedBox(height: 16),
                              _buildTextField('Location', location, (val) => location = val, TextInputType.text),
                              const SizedBox(height: 16),
                              _buildTextField('Description', description, (val) => description = val,
                                  TextInputType.text, maxLines: 3),
                              const SizedBox(height: 16),
                              _buildTextField('Price', price, (val) => price = val, TextInputType.number),
                              const SizedBox(height: 16),
                              _buildTextField('Owner Phone', ownerPhone, (val) => ownerPhone = val, TextInputType.phone),
                              const SizedBox(height: 16),
                              _buildTextField('Owner WhatsApp', ownerWhatsapp, (val) => ownerWhatsapp = val, TextInputType.phone),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: _pickDate,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Colors.grey.shade100.withOpacity(0.8),
                                          border: Border.all(color: Colors.grey.shade400),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.calendar_month, color: Colors.deepPurple),
                                            const SizedBox(width: 12),
                                            Text(dateText),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: _pickTime,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Colors.grey.shade100.withOpacity(0.8),
                                          border: Border.all(color: Colors.grey.shade400),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.access_time, color: Colors.deepPurple),
                                            const SizedBox(width: 12),
                                            Text(timeText),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
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
                            ],
                          ),
                        ),
                        Center(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.add_business, color: Colors.white),
                            label: const Text("Add Hall", style: TextStyle(fontSize: 18)),
                            onPressed: isSaving ? null : _saveHall,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              elevation: 12,
                              shadowColor: Colors.deepPurpleAccent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // ===== Display Added Halls =====
                        if (addedHalls.isNotEmpty)
                          RepaintBoundary(
                            key: _invoiceKey,
                            child: Column(
                              children: addedHalls.map((hall) {
                                final statusColor = _statusColor(hall['availableDate'], hall['bookingTime']);
                                final statusText = _statusText(hall['availableDate'], hall['bookingTime']);
                                return Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  elevation: 6,
                                  child: ListTile(
                                    leading: Image.asset(hall['image'], width: 60, fit: BoxFit.cover),
                                    title: Text(hall['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Text('${hall['location']} • ${hall['price']}'),
                                    trailing: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: statusColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(statusText,
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        if (addedHalls.isNotEmpty)
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () => _shareInvoice(_invoiceKey),
                              icon: const Icon(Icons.share, color: Colors.white),
                              label: const Text("Share/Download Invoice"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                elevation: 12,
                                shadowColor: Colors.deepPurpleAccent,
                              ),
                            ),
                          ),
                      ],
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
