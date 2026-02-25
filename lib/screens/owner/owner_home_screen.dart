import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helpers/app_settings.dart';
import 'final_list_screen.dart';
import 'add_hall_screen.dart';
import 'add_restaurant_screen.dart';
import 'add_catering_screen.dart';
import 'add_hotel_screen.dart';

// ⬇️ Missing screens imports added
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

  final List<String> sliderImages = List.generate(
      12, (index) => "assets/images/slider_${(index % 6) + 1}.jpg");

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
    _mockMessageTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) {
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
    return Consumer<AppSettings>(
      builder: (context, settings, child) {
        return Scaffold(
          drawer: _buildDrawer(settings),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListView(
                          children: [
                            _cardWithButton(
                                "Add Hall",
                                "assets/images/new_hall.jpg",
                                Colors.purpleAccent.shade100,
                                () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const AddHallScreen()),
                              );
                            }),
                            const SizedBox(height: 16),
                            _cardWithButton(
                                "Add Restaurant",
                                "assets/images/new_restaurant.jpg",
                                Colors.orangeAccent.shade100, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const AddRestaurantScreen()),
                              );
                            }),
                            const SizedBox(height: 16),
                            _cardWithButton(
                                "Add Catering",
                                "assets/images/new_catering.jpg",
                                Colors.greenAccent.shade100, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const AddCateringScreen()),
                              );
                            }),
                            const SizedBox(height: 16),
                            _cardWithButton(
                                "Add Hotel",
                                "assets/images/new_hotel.jpg",
                                Colors.blueAccent.shade100, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const AddHotelScreen()),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Live Chat / Calls",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple.shade50),
                            ),
                          ),
                          const Divider(color: Colors.white70),
                          Expanded(
                            child: ListView.builder(
                              controller: _chatScrollController,
                              itemCount: chatMessages.length,
                              itemBuilder: (context, index) {
                                bool isUser = chatMessages[index].startsWith("You:");
                                return Container(
                                  alignment: isUser
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 12),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isUser
                                        ? Colors.deepPurpleAccent.withOpacity(0.6)
                                        : Colors.deepPurple.shade400
                                            .withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    chatMessages[index],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _chatInputController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: "Type message...",
                                      hintStyle: TextStyle(color: Colors.white70),
                                      filled: true,
                                      fillColor: Colors.black.withOpacity(0.2),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16),
                                          borderSide: BorderSide.none),
                                    ),
                                    onSubmitted: _sendChat,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.send, color: Colors.white),
                                  onPressed: () =>
                                      _sendChat(_chatInputController.text),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
        _glassButton(title, buttonColor, onTap),
      ],
    );
  }

  Widget _glassButton(String text, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color.withOpacity(0.4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Center(
            child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }

  Widget _buildDrawer(AppSettings settings) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple.shade700),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage("assets/images/profile.jpg"),
            ),
            accountName: const Text("Muhammad Ahmad gulzar"),
            accountEmail: const Text("owner@email.com"),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Full Profile (A-Z Data)"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OwnerProfileScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Notifications"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationsScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text("My Uploads"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FinalListScreen()),
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
            leading: const Icon(Icons.feedback),
            title: const Text("Feedback"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FeedbackScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.contact_support),
            title: const Text("Contact Admin"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ContactAdminScreen()),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Logged Out Successfully")));
            },
          ),
        ],
      ),
    );
  }
}