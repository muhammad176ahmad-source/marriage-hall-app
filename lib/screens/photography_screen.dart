import 'package:flutter/material.dart';
import 'add_photographer_screen.dart';
import 'hire_photographer_screen.dart';

class PhotographyScreen extends StatelessWidget {
  const PhotographyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Photography")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddPhotographerScreen()),
                );
              },
              child: const Text("Add Photographer"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HirePhotographerScreen()),
                );
              },
              child: const Text("Hire Photographer"),
            ),
          ],
        ),
      ),
    );
  }
}