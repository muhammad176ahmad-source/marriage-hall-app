// ... baki imports wahi
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' hide CarouselController;
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'dart:async';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  bool showUserOwnerButtons = true; // Show buttons immediately
  bool showBanner = false;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late AnimationController _buttonShineController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<Firework> fireworks = [];
  final Random random = Random();

  Timer? _fireworkTimer;
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _slideAnimation = Tween<Offset>(begin: const Offset(-1.5, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _slideController.forward();

    _buttonShineController = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);

    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward(); // Fade in buttons immediately

    _fireworkTimer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      final size = MediaQuery.of(context).size;
      if (fireworks.length < 20) {
        fireworks.add(Firework(random, size));
      }
      for (var f in fireworks) {
        f.update();
      }
      fireworks.removeWhere((f) => f.exploded && f.explodeRadius <= 1);
      setState(() {});
    });

    _bannerTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        showBanner = true;
      });
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _buttonShineController.dispose();
    _fadeController.dispose();
    _fireworkTimer?.cancel();
    _bannerTimer?.cancel();
    super.dispose();
  }

  Widget glassButton(String title, IconData icon, VoidCallback onTap) {
    return AnimatedBuilder(
      animation: _buttonShineController,
      builder: (context, child) {
        double shine = _buttonShineController.value;
        return GestureDetector(
          onTap: onTap,
          child: Transform.translate(
            offset: Offset(0, -2 * shine),
            child: Container(
              width: 250,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: Colors.white.withOpacity(0.4 + 0.3 * shine),
                    width: 2),
                gradient: LinearGradient(
                  colors: [
                    Colors.amber.withOpacity(0.3),
                    Colors.orange.withOpacity(0.15),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.4),
                    blurRadius: 18,
                    offset: const Offset(3, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: GoogleFonts.robotoMono(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(
        children: [
          // ================= Background =================
          SizedBox.expand(
            child: Image.asset('assets/images/background.jpg',
                fit: BoxFit.cover),
          ),
          Container(color: Colors.black.withOpacity(0.3)),

          // ================= Fireworks =================
          Positioned.fill(
            child: CustomPaint(
              painter: FireworkPainter(fireworks),
            ),
          ),

          // ================= Banner =================
          if (showBanner)
            Positioned(
              top: 60,
              left: 30,
              right: 30,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    "🎉 Happy Marriage Ceremony 🎉",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),

          // ================= Centered Content =================
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SlideTransition(
                    position: _slideAnimation,
                    child: Text(
                      "Welcome to Marriage Hall",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.pacifico(
                          fontSize: size.width * 0.08,
                          color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ================= Carousel Slider =================
                  SizedBox(
                    height: size.height * 0.28,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.85,
                        autoPlayInterval: const Duration(seconds: 3),
                      ),
                      items: [
                        'assets/images/slide1.jpg',
                        'assets/images/slide2.jpg',
                        'assets/images/slide3.jpg',
                      ].map((imagePath) {
                        return Container(
                          margin:
                              const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.6),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ================= User & Owner Buttons =================
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        glassButton("User", Icons.person,
                            () => Navigator.pushNamed(context, '/login')),
                        glassButton("Owner", Icons.business,
                            () => Navigator.pushNamed(context, '/ownerLogin')),
                      ],
                    ),
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

// ================= FIREWORK MODEL =================
class Firework {
  Offset position;
  double speed;
  double explodeHeight;
  double explodeRadius;
  Color color;
  bool exploded;
  final Random random;

  Firework(this.random, Size size)
      : position = Offset(random.nextDouble() * size.width, size.height),
        speed = 6 + random.nextDouble() * 4,
        explodeHeight = 100 + random.nextDouble() * 200,
        explodeRadius = 40 + random.nextDouble() * 40,
        exploded = false,
        color = [
          Colors.red,
          Colors.white,
          Colors.blue
        ][random.nextInt(3)].withOpacity(0.95);

  void update() {
    if (!exploded) {
      position = Offset(position.dx, position.dy - speed);
      if (position.dy <= explodeHeight) exploded = true;
    } else {
      explodeRadius *= 0.92;
    }
  }
}

// ================= FIREWORK PAINTER =================
class FireworkPainter extends CustomPainter {
  final List<Firework> fireworks;

  FireworkPainter(this.fireworks);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (var f in fireworks) {
      paint.color = f.color;

      if (!f.exploded) {
        canvas.drawCircle(f.position, 3, paint);
      } else {
        for (int i = 0; i < 16; i++) {
          double angle = (i / 16) * 2 * pi;
          double dx = f.position.dx + f.explodeRadius * cos(angle);
          double dy = f.position.dy + f.explodeRadius * sin(angle);
          canvas.drawLine(f.position, Offset(dx, dy), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
