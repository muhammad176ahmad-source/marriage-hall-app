// lib/screens/booking_confirmation_screen.dart
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final Map<String,dynamic> hall;
  final List<String> selectedDishes;

  const BookingConfirmationScreen({super.key, required this.hall, required this.selectedDishes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Booking Confirmed")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
            const SizedBox(height: 12),
            Text("Your booking at ${hall["name"]} is confirmed!", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text("Dishes Selected:", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: selectedDishes.map((d) => Chip(label: Text(d))).toList(),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                Share.share("I just booked ${hall["name"]} with dishes: ${selectedDishes.join(", ")}!");
              },
              icon: const Icon(Icons.share),
              label: const Text("Share Booking"),
            ),
          ],
        ),
      ),
    );
  }
}