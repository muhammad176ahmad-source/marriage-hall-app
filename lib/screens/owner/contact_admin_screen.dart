import 'package:flutter/material.dart';

class ContactAdminScreen extends StatelessWidget {
  const ContactAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contact Admin")),
      body: const Center(child: Text("Contact Admin Screen")),
    );
  }
}