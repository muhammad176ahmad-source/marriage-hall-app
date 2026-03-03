import 'package:flutter/material.dart';
import 'add_venue_screen.dart';
import 'wallet_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final pages = const [
    DashboardScreen(),
    WalletScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Wallet"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        onPressed: () async {
          // Navigate to AddVenueScreen and wait for result
          final newBooking = await Navigator.push<Map<String, String>>(
              context,
              MaterialPageRoute(builder: (_) => const AddVenueScreen()));

          if (newBooking != null) {
            // Update dashboard with new booking dynamically
            DashboardScreenState.addNewBooking(newBooking);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Venue"),
      ),
    );
  }
}

// ================= DASHBOARD =================
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  static int bookings = 0;
  static int earnings = 0;
  static final List<Map<String, String>> recentBookings = [
    {"name": "Ali Wedding", "date": "12 March 2026", "status": "Confirmed"},
    {"name": "Sara Engagement", "date": "18 March 2026", "status": "Pending"},
    {"name": "Corporate Dinner", "date": "25 March 2026", "status": "Completed"},
  ];

  late AnimationController _controller;
  late Animation<double> _bookingsAnim;
  late Animation<double> _earningsAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _bookingsAnim = Tween<double>(begin: 0, end: bookings.toDouble()).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _earningsAnim = Tween<double>(begin: 0, end: earnings.toDouble()).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  static void addNewBooking(Map<String, String> booking) {
    recentBookings.insert(0, booking); // Add new booking at top
    bookings += 1;
    earnings += 5000; // Example increment, can be dynamic

    // Rebuild dashboard by calling setState on active instance
    if (_activeState != null) _activeState!._refreshAnimations();
  }

  static DashboardScreenState? _activeState;

  void _refreshAnimations() {
    _controller.dispose();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _bookingsAnim = Tween<double>(begin: _bookingsAnim.value, end: bookings.toDouble()).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _earningsAnim = Tween<double>(begin: _earningsAnim.value, end: earnings.toDouble()).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _activeState = this; // register active instance
  }

  @override
  void dispose() {
    _controller.dispose();
    if (_activeState == this) _activeState = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, left: 20, bottom: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.deepPurple, Colors.purpleAccent]),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            ),
            child: const Text(
              "Agent Dashboard",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: AnimatedBuilder(
                    animation: _bookingsAnim,
                    builder: (context, child) {
                      return _statCard(
                        "Bookings",
                        _bookingsAnim.value.toInt().toString(),
                        Icons.book,
                        Colors.deepPurple,
                        Colors.purpleAccent,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _earningsAnim,
                    builder: (context, child) {
                      return _statCard(
                        "Earnings",
                        "Rs.${_earningsAnim.value.toInt()}",
                        Icons.wallet,
                        Colors.green,
                        Colors.lightGreen,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent Bookings",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: recentBookings.map((b) => _bookingCard(b)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color startColor, Color endColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [startColor, endColor]),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
          Text(title, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _bookingCard(Map<String, String> b) {
    Color statusColor;
    switch (b["status"]) {
      case "Confirmed":
        statusColor = Colors.green;
        break;
      case "Pending":
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.blue;
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(b["name"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(b["date"]!, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              b["status"]!,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}