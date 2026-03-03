import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'elite_home_tab.dart';
import 'elite_booking_tab.dart';
import 'elite_profile_tab.dart';

class EliteMainTabScreen extends StatefulWidget {
  const EliteMainTabScreen({super.key});
  @override
  State<EliteMainTabScreen> createState() => _EliteMainTabScreenState();
}

class _EliteMainTabScreenState extends State<EliteMainTabScreen> {
  int _currentIndex = 0;
  final List<Map<String, dynamic>> bookings = [];
  String selectedCity = "All";

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      EliteHomeTab(
        onBook: _addBooking,
        onCallAgent: _callAgent,
        selectedCity: selectedCity,
        onCityChange: (city) => setState(() => selectedCity = city),
      ),
      EliteBookingTab(
        bookings: bookings,
        onEditBooking: _editBooking,
        onDeleteBooking: _deleteBooking,
      ),
      const EliteProfileTab(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            selectedItemColor: Colors.deepPurpleAccent,
            unselectedItemColor: Colors.grey[400],
            backgroundColor: Colors.white.withOpacity(0.95),
            showUnselectedLabels: true,
            onTap: (i) => setState(() => _currentIndex = i),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Bookings"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
            ],
          ),
        ),
      ),
    );
  }

  // ================= BOOKING LOGIC =================
  void _addBooking(Map<String, dynamic> booking) {
    setState(() => bookings.add(booking));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${booking['name']} booked successfully!")),
    );
  }

  void _deleteBooking(int index) {
    final removed = bookings.removeAt(index);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${removed['name']} booking deleted!")),
    );
  }

  void _editBooking(int index, String newDate) {
    setState(() => bookings[index]['date'] = newDate);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${bookings[index]['name']} date updated!")),
    );
  }

  // ================= CALL AGENT LOGIC =================
  void _callAgent(String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // opens phone dialer app
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not launch phone dialer")),
      );
    }
  }
}