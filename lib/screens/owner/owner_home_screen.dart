import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../helpers/app_settings.dart';
import '../../helpers/owner_data_provider.dart';
import 'final_list_screen.dart';
import 'add_hall_screen.dart';
import 'add_restaurant_screen.dart';
import 'add_catering_screen.dart';
import 'add_hotel_screen.dart';
import 'owner_profile_screen.dart';
import 'notifications_screen.dart';
import 'feedback_screen.dart';
import 'contact_admin_screen.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  final PageController _sliderController = PageController();
  Timer? _sliderTimer;

  final List<String> sliderImages =
      List.generate(12, (index) => "assets/images/slider_${(index % 6) + 1}.jpg");

  final ScrollController _chatScrollController = ScrollController();
  final List<String> chatMessages = [];
  final TextEditingController _chatInputController = TextEditingController();
  Timer? _mockMessageTimer;
  final Random _random = Random();

  final List<String> mockMessages = [
    "New booking request from Ali",
    "Call from customer 03001234567",
    "Message: 'Is dinner menu available?'",
    "Customer inquiry about hall availability",
    "New booking confirmed by Sarah",
    "Call from 03101234567 regarding hotel",
    "Message: 'Delivery time for restaurant?'",
    "Customer feedback received",
  ];

  final List<int> monthlyBookings = [5, 8, 10, 6, 12, 9, 7, 11, 8, 10, 6, 9];
  bool _isChatOpen = false;

  @override
  void initState() {
    super.initState();
    _startSliderAutoScroll();
    _startMockMessages();
  }

  void _startSliderAutoScroll() {
    _sliderTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_sliderController.hasClients) {
        int nextPage = _sliderController.page!.toInt() + 1;
        if (nextPage >= sliderImages.length) nextPage = 0;
        _sliderController.animateToPage(nextPage,
            duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
      }
    });
  }

  void _startMockMessages() {
    _mockMessageTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final msg = mockMessages[_random.nextInt(mockMessages.length)];
      setState(() {
        chatMessages.add(msg);
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Timer(const Duration(milliseconds: 100), () {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendChat(String msg) {
    if (msg.trim().isEmpty) return;
    setState(() {
      chatMessages.add("You: ${msg.trim()}");
    });
    _chatInputController.clear();
    _scrollToBottom();
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _mockMessageTimer?.cancel();
    _sliderController.dispose();
    _chatScrollController.dispose();
    _chatInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final owner = context.watch<OwnerDataProvider>();

    return Consumer<AppSettings>(
      builder: (context, settings, child) {
        return Scaffold(
          drawer: _buildDashboardDrawer(settings, owner),
          appBar: AppBar(
            title: const Text("Management Panel"),
            centerTitle: true,
            backgroundColor: Colors.deepPurple.shade700,
          ),
          body: Stack(
            children: [
              SizedBox.expand(
                child: Image.asset(
                  "assets/images/new_wallpaper.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              Container(color: Colors.black.withOpacity(0.3)),
              SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: 250,
                      child: PageView.builder(
                        controller: _sliderController,
                        itemCount: sliderImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    sliderImages[index],
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withOpacity(0.5),
                                        Colors.transparent
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    )),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          _buildServiceCards(),
                          const SizedBox(height: 16),
                          _buildAnalyticsGraphs(owner),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      heroTag: "profile_btn",
                      backgroundColor: Colors.deepPurpleAccent,
                      child: const Icon(Icons.person),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const OwnerProfileScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    FloatingActionButton(
                      heroTag: "chat_btn",
                      backgroundColor: Colors.deepPurple,
                      child: const Icon(Icons.chat),
                      onPressed: () {
                        setState(() {
                          _isChatOpen = !_isChatOpen;
                        });
                      },
                    ),
                  ],
                ),
              ),
              if (_isChatOpen) _buildAdvancedChatOverlay(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceCards() {
    return Column(
      children: [
        _cardWithButton(
            "Add Hall", "assets/images/new_hall.jpg", Colors.purpleAccent.shade100,
            () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddHallScreen()));
        }),
        const SizedBox(height: 12),
        _cardWithButton(
            "Add Restaurant", "assets/images/new_restaurant.jpg",
            Colors.orangeAccent.shade100, () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddRestaurantScreen()));
        }),
        const SizedBox(height: 12),
        _cardWithButton(
            "Add Catering", "assets/images/new_catering.jpg",
            Colors.greenAccent.shade100, () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddCateringScreen()));
        }),
        const SizedBox(height: 12),
        _cardWithButton(
            "Add Hotel", "assets/images/new_hotel.jpg", Colors.blueAccent.shade100,
            () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddHotelScreen()));
        }),
      ],
    );
  }

  Widget _buildAnalyticsGraphs(OwnerDataProvider owner) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Monthly Bookings",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: BarChart(
            BarChartData(
              barGroups: List.generate(
                  owner.monthlyBookings.length,
                  (index) => BarChartGroupData(x: index + 1, barRods: [
                        BarChartRodData(
                            toY: owner.monthlyBookings[index].toDouble(),
                            color: Colors.deepPurpleAccent)
                      ])),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      "${value.toInt()}",
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    );
                  },
                )),
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            "${value.toInt()}",
                            style:
                                const TextStyle(color: Colors.white, fontSize: 10),
                          );
                        })),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardDrawer(AppSettings settings, OwnerDataProvider owner) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple.shade700),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage("assets/images/profile.jpg"),
            ),
            accountName: Text(owner.name),
            accountEmail: Text(owner.email),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildStatTile("Halls", owner.activeHalls, Icons.event_seat),
                _buildStatTile("Hotels", owner.activeHotels, Icons.hotel),
                _buildStatTile("Restaurants", owner.activeRestaurants, Icons.restaurant),
                _buildStatTile("Caterings", owner.activeCaterings, Icons.food_bank),
                _buildStatTile("Total Uploads", owner.totalUploads, Icons.upload_file),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text("Profile"),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OwnerProfileScreen()),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.upload_file),
                  title: const Text("Uploads"),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FinalListScreen()),
                  ),
                ),
                ExpansionTile(
                  leading: const Icon(Icons.settings),
                  title: const Text("Settings"),
                  children: [
                    SwitchListTile(
                      title: const Text("Dark Mode"),
                      value: settings.isDarkMode,
                      onChanged: (_) => settings.toggleTheme(),
                    ),
                    SwitchListTile(
                      title: const Text("Reminder"),
                      value: settings.reminderOn,
                      onChanged: (val) => settings.toggleReminder(val),
                    ),
                  ],
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text("Logout",
                      style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Logged Out Successfully")));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile(String title, int value, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        trailing: Text("$value"),
      ),
    );
  }

  Widget _buildAdvancedChatOverlay() {
    return Positioned(
      bottom: 80,
      right: 20,
      left: 20,
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade700.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 8)],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade900,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Live Chat",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _isChatOpen = false;
                        });
                      }),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _chatScrollController,
                itemCount: chatMessages.length,
                itemBuilder: (context, index) {
                  bool isUser = chatMessages[index].startsWith("You:");
                  return Container(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.deepPurpleAccent
                          : Colors.deepPurple.shade400,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      chatMessages[index],
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _chatInputController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Type message...",
                        hintStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: _sendChat,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () => _sendChat(_chatInputController.text),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cardWithButton(
      String title, String image, Color buttonColor, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            image,
            height: 160,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [buttonColor.withOpacity(0.7), buttonColor.withOpacity(0.4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}