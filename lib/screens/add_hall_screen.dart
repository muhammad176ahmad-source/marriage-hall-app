// import 'package:flutter/material.dart';
// class AddHallScreen extends StatefulWidget {
//   const AddHallScreen({super.key});

//   @override
//   State<AddHallScreen> createState() => _AddHallScreenState();
// }

// class _AddHallScreenState extends State<AddHallScreen> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController locationController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add New Hall")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(controller: nameController, decoration: const InputDecoration(labelText: "Hall Name")),
//             TextField(controller: locationController, decoration: const InputDecoration(labelText: "Location")),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Hall data return to HomeScreen
//                 Navigator.pop(context, {
//                   "id": DateTime.now().millisecondsSinceEpoch,
//                   "name": nameController.text,
//                   "location": locationController.text,
//                   "description": "",
//                   "price": 0,
//                   "image": "assets/images/others.jpg",
//                   "category": "Others",
//                 });
//               },
//               child: const Text("Add Hall"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
