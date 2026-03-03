import 'package:flutter/material.dart';

class BookingOptionsScreen extends StatelessWidget {
  final String title;
  final Map<String, List<String>> groupedItems;
  final List<String>? items;

  const BookingOptionsScreen({
    super.key,
    required this.title,
    required this.groupedItems,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.deepPurple, // App bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: groupedItems.keys.map((group) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ExpansionTile(
                tilePadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                title: Text(
                  group,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                children: groupedItems[group]!.map((item) {
                  return ListTile(
                    leading: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    title: Text(
                      item,
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Add your booking logic here
                        print('$item tapped for booking');
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}