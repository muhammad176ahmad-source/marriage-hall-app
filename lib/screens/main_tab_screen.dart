import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

// ================= DUMMY DATA =================
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

// ================= MAIN TAB SCREEN =================
class MainTabScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  const MainTabScreen({super.key, required this.onThemeToggle});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _currentIndex = 0;
  final List<Map<String, dynamic>> bookings = [];

  int _carouselIndex = 0;
  final List<String> bannerImages = [
    "https://images.unsplash.com/photo-1511795409834-ef04bbd61622",
    "https://images.unsplash.com/photo-1504674900247-0877df9cc836",
    "https://images.unsplash.com/photo-1546069901-ba9599a7e63c",
  ];
  Timer? _carouselTimer;

  String selectedCity = "All";

  @override
  void initState() {
    super.initState();
    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      setState(() {
        _carouselIndex = (_carouselIndex + 1) % bannerImages.length;
      });
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    super.dispose();
  }

  // ==================== Responsive Helpers ====================
  double w(BuildContext context, double percent) => MediaQuery.of(context).size.width * percent;
  double h(BuildContext context, double percent) => MediaQuery.of(context).size.height * percent;
  double f(BuildContext context, double percent) => MediaQuery.of(context).size.width * (percent / 100);

  // ==================== Add Booking ====================
  void _addBooking(Map<String, dynamic> booking) {
    setState(() => bookings.add(booking));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${booking['name']} booked successfully!")),
    );
  }

  // ==================== Delete Booking ====================
  void _deleteBooking(int index) {
    final removed = bookings.removeAt(index);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${removed['name']} booking deleted!")),
    );
  }

  // ==================== Call Agent ====================
  void _callAgent(String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      _homeTab(),
      _bookingsTab(),
      _profileTab(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Bookings"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // ==================== Home Tab ====================
  Widget _homeTab() {
    final cities = ["All", "Lahore", "Karachi"];
    List<Map<String, dynamic>> filteredCatering = selectedCity == "All"
        ? cateringServices
        : cateringServices.where((e) => e['city'] == selectedCity).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Catering Booking"),
        actions: [
          DropdownButton<String>(
            value: selectedCity,
            items: cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (val) {
              if (val != null) setState(() => selectedCity = val);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ===== Carousel Banner =====
            Stack(
              children: [
                SizedBox(
                  height: h(context, 0.25),
                  width: double.infinity,
                  child: Image.network(
                    bannerImages[_carouselIndex],
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: h(context, 0.25),
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.3),
                  alignment: Alignment.center,
                  child: Text(
                    "Catering Booking",
                    style: TextStyle(color: Colors.white, fontSize: f(context, 7), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // ===== Cards =====
            _actionCard("Available Catering", Icons.restaurant, Colors.green, filteredCatering),
            _actionCard("Direct Hall Booking", Icons.home_work, Colors.deepPurple, availableHalls),
            _actionCard("Hire Agent", Icons.support_agent, Colors.orange, agents),
          ],
        ),
      ),
    );
  }

  // ==================== Card Widget ====================
  Widget _actionCard(String title, IconData icon, Color color, List data) {
    return GestureDetector(
      onTap: () => _showDataDialog(title, data),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.1))],
        ),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: color.withOpacity(0.2), child: Icon(icon, color: color, size: 28)),
            const SizedBox(width: 20),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 18)
          ],
        ),
      ),
    );
  }

  // ==================== Show Data Popup ====================
  void _showDataDialog(String title, List data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (_, index) {
                final item = data[index];
                String subtitle = "";
                if (item.containsKey('city')) subtitle = item['city'];
                if (item.containsKey('menu')) subtitle += "\nMenu: ${item['menu'].join(', ')}";

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(item['name'] ?? "Agent"),
                    subtitle: Text(subtitle),
                    trailing: ElevatedButton(
                      child: const Text("Book"),
                      onPressed: () {
                        Map<String, dynamic> bookingData = {
                          "name": item['name'] ?? "Agent",
                          "city": item['city'] ?? "",
                          "menu": item.containsKey('menu') ? item['menu'].join(', ') : "",
                          "date": DateTime.now().toLocal().toString().split(' ')[0],
                        };
                        _addBooking(bookingData);
                        Navigator.pop(context);
                      },
                    ),
                    onTap: item.containsKey('phone')
                        ? () => _callAgent(item['phone'])
                        : null,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  // ==================== Bookings Tab ====================
  Widget _bookingsTab() {
    return Scaffold(
      appBar: AppBar(title: const Text("My Bookings")),
      body: bookings.isEmpty
          ? const Center(child: Text("No bookings yet"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (_, index) {
                final b = bookings[index];
                return Dismissible(
                  key: Key(b['name'] + index.toString()),
                  background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(Icons.delete, color: Colors.white)),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (_) => _deleteBooking(index),
                  child: ListTile(
                    title: Text(b['name']),
                    subtitle: Text("${b['city']} - ${b['date']}\n${b['menu']}"),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }

  // ==================== Profile Tab ====================
  Widget _profileTab() {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text("Toggle Theme"),
              trailing: Switch(
                  value: false,
                  onChanged: (_) => widget.onThemeToggle()),
            ),
          ],
        ),
      ),
    );
  }
}