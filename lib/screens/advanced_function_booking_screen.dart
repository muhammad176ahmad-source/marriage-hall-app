import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvancedFunctionBookingScreen extends StatefulWidget {
  final Map<String, dynamic> hall;
  final List<String> selectedDishes;

  const AdvancedFunctionBookingScreen({
    Key? key,
    required this.hall,
    required this.selectedDishes,
  }) : super(key: key);

  @override
  State<AdvancedFunctionBookingScreen> createState() =>
      _AdvancedFunctionBookingScreenState();
}

class _AdvancedFunctionBookingScreenState
    extends State<AdvancedFunctionBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _guestsController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Local copy of selected dishes for dynamic receipt
  late List<String> receiptDishes;

  @override
  void initState() {
    super.initState();
    receiptDishes = List.from(widget.selectedDishes);
  }

  void addDish(String dish) {
    setState(() {
      receiptDishes.add(dish);
    });
  }

  void removeDish(String dish) {
    setState(() {
      receiptDishes.remove(dish);
    });
  }

  double calculateTotal() {
    double perDishRate = 500; // Example per dish rate
    return receiptDishes.length * perDishRate;
  }

  void _callHall(String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint('Could not launch $phone');
    }
  }

  void _emailHall(String email) async {
    final Uri url = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint('Could not email $email');
    }
  }

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

Selected Dishes:
${receiptDishes.isEmpty ? "No dishes selected" : receiptDishes.join(", ")}

Name: ${_nameController.text}
Email: ${_emailController.text}
Phone: ${_phoneController.text}
Total: Rs ${calculateTotal()}
''';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Booking'),
        content: SingleChildScrollView(child: Text(bookingSummary)),
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
    final List<String> images =
        hall['images'] != null ? List<String>.from(hall['images']) : [];

    return Scaffold(
      appBar: AppBar(
        title: Text(hall['name'] ?? "Hall Details"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hall Images Carousel
            if (images.isNotEmpty)
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

            // Hall Info & Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hall['name'] ?? "",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hall['location'] ?? "",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      Chip(
                        label: Text('Rs ${hall['price'] ?? 0}'),
                        backgroundColor: Colors.deepPurple.shade100,
                      ),
                      Chip(
                        label: Text('Capacity: ${hall['capacity'] ?? 0}'),
                        backgroundColor: Colors.orange.shade100,
                      ),
                      Chip(
                        label:
                            Text('Per Head: Rs ${hall['perHeadRate'] ?? 0}'),
                        backgroundColor: Colors.green.shade100,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'Facilities',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: List<Widget>.from(
                      (hall['facilities'] ?? [])
                          .map((f) => Chip(label: Text(f.toString()))),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ===== Booking Form =====
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Booking Form',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                              labelText: 'Your Name',
                              border: OutlineInputBorder()),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Enter your name' : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder()),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Enter email' : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                              labelText: 'Phone',
                              border: OutlineInputBorder()),
                          keyboardType: TextInputType.phone,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Enter phone number' : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _guestsController,
                          decoration: const InputDecoration(
                              labelText: 'Number of Guests',
                              border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Enter number of guests' : null,
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

                        // ====== Receipt ======
                        const Text(
                          'Selected Dishes Receipt',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8)),
                          height: 150,
                          child: ListView.builder(
                            itemCount: receiptDishes.length,
                            itemBuilder: (context, index) {
                              final dish = receiptDishes[index];
                              return ListTile(
                                title: Text(dish),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => removeDish(dish),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Total: Rs ${calculateTotal()}',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                        const SizedBox(height: 20),

                        Center(
                          child: ElevatedButton.icon(
                            onPressed: _confirmBooking,
                            icon: const Icon(Icons.book_online),
                            label: const Text('Confirm Booking'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
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