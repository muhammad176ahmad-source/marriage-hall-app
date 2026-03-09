import 'package:flutter/material.dart';

class OwnerDataProvider with ChangeNotifier {
  // Owner Info
  String name = "Muhammad Ahmad Gulzar";
  String email = "owner@email.com";
  String phone = "03001234567";

  // Uploads & Services
  int totalUploads = 42;
  int activeHalls = 5;
  int activeHotels = 3;
  int activeRestaurants = 7;
  int activeCaterings = 4;

  // Analytics
  List<int> monthlyBookings = [5, 8, 10, 6, 12, 9, 7, 11, 8, 10, 6, 9];

  // Update profile info
  void updateProfile({
    required String name,
    required String email,
    required String phone,
  }) {
    this.name = name;
    this.email = email;
    this.phone = phone;
    notifyListeners();
  }

  // Update uploads/services
  void updateServices({
    int? halls,
    int? hotels,
    int? restaurants,
    int? caterings,
    int? uploads,
  }) {
    if (halls != null) activeHalls = halls;
    if (hotels != null) activeHotels = hotels;
    if (restaurants != null) activeRestaurants = restaurants;
    if (caterings != null) activeCaterings = caterings;
    if (uploads != null) totalUploads = uploads;

    notifyListeners();
  }
}