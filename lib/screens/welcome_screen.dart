import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  // ===== Animations =====
  late AnimationController _buttonShineController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _burstController;

  // ===== Page Controller =====
  final PageController _pageController = PageController(viewportFraction: 0.65, initialPage: 0);
  int _currentIndex = 0;

  // ===== Chat System =====
  bool _chatVisible = false;
  final List<ChatMessage> _chatMessages = [];
  final TextEditingController _chatController = TextEditingController();
  int _unreadChat = 0;

  // ===== Top Video Card =====
  late VideoPlayerController _videoController;
  late AnimationController _topCardFadeController;
  late Animation<double> _topCardFadeAnimation;

  @override
  void initState() {
    super.initState();

    // ===== Button Animations =====
    _buttonShineController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();
    _burstController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    // ===== Top Video Card =====
    _videoController = VideoPlayerController.asset('assets/videos/dulhan_dhooli.mp4')
      ..initialize().then((_) {
        setState(() {});
        _videoController.setLooping(true);
        _videoController.play();
      });

    _topCardFadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _topCardFadeAnimation = CurvedAnimation(parent: _topCardFadeController, curve: Curves.easeInOutBack);
    _topCardFadeController.forward();
  }

  @override
  void dispose() {
    _buttonShineController.dispose();
    _fadeController.dispose();
    _burstController.dispose();
    _pageController.dispose();
    _chatController.dispose();
    _videoController.dispose();
    _topCardFadeController.dispose();
    super.dispose();
  }

  // ======== Navigation Function ========
  void navigateTo(String route) {
    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.pushNamed(context, route);
    });
  }

  // ======== Professional Button ========
  Widget professionalButton(String title, IconData icon, String route) {
    return AnimatedBuilder(
      animation: _buttonShineController,
      builder: (context, child) {
        double shine = _buttonShineController.value;
        return GestureDetector(
          onTap: () => navigateTo(route),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: 1 + shine * 0.02,
                child: Container(
                  width: 300,
                  margin: const EdgeInsets.symmetric(vertical: 14),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.white.withOpacity(0.3 + shine * 0.2), width: 2),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.06 + shine * 0.02),
                        Colors.white.withOpacity(0.02 + shine * 0.01),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.3 + shine * 0.2), blurRadius: 20, offset: const Offset(0, 6)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: Colors.white),
                      const SizedBox(width: 14),
                      Text(
                        title,
                        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ======== Horizontal Cards (Clickable with Images) ========
  Widget horizontalCard(String title, String subtitle, String imagePath, double scale, String route) {
    return GestureDetector(
      onTap: () => navigateTo(route),
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: 200,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 15, offset: const Offset(0, 5))],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(title, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(subtitle, textAlign: TextAlign.center, style: GoogleFonts.roboto(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w400)),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ======== Top Video Card Widget ========
  Widget topAnimationCard() {
    final size = MediaQuery.of(context).size;
    return FadeTransition(
      opacity: _topCardFadeAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        height: size.height * 0.28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 20, offset: Offset(0, 6))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            children: [
              _videoController.value.isInitialized
                  ? VideoPlayer(_videoController)
                  : Container(
                      color: Colors.black,
                      child: const Center(child: CircularProgressIndicator(color: Colors.orangeAccent)),
                    ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.transparent,
                      Colors.black.withOpacity(0.3)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                bottom: 16,
                child: Text(
                  "Wedding Procession",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.bold,
                      shadows: const [Shadow(color: Colors.black54, blurRadius: 6, offset: Offset(0, 2))]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ======== Top Navbar ========
  PreferredSizeWidget _topNavbar() {
    return AppBar(
      backgroundColor: Colors.black54,
      elevation: 0,
      title: Text("Ceremo", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      centerTitle: true,
      actions: [
        Stack(
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    _chatVisible = !_chatVisible;
                    _unreadChat = 0;
                  });
                },
                icon: const Icon(Icons.chat, color: Colors.white)),
            if (_unreadChat > 0)
              Positioned(
                  right: 6,
                  top: 6,
                  child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle))),
          ],
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications, color: Colors.white)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.settings, color: Colors.white)),
      ],
    );
  }

  // ======== Bottom Navbar ========
  Widget _bottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87.withOpacity(0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, -2))],
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home, "Home", 0),
          _navItem(Icons.person, "User", 1),
          _navItem(Icons.business, "Owner", 2),
          _navItem(Icons.support_agent, "Agent", 3),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.orangeAccent : Colors.white),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: isSelected ? Colors.orangeAccent : Colors.white, fontSize: 12))
        ],
      ),
    );
  }

  // ======== Chat Overlay ========
  Widget _chatOverlay() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      bottom: _chatVisible ? 0 : -400,
      left: 0,
      right: 0,
      height: 400,
      child: Material(
        color: Colors.black87.withOpacity(0.95),
        elevation: 10,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.chat, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text("Chat", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(onPressed: () => setState(() => _chatVisible = false), icon: const Icon(Icons.close, color: Colors.white))
                ],
              ),
            ),
            const Divider(color: Colors.white30),
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _chatMessages.length,
                itemBuilder: (context, index) {
                  final msg = _chatMessages[_chatMessages.length - 1 - index];
                  return Container(
                    alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      decoration: BoxDecoration(
                        color: msg.isUser ? Colors.orangeAccent : Colors.grey[800],
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(msg.message, style: const TextStyle(color: Colors.white)),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _chatController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: "Type a message...", hintStyle: TextStyle(color: Colors.white38), border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () {
                        if (_chatController.text.trim().isEmpty) return;
                        setState(() {
                          _chatMessages.add(ChatMessage(_chatController.text.trim(), true));
                          _chatMessages.add(ChatMessage("Agent reply to '${_chatController.text.trim()}'", false));
                          _chatController.clear();
                        });
                      },
                      icon: const Icon(Icons.send, color: Colors.orangeAccent))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: _topNavbar(),
      bottomNavigationBar: _bottomNavBar(),
      body: Stack(
        children: [
          // Background gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xff141E30), Color(0xff243B55)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
          ),
          // ===== Particles Removed =====
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                topAnimationCard(),
                const SizedBox(height: 10),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(seconds: 2),
                  builder: (context, val, child) {
                    return Text(
                      "Ceremo",
                      style: GoogleFonts.poppins(
                          fontSize: size.width * 0.12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(val),
                          shadows: [
                            Shadow(color: Colors.redAccent.withOpacity(val), blurRadius: 20 * val),
                            Shadow(color: Colors.orangeAccent.withOpacity(val), blurRadius: 40 * val),
                          ]),
                    );
                  },
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 180,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: 3, // Changed to 3 cards
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      double scale = 0.8;
                      if (_pageController.position.haveDimensions) {
                        scale = (_pageController.page! - index).abs() < 1
                            ? 1 - (_pageController.page! - index).abs() * 0.2
                            : 0.8;
                      }

                      final List<String> titles = ["Halls", "Photography", "Catering"];
                      final List<String> subtitles = ["Book top halls", "Professional photographers", "Delicious cuisines"];
                      final List<String> images = [
                        'assets/images/hall1.jpg',
                        'assets/images/photo1.jpg',
                        'assets/images/catering1.jpg',
                      ];
                      final List<String> routes = ['/halls', '/photography', '/catering'];

                      return horizontalCard(titles[index], subtitles[index], images[index], scale, routes[index]);
                    },
                  ),
                ),
                const SizedBox(height: 40),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      professionalButton("User Account", Icons.person, '/login'),
                      professionalButton("Owner Account", Icons.business, '/ownerLogin'),
                      professionalButton("Agent Account", Icons.support_agent, '/agentLogin'),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          _chatOverlay(),
        ],
      ),
    );
  }
}

// ======== Chat Model ========
class ChatMessage {
  final String message;
  final bool isUser;
  ChatMessage(this.message, this.isUser);
}