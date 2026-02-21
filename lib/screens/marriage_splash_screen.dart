import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MarriageSplashScreen extends StatefulWidget {
  const MarriageSplashScreen({super.key});

  @override
  State<MarriageSplashScreen> createState() => _MarriageSplashScreenState();
}

class _MarriageSplashScreenState extends State<MarriageSplashScreen> {
  late PageController _pageController;
  bool showSlider = false;
  bool showStartButton = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Show slider after 0.5s
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        showSlider = true;
      });
    });

    // Show start button after 1.5s
    Timer(const Duration(milliseconds: 1500), () {
      setState(() {
        showStartButton = true;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ================= PROFESSIONAL START BUTTON =================
  Widget startButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/welcome');
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 40),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 70),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.redAccent.shade700,
              Colors.deepOrangeAccent.shade400,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.6),
              blurRadius: 18,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.orangeAccent.withOpacity(0.3),
              blurRadius: 24,
              spreadRadius: 2,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Text(
          "START",
          textAlign: TextAlign.center,
          style: GoogleFonts.robotoMono(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.5,
            shadows: const [
              Shadow(
                color: Colors.black38,
                blurRadius: 6,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final List<Map<String, String>> slides = [
      {
        "title": "Ahmad Gulzar",
        "subtitle": "Owner / Event Planner",
        "image": "assets/images/slide1.jpg",
      },
      {
        "title": "Luxury Weddings",
        "subtitle": "We make your day unforgettable",
        "image": "assets/images/slide2.jpg",
      },
      {
        "title": "Perfect Venues",
        "subtitle": "Choose from the best locations",
        "image": "assets/images/slide3.jpg",
      },
    ];

    return Scaffold(
      body: Stack(
        children: [
          // ================= Full screen slider =================
          if (showSlider)
            PageView.builder(
              controller: _pageController,
              itemCount: slides.length,
              itemBuilder: (context, index) {
                final slide = slides[index];
                return Container(
                  width: size.width,
                  height: size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(slide['image']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        // Slide text
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              slide['title']!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.robotoMono(
                                fontSize: size.width * 0.09,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              slide['subtitle']!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.robotoMono(
                                fontSize: size.width * 0.05,
                                fontWeight: FontWeight.w500,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),

                        // ================= START BUTTON =================
                        if (showStartButton) startButton(),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
