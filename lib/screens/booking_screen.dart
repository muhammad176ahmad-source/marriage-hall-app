// lib/screens/booking_screen.dart
import 'package:flutter/material.dart';
import 'booking_confirmation_screen.dart';

class BookingScreen extends StatelessWidget {
  final Map<String,dynamic> hall;
  final List<String> selectedDishes;

  const BookingScreen({super.key, required this.hall, required this.selectedDishes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Booking Summary")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(hall["name"], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Image.asset(hall["image"], height: 180, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 12),
            Text("Selected Dishes:", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8,
              children: selectedDishes.map((d) => Chip(label: Text(d))).toList(),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingConfirmationScreen(
                        hall: hall,
                        selectedDishes: selectedDishes,
                      ),
                    ),
                  );
                },
                child: const Text("Confirm Booking"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}