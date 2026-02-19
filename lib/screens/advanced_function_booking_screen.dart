import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvancedFunctionBookingScreen extends StatefulWidget {
  final Map<String, dynamic> hall;

  const AdvancedFunctionBookingScreen({Key? key, required this.hall}) : super(key: key);

  @override
  State<AdvancedFunctionBookingScreen> createState() => _AdvancedFunctionBookingScreenState();
}

class _AdvancedFunctionBookingScreenState extends State<AdvancedFunctionBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _guestsController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // ================== Launch Phone ==================
  void _callHall(String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint('Could not launch $phone');
    }
  }

  // ================== Launch Email ==================
  void _emailHall(String email) async {
    final Uri url = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint('Could not email $email');
    }
  }

  // ================== Pick Date ==================
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // ================== Pick Time ==================
  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // ================== Confirm Booking ==================
  void _confirmBooking() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    final bookingSummary = '''
Hall: ${widget.hall['name']}
Location: ${widget.hall['location']}
Date: ${DateFormat('dd MMM yyyy').format(_selectedDate!)}
Time: ${_selectedTime!.format(context)}
Guests: ${_guestsController.text}
Name: ${_nameController.text}
Email: ${_emailController.text}
Phone: ${_phoneController.text}
''';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Booking'),
        content: Text(bookingSummary),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking Confirmed!')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hall = widget.hall;
    final List<String> images = List<String>.from(hall['images'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Text(hall['name']),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====== Hall Images Carousel ======
            SizedBox(
              height: 220,
              child: PageView.builder(
                itemCount: images.length,
                itemBuilder: (context, index) => Image.network(
                  images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ====== Hall Details ======
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hall['name'],
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hall['location'],
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      Chip(
                        label: Text('Rs ${hall['price']}'),
                        backgroundColor: Colors.deepPurple.shade100,
                      ),
                      Chip(
                        label: Text('Capacity: ${hall['capacity']}'),
                        backgroundColor: Colors.orange.shade100,
                      ),
                      Chip(
                        label: Text('Per Head: Rs ${hall['perHeadRate']}'),
                        backgroundColor: Colors.green.shade100,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ====== Facilities ======
                  const Text(
                    'Facilities',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: List<Widget>.from(
                      (hall['facilities'] ?? []).map((f) => Chip(label: Text(f))),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ====== Contact Buttons ======
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _callHall('403-390-3000'),
                        icon: const Icon(Icons.phone),
                        label: const Text('Call Hall'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _emailHall('info@empirebanquet.ca'),
                        icon: const Icon(Icons.email),
                        label: const Text('Email Hall'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ====== Booking Form ======
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Booking Form',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Your Name', border: OutlineInputBorder()),
                          validator: (v) => v!.isEmpty ? 'Enter your name' : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                          validator: (v) => v!.isEmpty ? 'Enter email' : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder()),
                          keyboardType: TextInputType.phone,
                          validator: (v) => v!.isEmpty ? 'Enter phone number' : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _guestsController,
                          decoration: const InputDecoration(labelText: 'Number of Guests', border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.isEmpty ? 'Enter number of guests' : null,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _pickDate,
                                child: Text(_selectedDate == null
                                    ? 'Select Date'
                                    : 'Date: ${DateFormat('dd MMM yyyy').format(_selectedDate!)}'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _pickTime,
                                child: Text(_selectedTime == null
                                    ? 'Select Time'
                                    : 'Time: ${_selectedTime!.format(context)}'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: _confirmBooking,
                            icon: const Icon(Icons.book_online),
                            label: const Text('Confirm Booking'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
