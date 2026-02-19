import 'package:flutter/material.dart';

class GuestScreen extends StatelessWidget {
  const GuestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Guests")),
      body: const Center(
        child: Text(
          "Manage your guests here!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
