// ================== Imports ==================
import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:cross_file/cross_file.dart';
import 'advanced_function_booking_screen.dart';
import 'menu_screen.dart';
import 'booking_screen.dart';
import 'booking_confirmation_screen.dart';

// ================== HomeScreen ==================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final Random _random = Random();

  final List<String> functions = ['Mehndi', 'Barat', 'Walima', 'Mehfil', 'Others'];
  final List<String> mainFunctions = ['Mehndi & Barat', 'Walima', 'Mehfil', 'Others'];
  int selectedFunctionIndex = 0;

  final List<Map<String, dynamic>> dishes = [
    {"name":"Aloo Finger", "image":"assets/images/dishes/aloo_finger.jpg"},
    {"name":"Chili Paneer", "image":"assets/images/dishes/chili_paneer.jpg"},
    {"name":"Hakka Noodles", "image":"assets/images/dishes/hakka_noodles.jpg"},
    {"name":"Channa Masala", "image":"assets/images/dishes/channa_masala.jpg"},
    {"name":"Butter Chicken", "image":"assets/images/dishes/butter_chicken.jpg"},
    {"name":"Palak Chicken", "image":"assets/images/dishes/palak_chicken.jpg"},
    {"name":"Gulab Jamun", "image":"assets/images/dishes/gulab_jamun.jpg"},
    {"name":"Kheer", "image":"assets/images/dishes/kheer.jpg"},
    {"name":"Gajar Ka Halwa", "image":"assets/images/dishes/gajar_ka_halwa.jpg"},
    {"name":"Cold Drink", "image":"assets/images/dishes/cold_drink.jpg"},
    {"name":"Fresh Juice", "image":"assets/images/dishes/fresh_juice.jpg"},
    {"name":"Mineral Water", "image":"assets/images/dishes/mineral_water.jpg"},
    {"name":"Tea", "image":"assets/images/dishes/tea.jpg"},
    {"name":"Coffee", "image":"assets/images/dishes/coffee.jpg"},
  ];

  final List<Map<String, dynamic>> cities = [
    {"name":"Islamabad","image":"assets/images/cities/islamabad.jpg"},
    {"name":"Lahore","image":"assets/images/cities/lahore.jpg"},
    {"name":"Karachi","image":"assets/images/cities/karachi.jpg"},
    {"name":"Faisalabad","image":"assets/images/cities/faisalabad.jpg"},
    {"name":"Rawalpindi","image":"assets/images/cities/rawalpindi.jpg"},
  ];

  final List<Map<String, dynamic>> availableHalls = [
    {"name": "Royal Marriage Hall", "city": "Islamabad", "status": "Available", "image":"assets/images/halls/hall1.jpg", "menu":["Aloo Finger","Butter Chicken"]},
    {"name": "Grand Palace", "city": "Lahore", "status": "Booked", "image":"assets/images/halls/hall2.jpg", "menu":["Channa Masala","Gulab Jamun"]},
    {"name": "Regal Banquet", "city": "Karachi", "status": "Available", "image":"assets/images/halls/hall3.jpg", "menu":["Palak Chicken","Hakka Noodles"]},
    {"name": "Golden Venue", "city": "Faisalabad", "status": "Available", "image":"assets/images/halls/hall4.jpg", "menu":["Chili Paneer","Kheer"]},
  ];

  List<String> selectedDishes = [];
  String selectedCity = '';
  String selectedHallName = '';
  List<ConfettiParticle> _confetti = [];

  String location = '';
  TimeOfDay selectedTime = TimeOfDay.now();

  List<Widget> get _pages => [
        _buildHomePage(),
        _buildFunctionsPage(),
        _buildProposalPage(),
        _buildProfilePage(),
      ];

  List<Map<String, dynamic>> get filteredHalls {
    return availableHalls.where((hall) {
      bool matchesCity = selectedCity.isEmpty || hall["city"] == selectedCity;
      bool matchesDishes = selectedDishes.isEmpty || selectedDishes.any((d) => hall["menu"].contains(d));
      bool isAvailable = hall["status"] == "Available";
      return matchesCity && matchesDishes && isAvailable;
    }).toList();
  }

  void _onFunctionTap(int index, Offset tapPosition) {
    selectedFunctionIndex = index;
    _confetti = List.generate(
      20,
      (_) => ConfettiParticle(
        position: tapPosition,
        color: Colors.primaries[_random.nextInt(Colors.primaries.length)],
        radius: 3 + _random.nextDouble() * 3,
        dx: (_random.nextDouble() - 0.5) * 4,
        dy: -2 + -_random.nextDouble() * 4,
      ),
    );
    setState(() {});
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _confetti.clear());
    });

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("${mainFunctions[index]} Booking Options"),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: availableHalls.map((hall) {
                  bool isSelected = selectedHallName == hall['name'];
                  return CheckboxListTile(
                    title: Text("${hall['name']} (${hall['city']})"),
                    subtitle: Text("Status: ${hall['status']}"),
                    value: isSelected,
                    onChanged: (val) {
                      setState(() {
                        if(val==true) selectedHallName = hall['name'];
                        else selectedHallName = '';
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(onPressed: ()=>Navigator.pop(context), child: const Text("Close")),
            ],
          );
        },
      ),
    );
  }

  // ================= Responsive Sizes =================
  double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
  double responsiveWidth(BuildContext context, double fraction) => screenWidth(context) * fraction;
  double responsiveHeight(BuildContext context, double fraction) => screenHeight(context) * fraction;
  double responsiveFont(BuildContext context, double base) => base * screenWidth(context)/360;

  // ================= Pages =================
  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: responsiveWidth(context, 0.03)),
        child: Column(
          children: [
            SizedBox(height: responsiveHeight(context, 0.02)),
            _buildFunctionMenu(),
            SizedBox(height: responsiveHeight(context, 0.02)),
            _buildFolderCard("Menus", dishes.map((d)=>_buildMenuCard(d)).toList(), selectAll: true, height: responsiveHeight(context,0.25)),
            _buildFolderCard("Cities", cities.map((c)=>_buildCityCard(c)).toList(), selectAll: true, height: responsiveHeight(context,0.2)),
            _buildFolderCard("Available Halls", filteredHalls.map((h)=>_buildHallCard(h)).toList(), height: responsiveHeight(context,0.3)),
            SizedBox(height: responsiveHeight(context, 0.02)),
            SizedBox(
              width: double.infinity,
              height: responsiveHeight(context, 0.06),
              child: ElevatedButton(
                onPressed: () {
                  if (selectedHallName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select a hall first")),
                    );
                    return;
                  }
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
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("Next Screen", style: TextStyle(fontSize: responsiveFont(context,16), color: Colors.white)),
              ),
            ),
            SizedBox(height: responsiveHeight(context,0.05)),
          ],
        ),
      ),
    );
  }

  Widget _buildFunctionsPage() => Center(child: Text("Functions Page", style: TextStyle(fontSize: responsiveFont(context,24))));
  Widget _buildProposalPage() => Center(child: Text("Proposal Page", style: TextStyle(fontSize: responsiveFont(context,24))));
  Widget _buildProfilePage() => Center(child: Text("Profile Page", style: TextStyle(fontSize: responsiveFont(context,24))));

  // ================= Proposal Dialog =================
  void _showProposalDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Send a Proposal"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Do you want to send a proposal to the selected hall?"),
              SizedBox(height: responsiveHeight(context, 0.02)),
              Text(selectedHallName.isEmpty
                  ? "No hall selected!"
                  : "Selected Hall: $selectedHallName",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if(selectedHallName.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select a hall first")),
                  );
                  return;
                }
                // Add proposal sending logic here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Proposal sent to $selectedHallName!")),
                );
              },
              child: const Text("Send"),
            ),
          ],
        );
      },
    );
  }

  // ================= Function Menu =================
  Widget _buildFunctionMenu() {
    return SizedBox(
      height: responsiveHeight(context,0.07),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: responsiveWidth(context,0.03)),
        itemCount: mainFunctions.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedFunctionIndex == index;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: responsiveWidth(context,0.015)),
            child: ElevatedButton(
              onPressed: () {
                RenderBox box = context.findRenderObject() as RenderBox;
                Offset pos = box.localToGlobal(Offset.zero);
                if (mainFunctions[index] == 'Mehndi & Barat') selectedFunctionIndex = 0;
                else selectedFunctionIndex = functions.indexOf(mainFunctions[index]);
                _onFunctionTap(selectedFunctionIndex, pos);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? Colors.purple : Colors.grey.shade400,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.symmetric(horizontal: responsiveWidth(context,0.04)),
              ),
              child: Text(mainFunctions[index], style: TextStyle(fontSize: responsiveFont(context,16))),
            ),
          );
        },
      ),
    );
  }

  // ================= Hall, Menu, City Cards =================
  Widget _buildHallCard(Map<String,dynamic> hall) {
    bool isSelected = selectedHallName == hall['name'];
    return GestureDetector(
      onTap: (){ setState(()=>selectedHallName = isSelected ? '' : hall['name']); },
      child: Container(
        width: responsiveWidth(context,0.45),
        margin: EdgeInsets.symmetric(horizontal: responsiveWidth(context,0.02), vertical: responsiveHeight(context,0.01)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isSelected ? Colors.yellowAccent : Colors.grey.shade300, width: 2),
          image: DecorationImage(image: AssetImage(hall["image"]), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            if(isSelected) Positioned(top: 8, right: 8, child: CircleAvatar(radius: 12, backgroundColor: Colors.yellowAccent, child: Icon(Icons.check, size: 16, color: Colors.black))),
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                padding: EdgeInsets.all(responsiveWidth(context,0.02)),
                color: Colors.black54,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(hall["name"], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: responsiveFont(context,14))),
                    Text(hall["city"], style: TextStyle(color: Colors.white70, fontSize: responsiveFont(context,12))),
                    Text(hall["status"], style: TextStyle(color: hall["status"]=="Available"? Colors.greenAccent : Colors.redAccent, fontWeight: FontWeight.bold, fontSize: responsiveFont(context,12))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(Map<String, dynamic> dish) {
    bool isSelected = selectedDishes.contains(dish["name"]);
    return GestureDetector(
      onTap: () => setState(()=>isSelected?selectedDishes.remove(dish["name"]):selectedDishes.add(dish["name"])),
      child: Container(
        width: responsiveWidth(context,0.3),
        margin: EdgeInsets.symmetric(horizontal: responsiveWidth(context,0.015)),
        padding: EdgeInsets.all(responsiveWidth(context,0.02)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected? Colors.green : Colors.grey.shade300, width: 2),
          color: Colors.white,
        ),
        child: Column(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(dish["image"], width: responsiveWidth(context,0.2), height: responsiveWidth(context,0.2), fit: BoxFit.cover)),
            SizedBox(height: responsiveHeight(context,0.01)),
            Text(dish["name"], textAlign: TextAlign.center, style: TextStyle(fontSize: responsiveFont(context,12))),
          ],
        ),
      ),
    );
  }

  Widget _buildCityCard(Map<String, dynamic> city) {
    bool isSelected = selectedCity == city["name"];
    return GestureDetector(
      onTap: () => setState(()=>selectedCity=city["name"]),
      child: Container(
        width: responsiveWidth(context,0.3),
        margin: EdgeInsets.symmetric(horizontal: responsiveWidth(context,0.015)),
        padding: EdgeInsets.all(responsiveWidth(context,0.02)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected? Colors.blue : Colors.grey.shade300, width: 2),
          color: Colors.white,
        ),
        child: Column(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(city["image"], width: responsiveWidth(context,0.2), height: responsiveWidth(context,0.2), fit: BoxFit.cover)),
            SizedBox(height: responsiveHeight(context,0.01)),
            Text(city["name"], textAlign: TextAlign.center, style: TextStyle(fontSize: responsiveFont(context,12))),
          ],
        ),
      ),
    );
  }

  Widget _buildFolderCard(String title, List<Widget> children, {double height = 120, bool selectAll=false}) {
    return _FolderCard(title: title, items: children, height: height, selectAll: selectAll);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          _pages[_selectedIndex],
          if(_confetti.isNotEmpty) Positioned.fill(child: CustomPaint(painter: ConfettiPainter(_confetti))),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: ()=>_showProposalDialog(),
        label: Text("Proposal Card", style: TextStyle(fontSize: responsiveFont(context,12))),
        icon: Icon(Icons.card_giftcard, size: responsiveFont(context,16)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        onTap: (index)=>setState(()=>_selectedIndex=index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: responsiveFont(context,20)), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.event, size: responsiveFont(context,20)), label: "Functions"),
          BottomNavigationBarItem(icon: Icon(Icons.card_giftcard, size: responsiveFont(context,20)), label: "Proposal"),
          BottomNavigationBarItem(icon: Icon(Icons.person, size: responsiveFont(context,20)), label: "Profile"),
        ],
      ),
    );
  }
}

// ================= Confetti =================
class ConfettiParticle {
  Offset position;
  Color color;
  double radius;
  double dx;
  double dy;
  ConfettiParticle({required this.position, required this.color, required this.radius, required this.dx, required this.dy});
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  ConfettiPainter(this.particles);
  @override
  void paint(Canvas canvas, Size size){
    final paint = Paint()..style = PaintingStyle.fill;
    for(var p in particles){
      paint.color = p.color;
      canvas.drawCircle(p.position,p.radius,paint);
      p.position = Offset(p.position.dx+p.dx,p.position.dy+p.dy);
      p.dy += 0.1;
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>true;
}

// ================= Folder Card Widget =================
class _FolderCard extends StatefulWidget {
  final String title;
  final double height;
  final List<Widget> items;
  final bool selectAll;
  final VoidCallback? onSelectAll;
  const _FolderCard({super.key, required this.title, required this.items, this.height=160, this.selectAll=false, this.onSelectAll});
  @override State<_FolderCard> createState()=>_FolderCardState();
}

class _FolderCardState extends State<_FolderCard>{
  bool isExpanded = true;
  @override
  Widget build(BuildContext context){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.03, vertical: 8),
      child: Column(
        children:[
          ListTile(
            title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width*0.045)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                if(widget.selectAll) TextButton(onPressed: widget.onSelectAll, child: Text("Select All", style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035))),
                Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
            onTap: ()=>setState(()=>isExpanded=!isExpanded),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: SizedBox(
              height: widget.height,
              child: ListView(scrollDirection: Axis.horizontal, padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.03), children: widget.items.map((w)=>Container(margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.02), child: w)).toList()),
            ),
            crossFadeState: isExpanded? CrossFadeState.showSecond: CrossFadeState.showFirst,
            duration: const Duration(milliseconds:300),
          ),
        ],
      ),
    );
  }
}
