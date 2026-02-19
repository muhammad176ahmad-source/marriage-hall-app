import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarriageSplashScreen extends StatefulWidget {
  const MarriageSplashScreen({super.key});

  @override
  State<MarriageSplashScreen> createState() => _MarriageSplashScreenState();
}

class _MarriageSplashScreenState extends State<MarriageSplashScreen>
    with TickerProviderStateMixin {
  bool showWelcomeText = false;
  bool showName = false;
  bool showStartButton = false; // START button

  late AnimationController _nameSlideController;
  late Animation<Offset> _nameSlideAnimation;
  late AnimationController _nameFadeController;

  @override
  void initState() {
    super.initState();

    // Slide animation for name
    _nameSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _nameSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _nameSlideController, curve: Curves.easeOut));

    // Fade animation
    _nameFadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Show welcome text after 0.5s
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        showWelcomeText = true;
      });
    });

    // Show name banner after 1.5s
    Timer(const Duration(milliseconds: 1500), () {
      setState(() {
        showName = true;
      });
      _nameSlideController.forward();

      // Show START button after banner animation completes
      Timer(const Duration(milliseconds: 1500), () {
        setState(() {
          showStartButton = true;
        });
      });
    });
  }

  @override
  void dispose() {
    _nameSlideController.dispose();
    _nameFadeController.dispose();
    super.dispose();
  }

  Widget glassStartButton(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.withOpacity(0.3),
              Colors.purple.withOpacity(0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(3, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.robotoMono(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ================= Background =================
          SizedBox(
            width: size.width,
            height: size.height,
            child: Image.asset(
              'assets/images/jungle.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // ================= Light overlay =================
          Container(color: Colors.black.withOpacity(0.25)),

          // ================= Centered Content =================
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showWelcomeText)
                    Text(
                      'Welcome to Marriage Hall Booking',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.pacifico(
                        fontSize: size.width * 0.07,
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                              color: Colors.black38,
                              blurRadius: 6,
                              offset: Offset(2, 2)),
                        ],
                      ),
                    ),
                  const SizedBox(height: 40),

                  // ================= Name Slide + Fade Banner =================
                  if (showName)
                    SlideTransition(
                      position: _nameSlideAnimation,
                      child: FadeTransition(
                        opacity: Tween<double>(begin: 1, end: 0)
                            .animate(_nameFadeController),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 25),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.deepPurple.shade400.withOpacity(0.9),
                                Colors.deepPurple.shade700.withOpacity(0.95),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                                color: Colors.yellowAccent, width: 2),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 12,
                                  offset: Offset(4, 4))
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Ahmad Gulzar',
                                style: GoogleFonts.robotoMono(
                                  fontSize: size.width * 0.075,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellowAccent,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Owner / Event Planner',
                                style: GoogleFonts.robotoMono(
                                  fontSize: size.width * 0.045,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // ================= START BUTTON =================
                  if (showStartButton)
                    glassStartButton("START", () {
                      Navigator.pushReplacementNamed(context, '/welcome');
                    }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
