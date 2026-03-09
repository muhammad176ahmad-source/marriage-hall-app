import 'package:flutter/material.dart';

class AgentListScreen extends StatelessWidget {
  const AgentListScreen({super.key}); // ✅ const constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agents List"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.person, size: 80, color: Colors.deepPurpleAccent),
            SizedBox(height: 20),
            Text(
              "List of Agents will appear here",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}