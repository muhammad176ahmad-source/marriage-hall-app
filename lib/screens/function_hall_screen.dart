import 'package:flutter/material.dart';
import 'hall_detail_screen.dart';

class FunctionHallScreen extends StatelessWidget {
  final String category;
  final List<Map<String, dynamic>> halls;

  const FunctionHallScreen({
    required this.category,
    required this.halls,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category Halls'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: halls.length,
        itemBuilder: (context, index) {
          final hall = halls[index];

          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 6,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  hall['image'],
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                hall['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${hall['location']} | \$${hall['price']}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HallDetailScreen(hall: hall),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
