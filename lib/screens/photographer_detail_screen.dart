import 'package:flutter/material.dart';
import 'photographer_model.dart';

class PhotographerDetailScreen extends StatefulWidget {
  final Photographer photographer;

  const PhotographerDetailScreen({Key? key, required this.photographer}) : super(key: key);

  @override
  State<PhotographerDetailScreen> createState() => _PhotographerDetailScreenState();
}

class _PhotographerDetailScreenState extends State<PhotographerDetailScreen> {

  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {

    final p = widget.photographer;

    return Scaffold(
      appBar: AppBar(title: Text(p.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(p.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),

            Text("Category: ${p.category}"),
            Text("City: ${p.city}"),
            Text("Experience: ${p.experience} Years"),
            Text("Starting Price: ${p.price} PKR"),

            const SizedBox(height: 15),
            const Text("Services Included:", style: TextStyle(fontWeight: FontWeight.bold)),

            ...p.services.map((s) => Text("• $s")),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );

                if (selectedDate != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Booked on ${selectedDate.toString().split(' ')[0]}")),
                  );
                }
              },
              child: const Text("Book Photographer"),
            ),
          ],
        ),
      ),
    );
  }
}import 'package:flutter/material.dart';
import 'photographer_model.dart';

class PhotographerDetailScreen extends StatefulWidget {
  final Photographer photographer;

  const PhotographerDetailScreen({Key? key, required this.photographer}) : super(key: key);

  @override
  State<PhotographerDetailScreen> createState() => _PhotographerDetailScreenState();
}

class _PhotographerDetailScreenState extends State<PhotographerDetailScreen> {

  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {

    final p = widget.photographer;

    return Scaffold(
      appBar: AppBar(title: Text(p.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(p.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),

            Text("Category: ${p.category}"),
            Text("City: ${p.city}"),
            Text("Experience: ${p.experience} Years"),
            Text("Starting Price: ${p.price} PKR"),

            const SizedBox(height: 15),
            const Text("Services Included:", style: TextStyle(fontWeight: FontWeight.bold)),

            ...p.services.map((s) => Text("• $s")),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );

                if (selectedDate != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Booked on ${selectedDate.toString().split(' ')[0]}")),
                  );
                }
              },
              child: const Text("Book Photographer"),
            ),
          ],
        ),
      ),
    );
  }
}import 'package:flutter/material.dart';
import 'photographer_model.dart';

class PhotographerDetailScreen extends StatefulWidget {
  final Photographer photographer;

  const PhotographerDetailScreen({Key? key, required this.photographer}) : super(key: key);

  @override
  State<PhotographerDetailScreen> createState() => _PhotographerDetailScreenState();
}

class _PhotographerDetailScreenState extends State<PhotographerDetailScreen> {

  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {

    final p = widget.photographer;

    return Scaffold(
      appBar: AppBar(title: Text(p.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(p.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),

            Text("Category: ${p.category}"),
            Text("City: ${p.city}"),
            Text("Experience: ${p.experience} Years"),
            Text("Starting Price: ${p.price} PKR"),

            const SizedBox(height: 15),
            const Text("Services Included:", style: TextStyle(fontWeight: FontWeight.bold)),

            ...p.services.map((s) => Text("• $s")),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );

                if (selectedDate != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Booked on ${selectedDate.toString().split(' ')[0]}")),
                  );
                }
              },
              child: const Text("Book Photographer"),
            ),
          ],
        ),
      ),
    );
  }
}