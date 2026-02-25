import 'package:flutter/material.dart';

class AnimatedWrapper extends StatefulWidget {
  final Widget child;
  const AnimatedWrapper({super.key, required this.child});

  @override
  State<AnimatedWrapper> createState() => _AnimatedWrapperState();
}

class _AnimatedWrapperState extends State<AnimatedWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: controller,
      child: widget.child,
    );
  }
}