import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../widgets/hall_card.dart';

class UserHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Available Halls")),
      body: StreamBuilder(
        stream: FirestoreService().getHalls(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];

              return HallCard(
                name: data['name'],
                imageUrl: data['imageUrl'],
                categories: data['categories'],
                dishes: data['dishes'],
                availability: data['availability'],
              );
            },
          );
        },
      ),
    );
  }
}
