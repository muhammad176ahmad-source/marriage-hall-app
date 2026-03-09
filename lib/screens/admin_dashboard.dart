import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {

  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),

      body: ListView(

        children: [

          ListTile(

            leading: const Icon(Icons.people),

            title: const Text("Manage Agents"),

            onTap: (){
              Navigator.pushNamed(context, '/agents');
            },

          ),

          ListTile(

            leading: const Icon(Icons.home),

            title: const Text("Manage Halls"),

          ),

          ListTile(

            leading: const Icon(Icons.restaurant),

            title: const Text("Manage Restaurants"),

          ),

          ListTile(

            leading: const Icon(Icons.hotel),

            title: const Text("Manage Hotels"),

          ),

          ListTile(

            leading: const Icon(Icons.food_bank),

            title: const Text("Manage Catering"),

          ),

        ],

      ),

    );

  }

}