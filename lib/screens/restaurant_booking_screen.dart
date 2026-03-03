import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ================== DUMMY DATA ==================
final restaurantServices = [
  {
    "name": "Tandoor Restaurant",
    "city": "Lahore",
    "menu": ["Tandoori Chicken", "Naan", "Biryani"],
    "rating": 4.7,
    "image": "assets/images/restaurant1.jpg",
    "description": "Authentic tandoori cuisine with warm ambiance."
  },
  {
    "name": "Salt Bae",
    "city": "Karachi",
    "menu": ["Steak", "Seafood", "Pasta"],
    "rating": 4.5,
    "image": "assets/images/restaurant2.jpg",
    "description": "Luxury dining with international dishes and chef specials."
  },
];

final restaurantAgents = [
  {
    "name": "Ali Restaurant",
    "phone": "03003334444",
    "email": "ali@restaurant.com",
    "experience": "7 years",
    "rating": 4.8,
    "image": "assets/images/agent3.jpg",
    "bio": "Ali manages reservations and ensures fine dining experience."
  },
  {
    "name": "Sara Restaurant",
    "phone": "03005556666",
    "email": "sara@restaurant.com",
    "experience": "5 years",
    "rating": 4.6,
    "image": "assets/images/agent4.jpg",
    "bio": "Sara specializes in group bookings and private events."
  },
];

final String defaultRestaurantAgentImage = "assets/images/default_agent.png";
final String defaultRestaurantImage = "assets/images/default_restaurant.png";

// ================== RESTAURANT BOOKING SCREEN ==================
class RestaurantBookingScreen extends StatefulWidget {
  const RestaurantBookingScreen({super.key});

  @override
  State<RestaurantBookingScreen> createState() => _RestaurantBookingScreenState();
}

class _RestaurantBookingScreenState extends State<RestaurantBookingScreen>
    with SingleTickerProviderStateMixin {
  String selectedCard = "";
  String searchQuery = "";
  bool isSearchExpanded = false;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _aiController = TextEditingController();
  final List<String> aiMessages = [];

  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    _aiController.dispose();
    super.dispose();
  }

  double responsiveWidth(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.width * percentage;

  double responsiveHeight(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.height * percentage;

  double responsiveFont(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.width * (percentage / 100);

  ImageProvider safeImage(String? path, bool isAgent) {
    if (path == null || path.isEmpty) {
      return AssetImage(isAgent ? defaultRestaurantAgentImage : defaultRestaurantImage);
    }
    return AssetImage(path);
  }

  // ================== BUILD CARD ==================
  Widget _buildCard(String title, IconData icon, Color color) {
    final bool isSelected = selectedCard == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCard = title;
          searchQuery = "";
          _searchController.clear();
        });
        _controller.forward(from: 0);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: responsiveWidth(context, isSelected ? 0.3 : 0.27),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(isSelected ? 0.25 : 0.15),
                blurRadius: isSelected ? 12 : 10,
                offset: const Offset(0, 6))
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: responsiveFont(context, 8)),
            const SizedBox(height: 10),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: responsiveFont(context, 4),
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // ================== SEARCH BOX ==================
  Widget _buildSearchBox({bool expanded = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: expanded ? 250 : 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: expanded
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      searchQuery = "";
                      isSearchExpanded = false;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.black),
              onChanged: (val) {
                setState(() {
                  searchQuery = val.toLowerCase();
                });
              },
            )
          : IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {
                setState(() {
                  isSearchExpanded = true;
                });
              },
            ),
    );
  }

  // ================== CALL & SMS ==================
  void _callNumber(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  void _smsNumber(String number) async {
    final Uri url = Uri(scheme: 'sms', path: number);
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  // ================== RESTAURANT DETAIL MODAL ==================
  void _openRestaurantDetail(Map<String, dynamic> restaurant) {
    List<String> selectedMenu = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -5))
                ]),
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16),
            child: StatefulBuilder(
              builder: (context, setModalState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(restaurant["name"] ?? "",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    Text(restaurant["description"] ?? "",
                        style: const TextStyle(fontStyle: FontStyle.italic)),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < ((restaurant["rating"] as double?)?.round() ?? 0)
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          safeImage(restaurant["image"] as String?, false),
                    ),
                    const SizedBox(height: 12),
                    _buildSearchBox(expanded: true),
                    ...((restaurant["menu"] as List<dynamic>? ?? [])
                        .map((e) => e.toString())
                        .where((menuItem) =>
                            menuItem.toLowerCase().contains(searchQuery))
                        .map((menuItem) => CheckboxListTile(
                              title: Text(menuItem),
                              value: selectedMenu.contains(menuItem),
                              onChanged: (val) {
                                setModalState(() {
                                  if (val == true) {
                                    selectedMenu.add(menuItem);
                                  } else {
                                    selectedMenu.remove(menuItem);
                                  }
                                });
                              },
                            ))
                        .toList()),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Booked ${selectedMenu.join(', ')} from ${restaurant["name"]}!")));
                        },
                        child: const Text("Book Selected Items"))
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  // ================== AI CHAT MODAL ==================
  void _openAIBot() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(0.5),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: responsiveHeight(context, 0.5),
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: aiMessages
                          .map((msg) => Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Text(msg),
                              ))
                          .toList(),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _aiController,
                          decoration:
                              const InputDecoration(hintText: "Ask AI..."),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: () {
                          final text = _aiController.text.trim();
                          if (text.isNotEmpty) {
                            setModalState(() {
                              aiMessages.add("You: $text");
                              aiMessages.add("AI: This is a dummy response.");
                              _aiController.clear();
                            });
                          }
                        },
                      )
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ================== BUILD SCREEN ==================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                "assets/images/restaurant_watermark.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: double.infinity,
                height: responsiveHeight(context, 0.25),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/restaurant_background.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Restaurant Booking",
                    style: TextStyle(
                        fontSize: responsiveFont(context, 7),
                        color: Colors.yellowAccent,
                        fontWeight: FontWeight.bold,
                        shadows: const [
                          Shadow(
                              color: Colors.black45,
                              offset: Offset(2, 2),
                              blurRadius: 4)
                        ]),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: responsiveWidth(context, 0.05)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCard("Hire Agent", Icons.person_search, Colors.green),
                    _buildCard("Direct Booking", Icons.book_online, Colors.blue),
                    _buildCard("Available Restaurants", Icons.restaurant_menu, Colors.orange),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                      horizontal: responsiveWidth(context, 0.05),
                      vertical: responsiveHeight(context, 0.02)),
                  child: Column(
                    children: restaurantServices
                        .where((s) =>
                            (s["name"] as String?)?.toLowerCase().contains(searchQuery) ??
                            false)
                        .map((service) => GestureDetector(
                              onTap: () => _openRestaurantDetail(service),
                              child: Card(
                                color: Colors.white.withOpacity(0.95),
                                margin:
                                    const EdgeInsets.symmetric(vertical: 6),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
  leading: CircleAvatar(
      backgroundImage: safeImage(service["image"] as String?, false)),
  title: Text((service["name"] as String?) ?? ""),
  subtitle: Text(
      "City: ${(service["city"] as String?) ?? ""} | Menu: ${((service["menu"] as List<dynamic>?) ?? []).join(', ')}"),
),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: responsiveHeight(context, 0.2) - 25,
            right: responsiveWidth(context, 0.05),
            child: _buildSearchBox(expanded: isSearchExpanded),
          ),
          // ================== AI BOT BUTTON ==================
          Positioned(
            bottom: 30,
            right: 20,
            child: GestureDetector(
              onTap: _openAIBot,
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 2))
                  ],
                ),
                child: const Icon(Icons.smart_toy, color: Colors.white, size: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}