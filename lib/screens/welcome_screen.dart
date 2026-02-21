import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' hide CarouselController;
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _buttonShineController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<Particle> particles = [];
  Timer? _particleTimer;
  final Random random = Random();

  @override
  void initState() {
    super.initState();

    // Button shine animation
    _buttonShineController = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);

    // Fade animation for buttons
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();

    // Particle background timer
    _particleTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      final size = MediaQuery.of(context).size;
      if (particles.length < 100) {
        particles.add(Particle(
            Offset(random.nextDouble() * size.width,
                random.nextDouble() * size.height),
            1 + random.nextDouble() * 2,
            0.5 + random.nextDouble()));
      }
      for (var p in particles) p.update(size);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _buttonShineController.dispose();
    _fadeController.dispose();
    _particleTimer?.cancel();
    super.dispose();
  }

  // ================= Glass / Shining Buttons =================
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
              width: 280,
              margin: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                  color: Colors.white.withOpacity(0.4 + 0.3 * shine),
                  width: 2,
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.1 + 0.05 * shine),
                    Colors.white.withOpacity(0.05 + 0.05 * shine),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3 + 0.2 * shine),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.robotoMono(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
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
          // ================= Fullscreen Carousel Slider =================
          SizedBox(
            height: size.height,
            width: size.width,
            child: CarouselSlider(
              options: CarouselOptions(
                height: size.height,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 1.0,
                autoPlayInterval: const Duration(seconds: 3),
              ),
              items: [
                'assets/images/slide1.jpg',
                'assets/images/slide2.jpg',
                'assets/images/slide3.jpg',
              ].map((imagePath) {
                return SizedBox(
                  width: size.width,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
            ),
          ),

          // ================= Floating Particles =================
          Positioned.fill(
            child: CustomPaint(
              painter: ParticlePainter(particles),
            ),
          ),

          // ================= Top Banner Text =================
          Positioned(
            top: 80,
            left: 20,
            right: 20,
            child: Text(
              "Love, laughter, and happily ever after",
              textAlign: TextAlign.center,
              style: GoogleFonts.pacifico(
                fontSize: size.width * 0.07,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.6),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(-1, -1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),

          // ================= Bottom Buttons =================
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  glassButton(
                      "User Account", Icons.person, () => Navigator.pushNamed(context, '/login')),
                  glassButton(
                      "Owner Account", Icons.business, () => Navigator.pushNamed(context, '/ownerLogin')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= PARTICLE MODEL =================
class Particle {
  Offset position;
  double radius;
  double speed;
  Particle(this.position, this.radius, this.speed);

  void update(Size size) {
    position = Offset(position.dx, position.dy - speed);
    if (position.dy < 0) {
      position = Offset(Random().nextDouble() * size.width, size.height);
    }
  }
}

// ================= PARTICLE PAINTER =================
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.2);
    for (var p in particles) {
      canvas.drawCircle(p.position, p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}