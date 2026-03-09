import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarriageSplashScreen extends StatefulWidget {
  const MarriageSplashScreen({super.key});

  @override
  State<MarriageSplashScreen> createState() => _MarriageSplashScreenState();
}

class _MarriageSplashScreenState extends State<MarriageSplashScreen>
    with TickerProviderStateMixin {

  bool showStartButton = true;
  bool buttonTapped = false;

  late AnimationController _scaleController;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _shimmerController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );
  }

  void _onStartPressed() {
    if (buttonTapped) return;

    setState(() {
      buttonTapped = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacementNamed(context, '/welcome');
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  Widget _glassButton() {
    return GestureDetector(
      onTap: _onStartPressed,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleController, _shimmerController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 70),
                  decoration: BoxDecoration(
                    color: const Color(0xffD4AF37).withOpacity(0.85),
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(color: Colors.white.withOpacity(0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "START",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),

                ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: FractionallySizedBox(
                    widthFactor: 1.0,
                    alignment: Alignment(_shimmerAnimation.value, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.0),
                            Colors.white.withOpacity(0.4),
                            Colors.white.withOpacity(0.0),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      // ================== Updated Background ==================
      body: Stack(
        children: [

          // Background color matching the image (gradient)
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff1c1a1a), // dark gray/brownish like image
                  Color(0xff1c1a1a), // warm tone matching image
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Image slightly bigger and centered
          Center(
            child: SizedBox(
              width: size.width,
              height: size.height * 1.1, // slightly bigger height
              child: Image.asset(
                "assets/images/background.png",
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Start button at bottom
          Positioned(
            bottom: size.height * 0.08,
            left: 0,
            right: 0,
            child: Center(
              child: showStartButton ? _glassButton() : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}