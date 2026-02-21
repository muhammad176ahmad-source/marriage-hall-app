import 'package:flutter/material.dart';
import 'booking_confirmation_screen.dart';

class BookingScreen extends StatefulWidget {
  final String hallName;
  final String functionType;

  const BookingScreen({super.key, required this.hallName, required this.functionType});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String userName = '';
  String guestCount = '0';
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booking - ${widget.hallName}"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Your Name"),
              onChanged: (val) => userName = val,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Number of Guests"),
              keyboardType: TextInputType.number,
              onChanged: (val) => guestCount = val,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text("Select Date: "),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => selectedDate = picked);
                  },
                  child: Text("${selectedDate.day}-${selectedDate.month}-${selectedDate.year}"),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              ),
              onPressed: () {
                // ✅ Navigate to Booking Confirmation Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingConfirmationScreen(
                      hallName: widget.hallName,
                      userName: userName.isEmpty ? "Guest" : userName,
                      date: "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
                      functionType: widget.functionType,
                      guests: guestCount.isEmpty ? '0' : guestCount,
                    ),
                  ),
                );
              },
              child: const Text("Confirm Booking", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
