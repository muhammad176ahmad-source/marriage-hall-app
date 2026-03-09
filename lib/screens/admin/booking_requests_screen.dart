import 'package:flutter/material.dart';
import '../../data/app_data.dart';
import '../../models/item_model.dart';

class BookingRequestsScreen extends StatelessWidget {
  const BookingRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Requests"),
      ),

      body: ListView.builder(
        itemCount: AppData.bookingRequests.length,
        itemBuilder: (context, index) {

          final request = AppData.bookingRequests[index];
          final ItemModel item = request["item"];

          return Card(
            margin: const EdgeInsets.all(10),

            child: ListTile(
              title: Text(item.name),

              subtitle: Text(
                "Location: ${item.location}"
              ),

              trailing: Text(
                request["timestamp"].toString()
              ),
            ),
          );

        },
      ),
    );
  }
}