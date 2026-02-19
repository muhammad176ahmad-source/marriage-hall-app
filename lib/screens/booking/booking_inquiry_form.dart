import 'package:flutter/material.dart';

class BookingInquiryForm extends StatelessWidget {
  final String hallName;
  final double hallPrice;
  final DateTime? hallDate;

  const BookingInquiryForm({
    super.key,
    required this.hallName,
    required this.hallPrice,
    this.hallDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Inquiry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Hall: $hallName'),
            Text('Price: $hallPrice'),
            Text('Date: ${hallDate != null ? hallDate!.toLocal().toIso8601String().split('T')[0] : 'Flexible'}'),
            // Add your form fields here
          ],
        ),
      ),
    );
  }
}
