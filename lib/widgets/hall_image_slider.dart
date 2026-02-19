import 'dart:io';
import 'package:flutter/material.dart';
import '../models/hall.dart';

class HallImageSlider extends StatelessWidget {
  final Hall hall;
  final List<File>? localImages;

  const HallImageSlider({super.key, required this.hall, this.localImages});

  @override
  Widget build(BuildContext context) {
    final List<Widget> images = [
      Image.asset(hall.image, fit: BoxFit.cover, width: double.infinity),
    ];

    if (localImages != null && localImages!.isNotEmpty) {
      for (var img in localImages!) {
        images.add(Image.file(img, fit: BoxFit.cover, width: double.infinity));
      }
    }

    return SizedBox(
      height: 240,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Positioned.fill(child: images[index]),
              Positioned(
                bottom: 8,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('${index + 1} / ${images.length}',
                      style: const TextStyle(color: Colors.white)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
