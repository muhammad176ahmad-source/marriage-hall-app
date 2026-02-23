import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:cross_file/cross_file.dart';

import 'advanced_function_booking_screen.dart';
import 'booking_screen.dart';
import 'booking_confirmation_screen.dart';
import 'category_screen.dart';

// ==================== Grouped Data ====================

final Map<String, List<String>> groupedDishes = {
  "Sweet": [
    "Gulab Jamun","Kheer","Gajar Ka Halwa","Ras Malai","Barfi","Jalebi","Sooji Ka Halwa","Phirni","Malai Kulfi","Seviyan",
    "Rabri","Ladoo","Mysore Pak","Besan Barfi","Chocolate Cake","Brownie","Carrot Halwa","Peda","Kulfi Falooda","Anjeer Halwa",
  ],
  "Salt": [
    "Aloo Finger","Chili Paneer","Hakka Noodles","Channa Masala","Veg Biryani","Chicken Biryani","Nihari","Pakora","Samosa","Paneer Tikka",
    "Aloo Tikki","Chana Chaat","Veg Cutlet","Corn Chaat","Stuffed Capsicum","Dhokla","Idli","Vada","Bhel Puri","Paneer Pakora",
  ],
  "BBQ": [
    "Butter Chicken","Palak Chicken","Seekh Kabab","Tandoori Chicken","BBQ Ribs","Chapli Kebab","Mutton Chops","Grilled Fish","Chicken Wings","Beef Ribs",
    "Tikka","Barbecue Prawns","Malai Tikka","Chicken Malai Boti","Reshmi Kabab","BBQ Lamb","Chicken Fry","Chicken Malai Tikka","BBQ Chicken Pizza","Mutton Biryani BBQ",
  ],
  "Drinks": [
    "Cold Drink","Fresh Juice","Mineral Water","Tea","Coffee","Lassi","Sharbat","Ayran","Mint Mojito","Lemonade","Mango Shake","Banana Shake","Fruit Punch","Iced Tea","Coconut Water","Chai Latte","Espresso","Cappuccino","Green Tea","Herbal Tea",
  ],
};

// Dish Images
final Map<String, String> dishImages = {
  "Gulab Jamun": "assets/images/dishes/gulab_jamun.jpg",
  "Kheer": "assets/images/dishes/kheer.jpg",
  "Gajar Ka Halwa": "assets/images/dishes/gajar_ka_halwa.jpg",
  "Ras Malai": "assets/images/dishes/ras_malai.jpg",
  "Barfi": "assets/images/dishes/barfi.jpg",
  "Jalebi": "assets/images/dishes/jalebi.jpg",
  "Sooji Ka Halwa": "assets/images/dishes/sooji_ka_halwa.jpg",
  "Aloo Finger": "assets/images/dishes/aloo_finger.jpg",
  "Chili Paneer": "assets/images/dishes/chili_paneer.jpg",
  "Hakka Noodles": "assets/images/dishes/hakka_noodles.jpg",
  "Channa Masala": "assets/images/dishes/channa_masala.jpg",
  "Veg Biryani": "assets/images/dishes/veg_biryani.jpg",
  "Chicken Biryani": "assets/images/dishes/chicken_biryani.jpg",
  "Nihari": "assets/images/dishes/nihari.jpg",
  "Butter Chicken": "assets/images/dishes/butter_chicken.jpg",
  "Palak Chicken": "assets/images/dishes/palak_chicken.jpg",
  "Seekh Kabab": "assets/images/dishes/seekh_kabab.jpg",
  "Tandoori Chicken": "assets/images/dishes/tandoori_chicken.jpg",
  "BBQ Ribs": "assets/images/dishes/bbq_ribs.jpg",
  "Chapli Kebab": "assets/images/dishes/chapli_kebab.jpg",
  "Cold Drink": "assets/images/dishes/cold_drink.jpg",
  "Fresh Juice": "assets/images/dishes/fresh_juice.jpg",
  "Mineral Water": "assets/images/dishes/mineral_water.jpg",
  "Tea": "assets/images/dishes/tea.jpg",
  "Coffee": "assets/images/dishes/coffee.jpg",
  "Lassi": "assets/images/dishes/lassi.jpg",
  "Sharbat": "assets/images/dishes/sharbat.jpg",
};

// Cities - 50 cities, grouped by province
final Map<String, List<String>> groupedCities = {
  "Punjab": [
    "Lahore","Faisalabad","Rawalpindi","Multan","Gujranwala","Sialkot","Sargodha","Bahawalpur","Sahiwal","Dera Ghazi Khan",
    "Jhang","Gujrat","Pakpattan","Rahim Yar Khan","Mianwali","Narowal","Fazilka","Khushab","Chiniot","Attock",
  ],
  "KPK": [
    "Peshawar","Mardan","Abbottabad","Swabi","Mansehra","Charsadda","Nowshera","Bannu","Dera Ismail Khan","Kohat",
    "Haripur","Swat","Batkhela","Malakand","Buner","Chitral","Dir","Torghar","Mingora","Karak",
  ],
  "Sindh": [
    "Karachi","Hyderabad","Sukkur","Larkana","Shaheed Benazirabad","Mirpur Khas","Nawabshah","Khairpur","Jacobabad","Dadu",
    "Badin","Tando Allahyar","Tando Muhammad Khan","Ghotki","Shikarpur","Umerkot","Sanghar","Matiari","Jamshoro","Naushahro Feroze",
  ],
  "Balochistan": [
    "Quetta","Gwadar","Turbat","Khuzdar","Zhob","Sibi","Bela","Pasni","Jaffarabad","Kalat",
    "Lasbela","Mastung","Pishin","Chagai","Kharan","Panjgur","Kohlu","Nushki","Kech","Dera Bugti",
  ],
};

// City Images (sample)
final Map<String, String> cityImages = {
  "Lahore": "assets/images/cities/lahore.jpg",
  "Karachi": "assets/images/cities/karachi.jpg",
  "Islamabad": "assets/images/cities/islamabad.jpg",
  "Faisalabad": "assets/images/cities/faisalabad.jpg",
  "Peshawar": "assets/images/cities/peshawar.jpg",
};

// Functions - 20 types
final List<String> functionsList = [
  "Mehndi","Barat","Walima","Mehfil","Engagement","Shadi","Birthday Party","Baby Shower","Corporate Event",
  "Exhibition","Workshop","Seminar","Farewell","Reception","Valima","Anniversary","Housewarming","Sangeet","Dinner Party","Cocktail Party"
];

// Function Images (sample)
final Map<String, String> functionImages = {
  "Mehndi": "assets/images/functions/mehndi.jpg",
  "Barat": "assets/images/functions/barat.jpg",
  "Walima": "assets/images/functions/walima.jpg",
};

// Available Halls
final List<Map<String, dynamic>> availableHalls = [
  {"name": "Royal Marriage Hall", "city": "Islamabad", "status": "Available", "image": "assets/images/halls/hall1.jpg", "menu": ["Aloo Finger", "Butter Chicken"]},
  {"name": "Grand Palace", "city": "Lahore", "status": "Booked", "image": "assets/images/halls/hall2.jpg", "menu": ["Channa Masala", "Gulab Jamun"]},
  {"name": "Regal Banquet", "city": "Karachi", "status": "Available", "image": "assets/images/halls/hall3.jpg", "menu": ["Palak Chicken", "Hakka Noodles"]},
  {"name": "Golden Venue", "city": "Faisalabad", "status": "Available", "image": "assets/images/halls/hall4.jpg", "menu": ["Chili Paneer", "Kheer"]},
  {"name": "Pearl Continental", "city": "Peshawar", "status": "Available", "image": "assets/images/halls/hall5.jpg", "menu": ["Chapli Kebab", "Sooji Ka Halwa"]},
];

// ==================== Home Screen ====================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<String> selectedDishes = [];
  String selectedHallName = '';

  double responsiveWidth(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.width * percentage;

  double responsiveHeight(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.height * percentage;

  double responsiveFont(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.width * (percentage / 100);

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return _buildHomePage();
      case 1:
        return const Center(child: Text("Functions Page"));
      case 2:
        return const Center(child: Text("Proposal Page"));
      case 3:
        return const Center(child: Text("Profile Page"));
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: responsiveWidth(context, 0.03)),
        child: Column(
          children: [
            SizedBox(height: responsiveHeight(context, 0.02)),
            _buildTopImageCards(),
            SizedBox(height: responsiveHeight(context, 0.05)),
            GestureDetector(
              onTap: selectedHallName.isNotEmpty && selectedDishes.isNotEmpty
                  ? _onNextPressed
                  : null,
              child: Container(
                height: responsiveHeight(context, 0.07),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: selectedHallName.isNotEmpty && selectedDishes.isNotEmpty
                      ? LinearGradient(
                          colors: [Colors.redAccent.shade700, Colors.deepOrangeAccent.shade400],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [Colors.grey.shade400, Colors.grey.shade500],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  boxShadow: selectedHallName.isNotEmpty && selectedDishes.isNotEmpty
                      ? [BoxShadow(color: Colors.redAccent.withOpacity(0.5), blurRadius: 12, offset: const Offset(0, 4))]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  "Next",
                  style: TextStyle(
                    fontSize: responsiveFont(context, 18),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            SizedBox(height: responsiveHeight(context, 0.05)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopImageCards() {
    return Column(
      children: [
        _buildImageCard("Menus", "assets/images/menu_background.jpg", () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryScreen(
                title: "Menus",
                groupedItems: groupedDishes,
                itemImages: dishImages,
              ),
            ),
          );
        }),
        _buildImageCard("Cities", "assets/images/cities_background.jpg", () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryScreen(
                title: "Cities",
                groupedItems: groupedCities,
                itemImages: cityImages,
              ),
            ),
          );
        }),
        _buildImageCard("Functions", "assets/images/functions_background.jpg", () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryScreen(
                title: "Functions",
                items: functionsList,
                itemImages: functionImages,
              ),
            ),
          );
        }),
        _buildImageCard("Available Halls", "assets/images/halls_background.jpg", () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CategoryScreen(
                title: "Available Halls",
                items: availableHalls.map((h) => h["name"].toString()).toList(),
                itemImages: {for (var hall in availableHalls) hall["name"].toString(): hall["image"].toString()},
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildImageCard(String title, String background, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: responsiveHeight(context, 0.22),
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(background, fit: BoxFit.cover, width: double.infinity),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black.withOpacity(0.3),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: responsiveFont(context, 8),
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onNextPressed() {
    final selectedHall = availableHalls.firstWhere((hall) => hall["name"] == selectedHallName);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdvancedFunctionBookingScreen(
          hall: {
            ...selectedHall,
            "location": selectedHall["city"],
            "price": 250000,
            "capacity": 500,
            "perHeadRate": 2500,
            "facilities": ["AC","Parking","Lighting","Catering","Stage Decoration"],
            "images": ["https://via.placeholder.com/600x300","https://via.placeholder.com/600x300"],
          },
          selectedDishes: selectedDishes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Marriage Halls App")),
      body: _getPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Functions"),
          BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: "Proposal"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}