import 'dart:ui';
import 'package:flutter/material.dart';

// ==================== Old Data Safe ====================

final Map<String, List<String>> groupedDishes = {
  "Sweet": ["Gulab Jamun","Kheer","Gajar Ka Halwa","Ras Malai","Barfi","Jalebi"],
  "Salt": ["Aloo Finger","Chili Paneer","Hakka Noodles","Channa Masala","Veg Biryani"],
  "BBQ": ["Butter Chicken","Palak Chicken","Seekh Kabab","Tandoori Chicken"],
  "Drinks": ["Cold Drink","Fresh Juice","Mineral Water","Tea","Coffee"],
};

final Map<String, String> dishImages = {
  "Gulab Jamun": "assets/images/dishes/gulab_jamun.jpg",
  "Kheer": "assets/images/dishes/kheer.jpg",
  "Aloo Finger": "assets/images/dishes/aloo_finger.jpg",
  "Butter Chicken": "assets/images/dishes/butter_chicken.jpg",
  "Cold Drink": "assets/images/dishes/cold_drink.jpg",
};

final Map<String, List<String>> groupedCities = {
  "Punjab": ["Lahore","Faisalabad","Rawalpindi"],
  "Sindh": ["Karachi","Hyderabad","Sukkur"],
};

final Map<String, String> cityImages = {
  "Lahore": "assets/images/cities/lahore.jpg",
  "Karachi": "assets/images/cities/karachi.jpg",
};

final List<String> functionsList = ["Mehndi","Barat","Walima"];

final Map<String, String> functionImages = {
  "Mehndi": "assets/images/functions/mehndi.jpg",
  "Barat": "assets/images/functions/barat.jpg",
};

// ==================== Professional Checkbox Card ====================

class ProfessionalCheckboxCard extends StatefulWidget {
  final String title;
  final String? image;
  final bool initiallySelected;
  final ValueChanged<bool> onChanged;

  const ProfessionalCheckboxCard({
    super.key,
    required this.title,
    this.image,
    this.initiallySelected = false,
    required this.onChanged,
  });

  @override
  State<ProfessionalCheckboxCard> createState() => _ProfessionalCheckboxCardState();
}

class _ProfessionalCheckboxCardState extends State<ProfessionalCheckboxCard> {
  late bool selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initiallySelected;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => selected = !selected);
        widget.onChanged(selected);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            children: [
              if (widget.image != null)
                Positioned.fill(child: Image.asset(widget.image!, fit: BoxFit.cover)),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    color: Colors.black.withOpacity(0.35),
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            color: selected ? Colors.orangeAccent : Colors.transparent,
                          ),
                          child: Icon(selected ? Icons.check : Icons.check_box_outline_blank,
                              color: selected ? Colors.white : Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== Category Checkbox Screen ====================

class CategoryCheckboxScreen extends StatefulWidget {
  final String title;
  final List<String> items;
  final Map<String, String>? itemImages;

  const CategoryCheckboxScreen({
    super.key,
    required this.title,
    required this.items,
    this.itemImages,
  });

  @override
  State<CategoryCheckboxScreen> createState() => _CategoryCheckboxScreenState();
}

class _CategoryCheckboxScreenState extends State<CategoryCheckboxScreen> {
  final Set<String> selectedItems = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: widget.items.map((item) {
                  return ProfessionalCheckboxCard(
                    title: item,
                    image: widget.itemImages?[item],
                    initiallySelected: selectedItems.contains(item),
                    onChanged: (selected) {
                      setState(() {
                        if (selected) selectedItems.add(item);
                        else selectedItems.remove(item);
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: GestureDetector(
              onTap: selectedItems.isEmpty ? null : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingScreen(
                      title: widget.title,
                      selectedItems: selectedItems.toList(),
                    ),
                  ),
                );
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: selectedItems.isEmpty
                      ? LinearGradient(colors: [Colors.grey.shade400, Colors.grey.shade500])
                      : LinearGradient(colors: [Colors.orangeAccent, Colors.deepOrangeAccent]),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== Booking Screen ====================

class BookingScreen extends StatelessWidget {
  final String title;
  final List<String> selectedItems;

  const BookingScreen({super.key, required this.title, required this.selectedItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking: $title')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: selectedItems.map((item) => Card(
                  color: Colors.orangeAccent.withOpacity(0.2),
                  child: ListTile(
                    title: Text(item, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                )).toList(),
              ),
            ),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking Confirmed!')),
                );
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(colors: [Colors.redAccent, Colors.deepOrange]),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== Updated HomeScreen ====================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _buildCard(BuildContext context, String title, String image, VoidCallback onTap) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        margin: const EdgeInsets.symmetric(vertical: 12),
        child: Stack(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(25), child: Image.asset(image, fit: BoxFit.cover, width: width)),
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  alignment: Alignment.center,
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2)),
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              right: 12,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent.withOpacity(0.85),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: onTap,
                child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Professional Marriage App")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard(context, "Menus", "assets/images/menu_background.jpg", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CategoryCheckboxScreen(
                            title: "Menus",
                            items: groupedDishes.values.expand((e) => e).toList(),
                            itemImages: dishImages,
                          )));
            }),
            _buildCard(context, "Cities", "assets/images/cities_background.jpg", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CategoryCheckboxScreen(
                            title: "Cities",
                            items: groupedCities.values.expand((e) => e).toList(),
                            itemImages: cityImages,
                          )));
            }),
            _buildCard(context, "Functions", "assets/images/functions_background.jpg", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CategoryCheckboxScreen(
                            title: "Functions",
                            items: functionsList,
                            itemImages: functionImages,
                          )));
            }),
          ],
        ),
      ),
    );
  }
}