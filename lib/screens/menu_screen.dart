import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  final Map<String, dynamic> hall;

  const MenuScreen({Key? key, required this.hall}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menu = hall['menu'] ?? {};
    final appetizers = List<String>.from(menu['appetizers'] ?? []);
    final mainCourse = List<String>.from(menu['mainCourse'] ?? []);
    final desserts = List<String>.from(menu['dessert'] ?? []);
    final options = Map<String, dynamic>.from(menu['options'] ?? {});

    return Scaffold(
      appBar: AppBar(
        title: Text('${hall['name']} Menu'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Appetizers', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            ...appetizers.map((a) => Text('• $a')),

            const SizedBox(height: 12),
            Text('Main Course', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            ...mainCourse.map((m) => Text('• $m')),

            const SizedBox(height: 12),
            Text('Dessert', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            ...desserts.map((d) => Text('• $d')),

            const SizedBox(height: 12),
            Text('Other Options', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            ...options.entries.map((e) => Text('${e.key}: ${e.value.join(', ')}')),
          ],
        ),
      ),
    );
  }
}
