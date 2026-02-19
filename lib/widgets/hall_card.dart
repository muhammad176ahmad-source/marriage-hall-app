import 'package:flutter/material.dart';

class HallCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final List categories;
  final List dishes;
  final List availability;

  const HallCard({
    required this.name,
    required this.imageUrl,
    required this.categories,
    required this.dishes,
    required this.availability,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(imageUrl, height: 150, fit: BoxFit.cover),
          Text(name, style: TextStyle(fontSize: 18)),
          Text("Categories: ${categories.join(", ")}"),
          Text("Dishes: ${dishes.join(", ")}"),
          Text("Time: ${availability.join(", ")}"),
        ],
      ),
    );
  }
}
