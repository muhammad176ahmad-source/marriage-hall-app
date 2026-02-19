// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../services/firestore_service.dart';
// import '../services/storage_service.dart';
// import '../services/auth_service.dart';
// import 'booking_screen.dart';
// import 'package:marriage_haal/screens/advanced_function_booking_screen.dart' as adv_booking;

// class HallDetailScreen extends StatefulWidget {
//   final Map<String, dynamic> hall;
//   final String? hallUid;

//   const HallDetailScreen({required this.hall, this.hallUid, super.key});

//   @override
//   State<HallDetailScreen> createState() => _HallDetailScreenState();
// }

// class _HallDetailScreenState extends State<HallDetailScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String? selectedFunction;

//   final TextEditingController _hallNameController = TextEditingController();
//   List<String> categoryOptions = ["Mehndi", "Walima", "Baraat", "Mehfil", "Other"];
//   List<String> dishOptions = ["Biryani", "Korma", "BBQ", "Pulao", "Karahi"];
//   List<String> selectedCategories = [];
//   List<String> selectedDishes = [];
//   List<String> selectedAvailability = [];
//   File? _image;
//   final ImagePicker _picker = ImagePicker();
//   final List<String> functions = ["Mehndi", "Walima", "Baraat", "Mehfil", "Other"];

//   // ================= NEW: Firestore Instance =================
//   final FirestoreService firestore = FirestoreService();

//   @override
//   void initState() {
//     super.initState();
//     _hallNameController.text = widget.hall['name'] ?? '';
//     if (widget.hall.containsKey('categories')) {
//       selectedCategories = List<String>.from(widget.hall['categories']);
//     }
//     if (widget.hall.containsKey('dishes')) {
//       selectedDishes = List<String>.from(widget.hall['dishes']);
//     }
//     if (widget.hall.containsKey('availability')) {
//       selectedAvailability = List<String>.from(widget.hall['availability']);
//     }
//   }

//   Future<void> pickImage() async {
//     final picked = await _picker.pickImage(source: ImageSource.camera);
//     if (picked != null) {
//       setState(() {
//         _image = File(picked.path);
//       });
//     }
//   }

//   void toggleSelection(String value, List<String> list) {
//     setState(() {
//       if (list.contains(value)) {
//         list.remove(value);
//       } else {
//         list.add(value);
//       }
//     });
//   }

//   Future<void> saveHallDetails() async {
//     try {
//       final uid = AuthService().currentUser!.uid;
//       String imageUrl = widget.hall['imageUrl'] ?? '';

//       if (_image != null) {
//         imageUrl = await StorageService().uploadImage(_image!, uid);
//       }

//       final hallDocUid = widget.hallUid ?? uid;

//       await firestore.saveOwnerData(
//         uid: hallDocUid,
//         name: _hallNameController.text,
//         categories: selectedCategories,
//         dishes: selectedDishes,
//         availability: selectedAvailability,
//         imageUrl: imageUrl,
//       );

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Hall Saved Successfully")),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error saving hall: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hall = widget.hall;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(hall['name'] ?? 'Hall Details'),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: Stack(
//         children: [
//           SizedBox.expand(
//             child: Image.asset(
//               'assets/images/hall_bg.jpg',
//               fit: BoxFit.cover,
//             ),
//           ),
//           Container(color: Colors.black.withOpacity(0.3)),
//           ListView(
//             children: [
//               Image.asset(
//                 hall['image'] ?? 'assets/images/hall_bg.jpg',
//                 fit: BoxFit.cover,
//                 height: 250,
//                 width: double.infinity,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     Text(
//                       hall['name'] ?? '',
//                       style: const TextStyle(
//                         fontSize: 26,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       '${hall['location'] ?? ''} | \$${hall['price'] ?? ''}',
//                       style: const TextStyle(
//                         fontSize: 18,
//                         color: Colors.white70,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'Beautiful wedding hall with all modern facilities. Suitable for weddings, parties, and events.',
//                       style: TextStyle(fontSize: 16, color: Colors.white),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 24),

//                     Form(
//                       key: _formKey,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             "Select Function Type",
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.amber,
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           DropdownButtonFormField<String>(
//                             decoration: InputDecoration(
//                               filled: true,
//                               fillColor: Colors.white.withOpacity(0.9),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             hint: const Text("Choose Function"),
//                             value: selectedFunction,
//                             items: functions
//                                 .map((func) => DropdownMenuItem(
//                                       value: func,
//                                       child: Text(func),
//                                     ))
//                                 .toList(),
//                             validator: (val) =>
//                                 val == null ? "Please select a function" : null,
//                             onChanged: (val) {
//                               setState(() {
//                                 selectedFunction = val;
//                               });
//                             },
//                           ),
//                           const SizedBox(height: 24),

//                           // ---------------- Simple Booking ----------------
//                           SizedBox(
//                             width: double.infinity,
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.amber[700],
//                                 padding: const EdgeInsets.symmetric(vertical: 16),
//                               ),
//                               child: const Text(
//                                 'Book Now (Simple)',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               onPressed: () {
//                                 if (_formKey.currentState!.validate()) {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) => BookingScreen(
//                                         hallName: hall['name'] ?? '',
//                                         functionType: selectedFunction!,
//                                       ),
//                                     ),
//                                   );
//                                 }
//                               },
//                             ),
//                           ),
//                           const SizedBox(height: 16),

//                           // ---------------- Advanced Booking ----------------
//                           SizedBox(
//                             width: double.infinity,
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.deepPurple,
//                                 padding: const EdgeInsets.symmetric(vertical: 16),
//                               ),
//                               child: const Text(
//                                 'Advanced Full Booking',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) =>
//                                         adv_booking.AdvancedFunctionBookingScreen(
//                                             hall: widget.hall),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 40),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
