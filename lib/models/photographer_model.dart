import 'dart:io';

class Photographer {
  String id;
  String name;
  String phone;
  String email;
  String city;
  String experience;
  String category;
  String price;
  String description;
  List<String> services;
  List<File> images;
  double rating;

  Photographer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.city,
    required this.experience,
    required this.category,
    required this.price,
    required this.description,
    required this.services,
    required this.images,
    this.rating = 0,
  });
}