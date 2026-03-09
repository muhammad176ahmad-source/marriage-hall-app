import 'package:flutter/material.dart';
import 'photographer_data.dart';
import 'photographer_detail_screen.dart';

class HirePhotographerScreen extends StatefulWidget {
  const HirePhotographerScreen({Key? key}) : super(key: key);

  @override
  State<HirePhotographerScreen> createState() => _HirePhotographerScreenState();
}

class _HirePhotographerScreenState extends State<HirePhotographerScreen> {

  String search = "";

  @override
  Widget build(BuildContext context) {

    final filtered = photographersList.where((p) =>
        p.name.toLowerCase().contains(search.toLowerCase()) ||
        p.city.toLowerCase().contains(search.toLowerCase()) ||
        p.category.toLowerCase().contains(search.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Hire Photographer (User)")),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search by name, city or category",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) => setState(() => search = val),
            ),
          ),

          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text("No Photographer Found"))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final p = filtered[index];

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(p.name),
                          subtitle: Text("${p.category} | ${p.city}\nStarting: ${p.price} PKR"),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PhotographerDetailScreen(photographer: p),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}