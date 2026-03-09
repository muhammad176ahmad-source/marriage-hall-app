// lib/screens/services_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'category_screen.dart';

// ==================== Data (Old Code Safe) ====================
// Dishes
final Map<String, List<String>> groupedDishes = {
  "Sweet": ["Gulab Jamun","Kheer","Gajar Ka Halwa","Ras Malai"],
  "Salt": ["Aloo Finger","Chili Paneer","Hakka Noodles","Channa Masala"],
  "BBQ": ["Butter Chicken","Palak Chicken","Seekh Kabab","Tandoori Chicken"],
  "Drinks": ["Cold Drink","Fresh Juice","Mineral Water","Tea"],
};
final Map<String, String> dishImages = {
  "Gulab Jamun":"assets/images/dishes/gulab_jamun.jpg",
  "Kheer":"assets/images/dishes/kheer.jpg",
  "Aloo Finger":"assets/images/dishes/aloo_finger.jpg",
  "Butter Chicken":"assets/images/dishes/butter_chicken.jpg",
  "Cold Drink":"assets/images/dishes/cold_drink.jpg",
};

// Cities
final Map<String, List<String>> groupedCities = {
  "Punjab":["Lahore","Faisalabad","Rawalpindi"],
  "KPK":["Peshawar","Mardan","Abbottabad"],
};
final Map<String, String> cityImages = {
  "Lahore":"assets/images/cities/lahore.jpg",
  "Karachi":"assets/images/cities/karachi.jpg",
  "Peshawar":"assets/images/cities/peshawar.jpg",
};

// Functions
final List<String> functionsList = [
  "Mehndi","Barat","Walima","Mehfil"
];
final Map<String, String> functionImages = {
  "Mehndi":"assets/images/functions/mehndi.jpg",
  "Barat":"assets/images/functions/barat.jpg",
  "Walima":"assets/images/functions/walima.jpg",
};

// Halls
final List<Map<String,dynamic>> availableHalls = [
  {"name":"Royal Hall","city":"Islamabad","image":"assets/images/halls/hall1.jpg"},
  {"name":"Grand Palace","city":"Lahore","image":"assets/images/halls/hall2.jpg"},
];
final Map<String,String> hallImages = {
  "Royal Hall":"assets/images/halls/hall1.jpg",
  "Grand Palace":"assets/images/halls/hall2.jpg",
};

// ==================== Services Screen ====================
class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int _selectedIndex = 0;

  double responsiveWidth(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.width * percentage;

  double responsiveHeight(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.height * percentage;

  double responsiveFont(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.width * (percentage / 100);

  Widget _getPage(int index){
    switch(index){
      case 0: return _buildServicesHome();
      case 1: return const Center(child: Text("Profile Page"));
      default: return _buildServicesHome();
    }
  }

  // ==================== Services Home ====================
  Widget _buildServicesHome(){
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: responsiveHeight(context,0.02)),
          _buildVideoCard(),
          SizedBox(height: responsiveHeight(context,0.02)),
          _buildServiceCard("Restaurants Booking", Icons.restaurant, () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => CategoryScreen(
                title: "Menus",
                groupedItems: groupedDishes,
                itemImages: dishImages,
              )
            ));
          }),
          _buildServiceCard("Catering Booking", Icons.local_dining, () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => CategoryScreen(
                title: "Functions",
                items: functionsList,
                itemImages: functionImages,
              )
            ));
          }),
          _buildServiceCard("Hall Booking", Icons.event, () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => CategoryScreen(
                title: "Available Halls",
                items: availableHalls.map((h)=>h["name"].toString()).toList(),
                itemImages: hallImages,
              )
            ));
          }),
          _buildServiceCard("Hotel Booking", Icons.hotel, () {
            // Add hotel booking logic here
          }),
          SizedBox(height: responsiveHeight(context,0.05)),
        ],
      ),
    );
  }

  Widget _buildVideoCard(){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: responsiveHeight(context,0.25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage("assets/images/video_placeholder.jpg"),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0,4))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            alignment: Alignment.center,
            color: Colors.black.withOpacity(0.3),
            child: const Icon(Icons.play_circle_fill, size: 60, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(String title, IconData icon, VoidCallback onTap){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        height: responsiveHeight(context,0.12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors:[Colors.purple.shade400,Colors.deepPurple.shade700]),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: const Offset(0,4))]
        ),
        child: Stack(
          children: [
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: Icon(icon, size: 50, color: Colors.white),
            ),
            Positioned(
              left: 80,
              top: 0,
              bottom: 0,
              child: Center(
                child: Text(title, style: TextStyle(
                  color: Colors.white,
                  fontSize: responsiveFont(context,5),
                  fontWeight: FontWeight.bold
                )),
              ),
            ),
            // Glass Button Overlay
            Positioned(
              right: 16,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5)
                ),
                child: const Text("Open", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Services")),
      body: _getPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(()=>_selectedIndex=index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}