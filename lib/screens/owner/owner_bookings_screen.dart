import 'package:flutter/material.dart';

class OwnerBookingsScreen extends StatelessWidget {
  const OwnerBookingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hall Bookings')),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.event),
            title: Text('Royal Marriage Hall'),
            subtitle: Text('Booked by Ali - 12 June 2026'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.event),
            title: Text('Diamond Banquet'),
            subtitle: Text('Booked by Ahmed - 20 June 2026'),
          ),
        ],
      ),
    );
  }
}
