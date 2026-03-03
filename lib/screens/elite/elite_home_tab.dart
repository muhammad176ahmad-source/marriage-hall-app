import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Dummy data
final cateringServices = [
  {
    "name": "Delicious Catering",
    "city": "Lahore",
    "menu": ["Wedding Catering", "Corporate Catering", "Buffet"]
  },
  {
    "name": "Taste Masters",
    "city": "Karachi",
    "menu": ["Birthday Parties", "Buffets", "Kids Party"]
  },
];

final availableHalls = [
  {"name": "Grand Royal Hall", "city": "Lahore"},
  {"name": "Elegant Hall", "city": "Karachi"},
];

final agents = [
  {"name": "Ali Catering", "phone": "03007777777"},
  {"name": "Sara Catering", "phone": "03008888888"},
];

class EliteHomeTab extends StatelessWidget {
  final Function(Map<String, dynamic>) onBook;
  final Function(String) onCallAgent;
  final String selectedCity;
  final Function(String) onCityChange;

  const EliteHomeTab({
    super.key,
    required this.onBook,
    required this.onCallAgent,
    required this.selectedCity,
    required this.onCityChange,
  });

  @override
  Widget build(BuildContext context) {
    final cities = ["All", "Lahore", "Karachi"];
    final filteredCatering = selectedCity == "All"
        ? cateringServices
        : cateringServices.where((e) => e['city'] == selectedCity).toList();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff0f2027), Color(0xff203a43), Color(0xff2c5364)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _header(cities, context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    _banner(),
                    const SizedBox(height: 20),
                    _professionalCard(
                      context,
                      "Available Catering",
                      Icons.restaurant,
                      Colors.greenAccent,
                      filteredCatering,
                      showMenu: true,
                    ),
                    _professionalCard(
                      context,
                      "Direct Hall Booking",
                      Icons.home_work,
                      Colors.deepPurpleAccent,
                      availableHalls,
                    ),
                    _professionalAgentCard(context, "Hire Agent", Icons.support_agent,
                        Colors.orangeAccent, agents),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= Header + City Selector =================
  Widget _header(List<String> cities, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Elite Catering & Events",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          DropdownButton<String>(
            dropdownColor: Colors.black87,
            value: selectedCity,
            iconEnabledColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            onChanged: (val) {
              if (val != null) onCityChange(val);
            },
            items: cities
                .map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(c, style: const TextStyle(color: Colors.white)),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  // ================= Banner =================
  Widget _banner() => Container(
        height: 220,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: NetworkImage(
                "https://images.unsplash.com/photo-1511795409834-ef04bbd61622"),
            fit: BoxFit.cover,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black54, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: const Text(
                "Luxury Event Planning\nMade Simple",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );

  // ================= Professional Card for Halls/Catering =================
  Widget _professionalCard(BuildContext context, String title, IconData icon,
      Color color, List<Map<String, dynamic>> data,
      {bool showMenu = false}) {
    return Column(
      children: data.map((item) {
        return GestureDetector(
          onTap: () => _showBookingDialog(context, item),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                              backgroundColor: color.withOpacity(0.2),
                              child: Icon(icon, color: color)),
                          const SizedBox(width: 20),
                          Expanded(
                              child: Text(item['name'],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white))),
                          const Icon(Icons.arrow_forward_ios,
                              size: 18, color: Colors.white70),
                        ],
                      ),
                      if (showMenu && item.containsKey('menu'))
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 50),
                          child: Text(
                              "Menu: ${item['menu'].join(', ')}",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white70)),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ================= Professional Agent Card =================
  Widget _professionalAgentCard(BuildContext context, String title,
      IconData icon, Color color, List<Map<String, String>> agents) {
    return Column(
      children: agents.map((agent) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5))
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                        backgroundColor: color.withOpacity(0.2),
                        child: Icon(icon, color: color)),
                    const SizedBox(width: 20),
                    Expanded(
                        child: Text(agent['name']!,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white))),
                    IconButton(
                        icon: const Icon(Icons.call, color: Colors.greenAccent),
                        onPressed: () => onCallAgent(agent['phone']!)),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ================= Booking Dialog =================
  void _showBookingDialog(BuildContext context, Map<String, dynamic> item) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      onBook({
        'name': item['name']!,
        'city': item['city']!,
        'date': picked.toLocal().toString().split(' ')[0],
        'menu': item.containsKey('menu') ? item['menu'].join(', ') : "",
      });
    }
  }
}