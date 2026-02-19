import 'package:flutter/material.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Events")),
      body: const Center(
        child: Text(
          "Here are all your events!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
