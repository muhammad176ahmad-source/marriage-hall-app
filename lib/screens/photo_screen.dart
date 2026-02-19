import 'package:flutter/material.dart';

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Photos")),
      body: const Center(
        child: Text(
          "View and manage photos!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
