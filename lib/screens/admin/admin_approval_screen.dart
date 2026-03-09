import 'package:flutter/material.dart';
import '../../data/app_data.dart';
import '../../models/item_model.dart';

class AdminApprovalScreen extends StatelessWidget {
  const AdminApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Hall Approvals"),
      ),

      body: ListView.builder(

        itemCount: AppData.pendingHalls.length,

        itemBuilder: (context,index){

          final ItemModel hall = AppData.pendingHalls[index];

          return Card(
            child: ListTile(

              title: Text(hall.name),
              subtitle: Text(hall.location),

              trailing: ElevatedButton(

                onPressed: () {

                  AppData.ownerHalls.add(hall);
                  AppData.pendingHalls.removeAt(index);

                },

                child: const Text("Approve"),

              ),

            ),
          );

        },
      ),
    );
  }
}