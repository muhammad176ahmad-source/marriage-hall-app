import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ================== DUMMY DATA ==================
final hallServices = [
  {
    "name": "Royal Hall",
    "city": "Lahore",
    "menu": ["Buffet", "BBQ", "Pakistani Cuisine"],
    "rating": 4.5,
    "image": "assets/images/hall1.jpg",
    "description":
        "Elegant halls for weddings, corporate events, and special occasions. Trusted by thousands of clients."
  },
  {
    "name": "Grand Palace",
    "city": "Karachi",
    "menu": ["Continental", "Chinese", "Italian"],
    "rating": 4.2,
    "image": "assets/images/hall2.jpg",
    "description":
        "Spacious and luxurious halls for all celebrations. Professional staff and customizable setups."
  },
];

final hallAgents = [
  {
    "name": "Ali Hall",
    "phone": "03007777777",
    "email": "ali@hall.com",
    "experience": "5 years",
    "rating": 4.7,
    "image": "assets/images/agent1.jpg",
    "bio":
        "Ali is an experienced hall agent specializing in corporate and wedding events. Highly recommended for personalized service."
  },
  {
    "name": "Sara Hall",
    "phone": "03008888888",
    "email": "sara@hall.com",
    "experience": "7 years",
    "rating": 4.9,
    "image": "assets/images/agent2.jpg",
    "bio":
        "Sara has over 7 years of experience providing excellent hall service. Known for her attention to detail and client satisfaction."
  },
];

final String defaultAgentImage = "assets/images/default_agent.png";
final String defaultHallImage = "assets/images/default_hall.png";

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

// ================== HALL BOOKING SCREEN ==================
class HallBookingScreen extends StatefulWidget {
  const HallBookingScreen({super.key});

  @override
  State<HallBookingScreen> createState() => _HallBookingScreenState();
}

class _HallBookingScreenState extends State<HallBookingScreen>
    with TickerProviderStateMixin {
  String selectedCard = "";
  String searchQuery = "";
  bool isSearchExpanded = false;

  final TextEditingController _searchController = TextEditingController();

  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  late final AnimationController _botController;
  late final Animation<double> _botAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _botController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _botAnimation = CurvedAnimation(parent: _botController, curve: Curves.easeInOut);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animateBotPeriodically();
    });
  }

  void _animateBotPeriodically() async {
    while (mounted) {
      await Future.delayed(const Duration(minutes: 5));
      if (!mounted) return;
      _botController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _botController.dispose();
    _searchController.dispose();
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
      return AssetImage(isAgent ? defaultAgentImage : defaultHallImage);
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
                    fontSize: responsiveFont(context, 4), fontWeight: FontWeight.bold)),
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
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4), BlendMode.darken),
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
                    color: Colors.white)),
            const SizedBox(height: 6),
            Text(description,
                style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.white70)),
          ],
        ),
      );
    }

    switch (selectedCard) {
      case "Hire Agent":
        content.add(sectionHeader(
          "assets/images/agent_bg.jpg",
          "Hire Agent",
          "Definition: Professional hall agents.\nUsage: Hire them for events.\nBenefits: Personalized service, experience, convenience.",
        ));

        final filteredAgents = hallAgents
            .where((agent) =>
                ((agent["name"] as String?)?.toLowerCase() ?? "")
                    .contains(searchQuery))
            .toList();

        content.add(
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: filteredAgents.map((agent) {
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
                      leading: CircleAvatar(
                          backgroundImage: safeImage(image, true)),
                      title: Text(name,
                          style: const TextStyle(color: Colors.black)),
                      subtitle: Text("Phone: $phone",
                          style:
                              const TextStyle(color: Colors.black87)),
                      trailing: IconButton(
                        icon: const Icon(Icons.call, color: Colors.green),
                        onPressed: () async {
                          if (phone.isNotEmpty) {
                            final Uri url = Uri(scheme: 'tel', path: phone);
                            if (await canLaunchUrl(url))
                              await launchUrl(url);
                          }
                        },
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
        break;

      case "Direct Booking":
        content.add(sectionHeader(
          "assets/images/hall_bg.jpg",
          "Direct Booking",
          "Definition: Book halls directly.\nUsage: Select items and confirm.\nBenefits: Fast, reliable, tailored setup.",
        ));

        final filteredHalls = hallServices
            .where((s) =>
                ((s["name"] as String?)?.toLowerCase() ?? "")
                    .contains(searchQuery))
            .toList();

        content.addAll(filteredHalls.map((service) {
          final name = (service["name"] as String?) ?? "";
          final city = (service["city"] as String?) ?? "";
          final image = (service["image"] as String?) ?? "";
          final menuList =
              ((service["menu"] as List<dynamic>?) ?? [])
                  .map((e) => e.toString())
                  .toList();

          return GestureDetector(
            onTap: () => _openHallDetail(service),
            child: Card(
              color: Colors.white.withOpacity(0.95),
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading:
                    CircleAvatar(backgroundImage: safeImage(image, false)),
                title: Text(name),
                subtitle: Text("City: $city | Setup: ${menuList.join(', ')}"),
              ),
            ),
          );
        }).toList());
        break;

      case "Available Halls":
        content.add(sectionHeader(
          "assets/images/hall_bg2.jpg",
          "Available Halls",
          "Definition: Full hall services.\nUsage: Browse menu and availability.\nBenefits: Wide selection, professional quality, convenience.",
        ));

        final filteredHalls2 = hallServices
            .where((s) =>
                ((s["name"] as String?)?.toLowerCase() ?? "")
                    .contains(searchQuery))
            .toList();

        content.addAll(filteredHalls2.map((service) {
          final name = (service["name"] as String?) ?? "";
          final city = (service["city"] as String?) ?? "";
          final image = (service["image"] as String?) ?? "";
          final menuList =
              ((service["menu"] as List<dynamic>?) ?? [])
                  .map((e) => e.toString())
                  .toList();

          return GestureDetector(
            onTap: () => _openHallDetail(service),
            child: Card(
              color: Colors.white.withOpacity(0.95),
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading:
                    CircleAvatar(backgroundImage: safeImage(image, false)),
                title: Text(name),
                subtitle: Text("City: $city | Setup: ${menuList.join(', ')}"),
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
                  color: Colors.grey[600]),
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
    final proceed = await showSafetyDialog(
        context, "call or email this agent", agent["name"] ?? "");
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
                    style:
                        const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text("Experience: ${agent["experience"] ?? ""}"),
                Text(agent["bio"] ?? "",
                    style: const TextStyle(fontStyle: FontStyle.italic)),
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
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
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
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
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

  // ================== HALL DETAIL ==================
  void _openHallDetail(Map<String, dynamic> service) async {
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
                    Text(service["name"] as String? ?? "",
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    Text(service["description"] as String? ?? "",
                        style: const TextStyle(fontStyle: FontStyle.italic)),
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
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: responsiveHeight(context, 0.25),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/hall_background.jpg"),
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
                      "Hall Booking",
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
                    _buildCard("Available Halls", Icons.restaurant_menu, Colors.orange),
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
          // Floating AI Bot
          Positioned(
            bottom: 20,
            right: 20,
            child: ScaleTransition(
              scale: _botAnimation,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: const AssetImage("assets/images/ai_bot.png"),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "AI Assistant",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}