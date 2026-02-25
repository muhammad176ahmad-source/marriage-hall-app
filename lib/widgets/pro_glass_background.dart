import 'dart:ui';
import 'package:flutter/material.dart';

class ProGlassBackground extends StatelessWidget {
  final Widget child;
  final String imagePath;

  const ProGlassBackground({
    super.key,
    required this.child,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(color: Colors.black.withOpacity(0.6)),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(color: Colors.black.withOpacity(0.2)),
        ),
        SafeArea(child: child),
      ],
    );
  }
}