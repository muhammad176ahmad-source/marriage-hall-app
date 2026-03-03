import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ================== DUMMY DATA ==================
final cateringServices = [
  {
    "name": "Delicious Catering",
    "city": "Lahore",
    "menu": ["Wedding Catering", "Corporate Catering", "Buffet"],
    "rating": 4.5,
    "image": "assets/images/service1.jpg",
    "description":
        "High-quality catering for weddings, corporate events, and special occasions. Trusted by thousands of happy clients."
  },
  {
    "name": "Taste Masters",
    "city": "Karachi",
    "menu": ["Birthday Parties", "Buffets", "Kids Party"],
    "rating": 4.2,
    "image": "assets/images/service2.jpg",
    "description":
        "Affordable and delicious catering services for all kinds of celebrations. Professional staff and flexible menu options."
  },
];

final agents = [
  {
    "name": "Ali Catering",
    "phone": "03007777777",
    "email": "ali@example.com",
    "experience": "5 years",
    "rating": 4.7,
    "image": "assets/images/agent1.jpg",
    "bio":
        "Ali is an experienced catering agent specializing in corporate and wedding events. Highly recommended for personalized service."
  },
  {
    "name": "Sara Catering",
    "phone": "03008888888",
    "email": "sara@example.com",
    "experience": "7 years",
    "rating": 4.9,
    "image": "assets/images/agent2.jpg",
    "bio":
        "Sara has over 7 years of experience providing excellent catering service. Known for her attention to detail and client satisfaction."
  },
];

final String defaultAgentImage = "assets/images/default_agent.png";
final String defaultServiceImage = "assets/images/default_service.png";

// ================== SAFETY DIALOG ==================
Future<bool?> showSafetyDialog(
    BuildContext context, String action, String info) {
  return showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Confirm Action"),
      content: Text(
          "You are about to $action: $info\n\nPlease confirm you want to proceed."),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context, false),
        ),
        ElevatedButton(
          child: const Text("Proceed"),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    ),
  );
}

// ================== CATERING BOOKING SCREEN ==================
class CateringBookingScreen extends StatefulWidget {
  const CateringBookingScreen({super.key});

  @override
  State<CateringBookingScreen> createState() => _CateringBookingScreenState();
}

class _CateringBookingScreenState extends State<CateringBookingScreen>
    with SingleTickerProviderStateMixin {
  String selectedCard = "";
  String searchQuery = "";
  bool isSearchExpanded = false;
  bool showAIBot = true;

  final TextEditingController _searchController = TextEditingController();

  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  Timer? _aiBotTimer;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // AI bot wave timer every 5 minutes
    _aiBotTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      setState(() {
        showAIBot = true;
      });
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) setState(() => showAIBot = false);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    _aiBotTimer?.cancel();
    super.dispose();
  }

  double responsiveWidth(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.width * percentage;

  double responsiveHeight(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.height * percentage;

  double responsiveFont(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.width * (percentage / 100);

  // ================== SAFE IMAGE LOADER ==================
  ImageProvider safeImage(String? path, bool isAgent) {
    if (path == null || path.isEmpty) {
      return AssetImage(isAgent ? defaultAgentImage : defaultServiceImage);
    }
    return AssetImage(path);
  }

  // ================== CARD BUILDER ==================
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
        width: responsiveWidth(context, 0.3),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 12,
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
                    fontSize: responsiveFont(context, 4.2),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto')),
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

  // ================== DATA SECTION ==================
  Widget _buildDataSection() {
    List<Widget> content = [];

    Widget sectionHeader(String imagePath, String title, String description) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter:
                const ColorFilter.mode(Colors.black54, BlendMode.darken),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Roboto')),
            const SizedBox(height: 6),
            Text(description,
                style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.white70,
                    fontFamily: 'Roboto')),
          ],
        ),
      );
    }

    // --------- ORIGINAL CONTENT LOGIC ---------
    switch (selectedCard) {
      case "Hire Agent":
        content.add(sectionHeader(
          "assets/images/agent_bg.jpg",
          "Hire Agent",
          "Definition: Professional catering agents.\nUsage: Hire them for events.\nBenefits: Personalized service, experience, convenience.",
        ));
        final filteredAgents = agents
            .where((agent) =>
                ((agent["name"] as String?)?.toLowerCase() ?? "")
                    .contains(searchQuery))
            .toList();
        content.addAll(filteredAgents.map((agent) {
          final name = (agent["name"] as String?) ?? "";
          final phone = (agent["phone"] as String?) ?? "";
          final image = (agent["image"] as String?) ?? "";

          return GestureDetector(
            onTap: () => _openAgentDetail(agent),
            child: Card(
              color: Colors.white.withOpacity(0.95),
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(backgroundImage: safeImage(image, true)),
                title: Text(name,
                    style: const TextStyle(
                        color: Colors.black, fontFamily: 'Roboto')),
                subtitle: Text("Phone: $phone",
                    style: const TextStyle(
                        color: Colors.black87, fontFamily: 'Roboto')),
                trailing: IconButton(
                  icon: const Icon(Icons.call, color: Colors.green),
                  onPressed: () async {
                    if (phone.isNotEmpty) {
                      final Uri url = Uri(scheme: 'tel', path: phone);
                      if (await canLaunchUrl(url)) await launchUrl(url);
                    }
                  },
                ),
              ),
            ),
          );
        }).toList());
        break;

      case "Direct Booking":
        content.add(sectionHeader(
          "assets/images/booking_bg.jpg",
          "Direct Booking",
          "Definition: Book catering services directly.\nUsage: Select items and confirm.\nBenefits: Fast, reliable, tailored menu.",
        ));
        final filteredServices = cateringServices
            .where((s) =>
                ((s["name"] as String?)?.toLowerCase() ?? "")
                    .contains(searchQuery))
            .toList();
        content.addAll(filteredServices.map((service) {
          final name = (service["name"] as String?) ?? "";
          final city = (service["city"] as String?) ?? "";
          final image = (service["image"] as String?) ?? "";
          final menuList = ((service["menu"] as List<dynamic>? ?? []))
              .map((e) => e.toString())
              .toList();
          return GestureDetector(
            onTap: () => _openRestaurantDetail(service),
            child: Card(
              color: Colors.white.withOpacity(0.95),
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(backgroundImage: safeImage(image, false)),
                title: Text(name,
                    style: const TextStyle(
                        fontFamily: 'Roboto', fontWeight: FontWeight.w500)),
                subtitle: Text("City: $city | Menu: ${menuList.join(', ')}",
                    style: const TextStyle(fontFamily: 'Roboto')),
              ),
            ),
          );
        }).toList());
        break;

      case "Available Catering":
        content.add(sectionHeader(
          "assets/images/catering_bg.jpg",
          "Available Catering",
          "Definition: Full catering services.\nUsage: Browse menu and availability.\nBenefits: Wide selection, professional quality, convenience.",
        ));
        final filteredServices2 = cateringServices
            .where((s) =>
                ((s["name"] as String?)?.toLowerCase() ?? "")
                    .contains(searchQuery))
            .toList();
        content.addAll(filteredServices2.map((service) {
          final name = (service["name"] as String?) ?? "";
          final city = (service["city"] as String?) ?? "";
          final image = (service["image"] as String?) ?? "";
          final menuList = ((service["menu"] as List<dynamic>? ?? []))
              .map((e) => e.toString())
              .toList();
          return GestureDetector(
            onTap: () => _openRestaurantDetail(service),
            child: Card(
              color: Colors.white.withOpacity(0.95),
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(backgroundImage: safeImage(image, false)),
                title: Text(name,
                    style: const TextStyle(
                        fontFamily: 'Roboto', fontWeight: FontWeight.w500)),
                subtitle: Text("City: $city | Menu: ${menuList.join(', ')}",
                    style: const TextStyle(fontFamily: 'Roboto')),
              ),
            ),
          );
        }).toList());
        break;

      default:
        content.add(
          Center(
            child: Text(
              "Select a card above to view details",
              style: TextStyle(
                  fontSize: responsiveFont(context, 4),
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                  fontFamily: 'Roboto'),
            ),
          ),
        );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(children: content),
    );
  }

  // ================== AGENT DETAIL ==================
  void _openAgentDetail(Map<String, dynamic> agent) async {
    final proceed =
        await showSafetyDialog(context, "call or email this agent", agent["name"] ?? "");
    if (proceed != true) return;

    final name = agent["name"] as String? ?? "";

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => Scaffold(
          appBar: AppBar(title: Text(name), backgroundColor: Colors.green),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Hero(
                  tag: name,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: safeImage(agent["image"] as String?, true),
                  ),
                ),
                const SizedBox(height: 12),
                Text(name,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto')),
                Text("Experience: ${agent["experience"] ?? ""}",
                    style: const TextStyle(fontFamily: 'Roboto')),
                Text(agent["bio"] ?? "",
                    style: const TextStyle(
                        fontStyle: FontStyle.italic, fontFamily: 'Roboto')),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < ((agent["rating"] as double?)?.round() ?? 0)
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton.icon(
                        icon: const Icon(Icons.call),
                        label: const Text("Call"),
                        style:
                            ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        onPressed: () async {
                          final phone = agent["phone"] as String? ?? "";
                          if (phone.isNotEmpty) {
                            final Uri url = Uri(scheme: 'tel', path: phone);
                            if (await canLaunchUrl(url)) await launchUrl(url);
                          }
                        }),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                        icon: const Icon(Icons.email),
                        label: const Text("Email"),
                        style:
                            ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        onPressed: () async {
                          final email = agent["email"] as String? ?? "";
                          if (email.isNotEmpty) {
                            final Uri url = Uri(scheme: 'mailto', path: email);
                            if (await canLaunchUrl(url)) await launchUrl(url);
                          }
                        }),
                  ],
                )
              ],
            ),
          ),
        ),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween(begin: const Offset(0, 0.1), end: Offset.zero).animate(animation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  // ================== RESTAURANT DETAIL ==================
  void _openRestaurantDetail(Map<String, dynamic> service) async {
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
                  BoxShadow(
                      color: Colors.black26, blurRadius: 10, offset: Offset(0, -5))
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
                    Text(service["name"] as String? ?? "",
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto')),
                    Text(service["description"] as String? ?? "",
                        style: const TextStyle(
                            fontStyle: FontStyle.italic, fontFamily: 'Roboto')),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < ((service["rating"] as double?)?.round() ?? 0)
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: safeImage(service["image"] as String?, false),
                    ),
                    const SizedBox(height: 12),
                    _buildSearchBox(expanded: true),
                    ...((service["menu"] as List<dynamic>? ?? [])
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
                                  "Booked ${selectedMenu.join(', ')} from ${service["name"]}!")));
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

  // ================== BUILD ==================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ---------- BACKGROUND WATERMARK ----------
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: Image.asset(
                "assets/images/watermark.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: responsiveHeight(context, 0.25),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/catering_background.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Text(
                      "Catering Booking",
                      style: TextStyle(
                        fontSize: responsiveFont(context, 7),
                        color: Colors.yellowAccent,
                        fontWeight: FontWeight.bold,
                        shadows: const [
                          Shadow(
                              color: Colors.black45,
                              offset: Offset(2, 2),
                              blurRadius: 4)
                        ],
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsiveHeight(context, 0.02)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: responsiveWidth(context, 0.05)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCard("Hire Agent", Icons.person_search, Colors.green),
                    _buildCard("Direct Booking", Icons.book_online, Colors.blue),
                    _buildCard("Available Catering", Icons.restaurant_menu, Colors.orange),
                  ],
                ),
              ),
              SizedBox(height: responsiveHeight(context, 0.02)),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey.shade100, Colors.grey.shade300],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsiveWidth(context, 0.05),
                      vertical: responsiveHeight(context, 0.02),
                    ),
                    child: _buildDataSection(),
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
          // -------- AI BOT WIDGET ---------
          if (showAIBot)
            Positioned(
              bottom: 20,
              right: 20,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 70,
                height: 70,
                child: Image.asset(
                  "assets/images/ai_bot.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
        ],
      ),
    );
  }
}