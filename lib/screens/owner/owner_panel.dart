import 'package:flutter/material.dart';
import '../../data/app_data.dart';
import '../../models/item_model.dart';

class OwnerPanel extends StatelessWidget {
  const OwnerPanel({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Owner Panel"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {

          AppData.pendingHalls.add(
            ItemModel(
              name: "New Hall",
              location: "Lahore",
              fee: 50000,
              phone: "030000000",
              website: "",
              images: [],
            )
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Hall submitted for approval"))
          );

        },

        child: const Icon(Icons.add),
      ),

      body: ListView.builder(
        itemCount: AppData.ownerHalls.length,

        itemBuilder: (context,index){

          final hall = AppData.ownerHalls[index];

          return ListTile(
            title: Text(hall.name),
            subtitle: Text(hall.location),
          );

        },
      ),
    );
  }
}