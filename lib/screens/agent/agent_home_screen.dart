import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const AgentApp());
}

class AgentApp extends StatelessWidget {
  const AgentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Agent Dashboard",
      home: const AgentHomeScreen(),
    );
  }
}

// ================= AGENT HOME SCREEN WITH ADVANCED FEATURES =================
class AgentHomeScreen extends StatefulWidget {
  const AgentHomeScreen({super.key});

  @override
  State<AgentHomeScreen> createState() => _AgentHomeScreenState();
}

class _AgentHomeScreenState extends State<AgentHomeScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> bookings = [
    {"name": "Grand Royal Hall", "date": "2026-03-15", "city": "Lahore"},
    {"name": "Elegant Hall", "date": "2026-03-20", "city": "Karachi"},
  ];

  final String agentName = "Ali Khan";
  final String agentEmail = "agent@email.com";
  final String agentPhone = "03001234567";

  final List<String> cities = ["Lahore", "Karachi", "Islamabad", "Multan"];

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      _homeTab(),
      _bookingsTab(),
      _profileTab(),
    ];

    return Scaffold(
      drawer: _drawer(),
      appBar: AppBar(
        title: Text(["Dashboard", "Bookings", "Profile"][_currentIndex]),
        backgroundColor: Colors.deepPurple,
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book_online), label: "Bookings"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              backgroundColor: Colors.deepPurple,
              onPressed: _showAddBookingDialog,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  // ================= DRAWER =================
  Drawer _drawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.deepPurple),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(radius: 30, backgroundColor: Colors.white),
                const SizedBox(height: 10),
                Text(agentName, style: const TextStyle(color: Colors.white, fontSize: 18)),
                Text(agentEmail, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Dashboard"),
            onTap: () => setState(() => _currentIndex = 0),
          ),
          ListTile(
            leading: const Icon(Icons.book_online),
            title: const Text("Bookings"),
            onTap: () => setState(() => _currentIndex = 1),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () => setState(() => _currentIndex = 2),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  // ================= HOME TAB =================
  Widget _homeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: _dashboardCard(
                      "Total Bookings", bookings.length.toString(), Icons.book, Colors.deepPurple, Colors.purpleAccent)),
              const SizedBox(width: 10),
              Expanded(
                  child: _dashboardCard(
                      "Pending", "5", Icons.pending_actions, Colors.orange, Colors.deepOrangeAccent)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: _dashboardCard(
                      "Earnings", "Rs. 120,000", Icons.wallet, Colors.green, Colors.lightGreen)),
              const SizedBox(width: 10),
              Expanded(
                  child: _dashboardCard(
                      "Rating", "4.8 ★", Icons.star, Colors.amber, Colors.yellowAccent)),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ================= BOOKINGS TAB =================
  Widget _bookingsTab() {
    if (bookings.isEmpty) {
      return const Center(child: Text("No bookings yet"));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(booking["name"]),
            subtitle: Text("${booking["city"]} - ${booking["date"]}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit, color: Colors.orange), onPressed: () => _editBooking(index)),
                IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteBooking(index)),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= PROFILE TAB =================
  Widget _profileTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CircleAvatar(radius: 50, backgroundColor: Colors.deepPurple),
          const SizedBox(height: 16),
          Text(agentName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(agentEmail, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 50)),
            icon: const Icon(Icons.call),
            label: const Text("Call Agent"),
            onPressed: () => _callPhone(agentPhone),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, minimumSize: const Size(double.infinity, 50)),
            icon: const Icon(Icons.email),
            label: const Text("Email Agent"),
            onPressed: () => _sendEmail(agentEmail),
          ),
        ],
      ),
    );
  }

  // ================= DASHBOARD CARD =================
  Widget _dashboardCard(String title, String value, IconData icon, Color start, Color end) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [start, end]),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: Column(
        children: [
          Icon(icon, size: 30, color: Colors.white),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  // ================= ADD BOOKING DIALOG =================
  void _showAddBookingDialog() {
    String? hallName;
    String? city = cities.first;
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Booking"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Hall Name"),
                onChanged: (val) => hallName = val,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: city,
                decoration: const InputDecoration(labelText: "City"),
                items: cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => city = val,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) selectedDate = picked;
                },
                child: const Text("Pick Date"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () {
                if (hallName != null && selectedDate != null && city != null) {
                  setState(() {
                    bookings.add({
                      "name": hallName!,
                      "date": selectedDate!.toLocal().toString().split(' ')[0],
                      "city": city!,
                    });
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please fill all fields and select date"),
                  ));
                }
              },
              child: const Text("Add")),
        ],
      ),
    );
  }

  // ================= HELPER FUNCTIONS =================
  void _editBooking(int index) {
    _showEditBookingDialog(index);
  }

  void _deleteBooking(int index) {
    setState(() => bookings.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Booking deleted")));
  }

  void _logout() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Logged out")));
  }

  void _callPhone(String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  void _sendEmail(String email) async {
    final Uri url = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  // ================= EDIT BOOKING DIALOG =================
  void _showEditBookingDialog(int index) {
    String hallName = bookings[index]["name"];
    String city = bookings[index]["city"];
    DateTime selectedDate = DateTime.parse(bookings[index]["date"]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Booking"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Hall Name"),
                controller: TextEditingController(text: hallName),
                onChanged: (val) => hallName = val,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: city,
                decoration: const InputDecoration(labelText: "City"),
                items: cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => city = val!,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) selectedDate = picked;
                },
                child: const Text("Pick Date"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  bookings[index] = {
                    "name": hallName,
                    "city": city,
                    "date": selectedDate.toLocal().toString().split(' ')[0],
                  };
                });
                Navigator.pop(context);
              },
              child: const Text("Save")),
        ],
      ),
    );
  }
}