import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ==================== Dummy Data for Halls, Agents, Restaurants, Catering, and Hotels ====================

// Dummy Data for Halls
final List<Map<String, dynamic>> availableHalls = [
  {"name": "Royal Hall", "city": "Lahore", "phone": "0300-1111111", "menu": ["Buffet", "BBQ", "Pakistani Cuisine"]},
  {"name": "Grand Palace", "city": "Karachi", "phone": "0300-2222222", "menu": ["Continental", "Chinese", "Italian"]},
];

// Dummy Data for Agents
final List<Map<String, dynamic>> agents = [
  {"name": "Ali Khan", "phone": "0311-1234567", "fee": "50,000"},
  {"name": "Sara Ahmed", "phone": "0312-7654321", "fee": "45,000"},
];

// Dummy Data for Restaurants
final List<Map<String, dynamic>> restaurants = [
  {"name": "Tandoor Restaurant", "city": "Lahore", "phone": "0300-3333333", "menu": ["Tandoori Chicken", "Naan", "Biryani"]},
  {"name": "Salt Bae", "city": "Karachi", "phone": "0300-4444444", "menu": ["Steak", "Seafood", "Pasta"]},
];

// Dummy Data for Catering
final List<Map<String, dynamic>> cateringServices = [
  {"name": "Delicious Catering", "city": "Lahore", "phone": "0300-5555555", "menu": ["Wedding Catering", "Corporate Catering"]},
  {"name": "Taste Masters", "city": "Karachi", "phone": "0300-6666666", "menu": ["Birthday Parties", "Buffets"]},
];

// Dummy Data for Hotels
final List<Map<String, dynamic>> hotels = [
  {"name": "Luxury Hotel", "city": "Lahore", "phone": "0300-7777777", "menu": ["Room Service", "Buffet", "Poolside Bar"]},
  {"name": "Five Star Inn", "city": "Karachi", "phone": "0300-8888888", "menu": ["Breakfast", "Dinner", "Room Service"]},
];

// ==================== Category Details Screen with Menus ====================
class CategoryDetailsScreen extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final Function(String) onCall;
  final Function(String) onMessage;

  const CategoryDetailsScreen({
    super.key,
    required this.title,
    required this.items,
    required this.onCall,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            for (var item in items) 
              _itemCard(item, onCall, onMessage),
          ],
        ),
      ),
    );
  }

  Widget _itemCard(Map<String, dynamic> item, Function(String) onCall, Function(String) onMessage) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('City: ${item['city']}', style: const TextStyle(fontSize: 16)),
                    Text('Phone: ${item['phone']}', style: const TextStyle(fontSize: 14)),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.call, color: Colors.green),
                      onPressed: () => onCall(item['phone']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.message, color: Colors.blue),
                      onPressed: () => onMessage(item['phone']),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Menu: ${item['menu'].join(', ')}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== Base Booking Screen (For Categories) ====================
class BaseBookingScreen extends StatefulWidget {
  final String title;
  final Color gradientStart;
  final Color gradientEnd;
  final List<Map<String, dynamic>> items;

  const BaseBookingScreen({
    super.key,
    required this.title,
    required this.gradientStart,
    required this.gradientEnd,
    required this.items,
  });

  @override
  State<BaseBookingScreen> createState() => _BaseBookingScreenState();
}

class _BaseBookingScreenState extends State<BaseBookingScreen> {
  bool showHalls = false;
  bool showAgents = false;
  bool showDirectBooking = false;

  double responsiveWidth(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.width * percentage;

  double responsiveHeight(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.height * percentage;

  double responsiveFont(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.width * (percentage / 100);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [widget.gradientStart, widget.gradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            height: responsiveHeight(context, 0.25),
            width: double.infinity,
          ),

          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: responsiveFont(context, 5.5),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Content
          Positioned(
            top: responsiveHeight(context, 0.25),
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: responsiveWidth(context, 0.05)),
              child: Column(
                children: [
                  // ==================== Professional Buttons ====================
                  _professionalCard(
                    title: "Available Halls",
                    icon: Icons.home_work,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryDetailsScreen(
                            title: "Available Halls",
                            items: availableHalls,
                            onCall: _callNumber,
                            onMessage: _smsNumber,
                          ),
                        ),
                      );
                    },
                  ),
                  _professionalCard(
                    title: "Hire Agent",
                    icon: Icons.person,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryDetailsScreen(
                            title: "Hire Agent",
                            items: agents,
                            onCall: _callNumber,
                            onMessage: _smsNumber,
                          ),
                        ),
                      );
                    },
                  ),
                  _professionalCard(
                    title: "Direct Booking",
                    icon: Icons.location_city,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryDetailsScreen(
                            title: "Direct Booking",
                            items: cateringServices,  // You can replace this with the actual direct booking data
                            onCall: _callNumber,
                            onMessage: _smsNumber,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _professionalCard({required String title, required IconData icon, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 28),
        label: Text(title, style: TextStyle(fontSize: responsiveFont(context, 5), fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, responsiveHeight(context, 0.09)),
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
        ),
        onPressed: onTap,
      ),
    );
  }

  // ==================== Call and SMS Functions ====================
  void _callNumber(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  void _smsNumber(String number) async {
    final Uri url = Uri(scheme: 'sms', path: number);
    if (await canLaunchUrl(url)) await launchUrl(url);
  }
}
