import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'category_screen.dart';
import 'proposal_screen.dart';
import 'function_calculator_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

// ================= Sample category data =================
final Map<String, List<Map<String, dynamic>>> categoryData = {
  "Agents": [
    {
      "name": "Ali Agency",
      "phone": "+923001234567",
      "location": "Karachi",
      "fee": 5000,
      "images": [
        "assets/images/agents/agent1_1.jpg",
        "assets/images/agents/agent1_2.jpg"
      ]
    },
    {
      "name": "Sara Agency",
      "phone": "+923002345678",
      "location": "Lahore",
      "fee": 7000,
      "images": [
        "assets/images/agents/agent2_1.jpg",
        "assets/images/agents/agent2_2.jpg"
      ]
    }
  ],
  "Halls": [
    {
      "name": "Royal Banquet Hall",
      "phone": "+923003456789",
      "location": "Karachi",
      "fee": 250000,
      "images": [
        "assets/images/halls/hall1.jpg",
        "assets/images/halls/hall2.jpg"
      ]
    },
    {
      "name": "Grand Palace",
      "phone": "+923004567890",
      "location": "Lahore",
      "fee": 300000,
      "images": [
        "assets/images/halls/hall3.jpg",
        "assets/images/halls/hall4.jpg"
      ]
    }
  ],
  "Restaurants": [
    {
      "name": "Biryani Palace",
      "phone": "+923005678901",
      "location": "Karachi",
      "fee": 2000,
      "images": [
        "assets/images/restaurants/rest1_1.jpg",
        "assets/images/restaurants/rest1_2.jpg"
      ]
    }
  ],
  "Catering": [
    {
      "name": "Delicious Catering",
      "phone": "+923006789012",
      "location": "Lahore",
      "fee": 15000,
      "images": [
        "assets/images/catering/cater1_1.jpg",
        "assets/images/catering/cater1_2.jpg"
      ]
    }
  ]
};

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  double responsiveWidth(BuildContext context, double p) =>
      MediaQuery.of(context).size.width * p;
  double responsiveHeight(BuildContext context, double p) =>
      MediaQuery.of(context).size.height * p;
  double responsiveFont(BuildContext context, double p) =>
      MediaQuery.of(context).size.width * (p / 100);

  final PageController _sliderController = PageController();
  Timer? _sliderTimer;

  @override
  void initState() {
    super.initState();
    _sliderTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_sliderController.hasClients) {
        int nextPage = _sliderController.page!.round() + 1;
        if (nextPage >= 10) nextPage = 0;
        _sliderController.animateToPage(nextPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    _sliderController.dispose();
    _sliderTimer?.cancel();
    super.dispose();
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return _buildHomePage();
      case 1:
        return const Center(child: Text("Functions Page"));
      case 2:
        return const ProposalScreen();
      case 3:
        return const ProfileScreen();
      case 4:
        return const ChatScreen();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    final List<Map<String, dynamic>> services = [
      {
        "title": "Agents",
        "icon": Icons.person,
        "image": "assets/images/services/agent.jpg"
      },
      {
        "title": "Halls",
        "icon": Icons.apartment,
        "image": "assets/images/services/hall.jpg"
      },
      {
        "title": "Restaurants",
        "icon": Icons.restaurant,
        "image": "assets/images/services/restaurant.jpg"
      },
      {
        "title": "Catering",
        "icon": Icons.set_meal,
        "image": "assets/images/services/catering.jpg"
      },
      {
        "title": "Proposal",
        "icon": Icons.card_giftcard,
        "image": "assets/images/services/proposal.jpg"
      },
      {
        "title": "Function Calculator",
        "icon": Icons.calculate,
        "image": "assets/images/services/calculator.jpg"
      },
    ];

    final List<String> sliderImages =
        List.generate(10, (index) => "assets/images/slider/slide${index + 1}.jpg");

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: responsiveHeight(context, 0.25),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset("assets/images/top_banner.jpg", fit: BoxFit.cover),
                Container(color: Colors.black.withOpacity(0.3)),
                Center(
                  child: Text(
                    "Professional Event Services",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: responsiveFont(context, 6),
                      fontWeight: FontWeight.bold,
                      color: Colors.amberAccent,
                      shadows: [
                        Shadow(
                            color: Colors.black.withOpacity(0.7),
                            blurRadius: 6,
                            offset: const Offset(2, 2))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: services.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                final service = services[index];
                return _buildCard(
                    service["title"] as String,
                    service["icon"] as IconData,
                    service["image"] as String);
              },
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade800,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: PageView.builder(
              controller: _sliderController,
              itemCount: sliderImages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                        image: AssetImage(sliderImages[index]), fit: BoxFit.cover),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 3))
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, String imagePath) {
    return GestureDetector(
      onTap: () {
        if (title == "Proposal") {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ProposalScreen()));
        } else if (title == "Function Calculator") {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const FunctionCalculatorScreen()));
        } else {
          // Items ke naam
          final items = categoryData[title]!.map((e) => e["name"] as String).toList();

          // Images ko List<String> me convert kiya
          final itemImages = categoryData[title]!
              .map((itemMap) => (itemMap["images"] as List).first as String)
              .toList();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryScreen(
                title: title,
                items: items,
                itemImages: itemImages, // Correct type ab
              ),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3))
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              alignment: Alignment.center,
              color: Colors.black.withOpacity(0.25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.amberAccent, size: 32),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: responsiveFont(context, 4.5),
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(color: Colors.black.withOpacity(0.4), blurRadius: 3)
                        ]),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.deepPurpleAccent,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => setState(() => _selectedIndex = index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.event_note), label: "Functions"),
        BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: "Proposal"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_selectedIndex),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}