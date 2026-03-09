import 'package:flutter/material.dart';
import '../services/booking_service.dart';

class BookingScreen extends StatefulWidget {

  final String hallName;

  const BookingScreen({super.key, required this.hallName});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final dateController = TextEditingController();

  final service = BookingService();

  void bookHall() async {

    await service.createBooking(

      name: nameController.text,
      phone: phoneController.text,
      hall: widget.hallName,
      date: dateController.text,

    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking Sent"))
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(title: Text(widget.hallName)),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Phone"),
            ),

            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: "Event Date"),
            ),

            const SizedBox(height:20),

            ElevatedButton(
              onPressed: bookHall,
              child: const Text("Book Hall"),
            )

          ],

        ),

      ),

    );

  }
}