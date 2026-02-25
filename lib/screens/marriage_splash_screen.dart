import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'owner/owner_home_screen.dart'; // ✅ Correct import

class MarriageSplashScreen extends StatefulWidget {
  const MarriageSplashScreen({super.key});

  @override
  State<MarriageSplashScreen> createState() => _MarriageSplashScreenState();
}

class _MarriageSplashScreenState extends State<MarriageSplashScreen>
    with SingleTickerProviderStateMixin {
  final String fullTitle = "Ceremo Weddings";
  String displayedTitle = "";
  int _titleIndex = 0;

  final String fullSubtitle = "Make Your Wedding Unforgettable";
  String displayedSubtitle = "";
  int _subtitleIndex = 0;

  bool showStartButton = false;

  late AnimationController _animationController;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleFade;
  late Animation<Offset> _subtitleSlide;
  late Animation<double> _subtitleFade;

  final List<FallingShape> shapes = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _animateTitleMobile();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..addListener(() {
        setState(() {});
      });

    _titleSlide =
        Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero)
            .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _subtitleSlide =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
            .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Spawn falling shapes periodically
    Timer.periodic(const Duration(milliseconds: 500), (_) {
      shapes.add(FallingShape.random(random));
      if (shapes.length > 60) shapes.removeAt(0);
      _animationController.repeat();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _animateTitleMobile() {
    Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (_titleIndex < fullTitle.length) {
        setState(() {
          displayedTitle += fullTitle[_titleIndex];
          _titleIndex++;
        });
      } else {
        timer.cancel();
        _animateSubtitleMobile();
      }
    });
  }

  void _animateSubtitleMobile() {
    Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (_subtitleIndex < fullSubtitle.length) {
        setState(() {
          displayedSubtitle += fullSubtitle[_subtitleIndex];
          _subtitleIndex++;
        });
      } else {
        timer.cancel();
        setState(() {
          showStartButton = true;
        });
      }
    });
  }

  Widget startButton() {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            // ✅ Provider-safe navigation
         Navigator.pushReplacementNamed(context, '/welcome');
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(bottom: 40),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 60),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.redAccent.shade700,
                  Colors.deepOrangeAccent.shade400,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent.withOpacity(0.6),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.orangeAccent.withOpacity(0.3),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Text(
              "START",
              textAlign: TextAlign.center,
              style: GoogleFonts.robotoMono(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
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
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          CustomPaint(
            size: Size(size.width, size.height),
            painter: ShapePainter(shapes),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white70,
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/images/your_profile_picture.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SlideTransition(
                  position: _titleSlide,
                  child: FadeTransition(
                    opacity: _titleFade,
                    child: Text(
                      displayedTitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: MediaQuery.of(context).size.width * 0.08,
                        fontWeight: FontWeight.w800,
                        color: Colors.redAccent.shade100,
                        shadows: const [
                          Shadow(
                            offset: Offset(0, 3),
                            blurRadius: 10,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SlideTransition(
                  position: _subtitleSlide,
                  child: FadeTransition(
                    opacity: _subtitleFade,
                    child: Text(
                      displayedSubtitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.robotoSlab(
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showStartButton)
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedOpacity(
                opacity: showStartButton ? 1.0 : 0.0,
                duration: const Duration(seconds: 1),
                child: startButton(),
              ),
            ),
        ],
      ),
    );
  }
}

// ================= Falling Shapes =================
class FallingShape {
  Offset position;
  double size;
  double speed;
  double rotation;
  double rotationSpeed;
  ShapeType type;
  Color color;

  FallingShape({
    required this.position,
    required this.size,
    required this.speed,
    required this.rotation,
    required this.rotationSpeed,
    required this.type,
    required this.color,
  });

  factory FallingShape.random(Random random) {
    ShapeType type = ShapeType.values[random.nextInt(ShapeType.values.length)];
    return FallingShape(
      position: Offset(random.nextDouble() * 400, -10),
      size: random.nextDouble() * 12 + 6,
      speed: random.nextDouble() * 1.2 + 0.3,
      rotation: random.nextDouble() * 2 * pi,
      rotationSpeed: (random.nextDouble() - 0.5) * 0.02,
      type: type,
      color: Colors.primaries[random.nextInt(Colors.primaries.length)]
          .withOpacity(0.7),
    );
  }

  void fall(Size screenSize) {
    position = Offset(position.dx + sin(position.dy / 20) * 2, position.dy + speed);
    rotation += rotationSpeed;
    if (position.dy > screenSize.height) {
      position = Offset(Random().nextDouble() * screenSize.width, -10);
      rotation = Random().nextDouble() * 2 * pi;
    }
  }
}

enum ShapeType { flower, heart, leaf }

class ShapePainter extends CustomPainter {
  final List<FallingShape> shapes;
  ShapePainter(this.shapes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (var shape in shapes) {
      shape.fall(size);
      paint.color = shape.color;
      canvas.save();
      canvas.translate(shape.position.dx, shape.position.dy);
      canvas.rotate(shape.rotation);

      switch (shape.type) {
        case ShapeType.flower:
          _drawFlower(canvas, paint, shape.size);
          break;
        case ShapeType.heart:
          _drawHeart(canvas, paint, shape.size);
          break;
        case ShapeType.leaf:
          _drawLeaf(canvas, paint, shape.size);
          break;
      }

      canvas.restore();
    }
  }

  void _drawFlower(Canvas canvas, Paint paint, double size) {
    for (int i = 0; i < 5; i++) {
      double angle = i * 2 * pi / 5;
      double x = cos(angle) * size;
      double y = sin(angle) * size;
      canvas.drawCircle(Offset(x, y), size / 3, paint);
    }
  }

  void _drawHeart(Canvas canvas, Paint paint, double size) {
    Path path = Path();
    path.moveTo(0, size / 4);
    path.cubicTo(size / 2, -size / 2, size * 1.5, size / 4, 0, size);
    path.cubicTo(-size * 1.5, size / 4, -size / 2, -size / 2, 0, size / 4);
    canvas.drawPath(path, paint);
  }

  void _drawLeaf(Canvas canvas, Paint paint, double size) {
    Path path = Path();
    path.moveTo(0, -size / 2);
    path.quadraticBezierTo(size / 2, 0, 0, size / 2);
    path.quadraticBezierTo(-size / 2, 0, 0, -size / 2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}