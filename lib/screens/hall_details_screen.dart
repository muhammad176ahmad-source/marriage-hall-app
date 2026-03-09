import 'package:flutter/material.dart';
import '../models/hall_model.dart';

class HallDetailsScreen extends StatelessWidget {

  final HallModel hall;

  const HallDetailsScreen({super.key, required this.hall});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(hall.name),
        backgroundColor: Colors.deepPurpleAccent,
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextFormField(
              initialValue: hall.city,
              decoration: const InputDecoration(
                labelText: "City",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextFormField(
              initialValue: hall.phone,
              decoration: const InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextFormField(
              initialValue: hall.email,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextFormField(
              initialValue: hall.address,
              decoration: const InputDecoration(
                labelText: "Address",
                border: OutlineInputBorder(),
              ),
            ),

          ],
        ),
      ),
    );
  }
}