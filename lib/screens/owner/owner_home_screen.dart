import 'package:flutter/material.dart';
import '../../models/hall.dart';
import 'add_hall_screen.dart';
import 'hall_preview_screen.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> with SingleTickerProviderStateMixin {
  final List<Hall> myHalls = [];

  // Example Menus & Dishes
  final Map<String, List<String>> menus = {
    "Wedding Menu": ["Chicken Biryani", "Mutton Karahi", "Salad", "Dessert"],
    "Birthday Menu": ["Pizza", "Burger", "Cake", "Fries"],
    "Conference Menu": ["Sandwich", "Pasta", "Juice", "Coffee"],
  };

  final Map<String, List<bool>> selectedDishes = {};

  bool hallAdded = false;

  @override
  void initState() {
    super.initState();
    // Initialize checkbox state
    for (var menu in menus.keys) {
      selectedDishes[menu] = List.filled(menus[menu]!.length, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ===== BACKGROUND WALLPAPER =====
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/images/wallpaper.jpg", // your wallpaper
              fit: BoxFit.cover,
            ),
          ),
          Container(color: Colors.black.withOpacity(0.25)), // subtle overlay

          SafeArea(
            child: Column(
              children: [
                // ===== TOP BAR =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Marriage Halls',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      // Add Hall Button
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'Add Hall',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        onPressed: () async {
                          final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const AddHallScreen()));
                          if (result != null && result is Hall) {
                            setState(() {
                              myHalls.add(result);
                              hallAdded = true;
                            });
                            Future.delayed(const Duration(seconds: 2), () {
                              setState(() => hallAdded = false);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ===== SUCCESS BANNER =====
                if (hallAdded)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.shade700,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(2, 2))
                        ],
                      ),
                      child: const Text(
                        "🎉 Your hall has been uploaded successfully!",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                const SizedBox(height: 10),

                // ===== MENUS SLIDER =====
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: menus.keys.length,
                    itemBuilder: (context, index) {
                      String menuName = menus.keys.elementAt(index);
                      List<String> dishes = menus[menuName]!;

                      return _menuCard(menuName, dishes);
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // ===== HALL LIST =====
                Expanded(
                  child: myHalls.isEmpty ? _emptyState() : _hallList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== MENU CARD WITH DISHES =====
  Widget _menuCard(String menuName, List<String> dishes) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(menuName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: dishes.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(dishes[index], style: const TextStyle(fontSize: 14)),
                  value: selectedDishes[menuName]![index],
                  onChanged: (val) {
                    setState(() {
                      selectedDishes[menuName]![index] = val ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.home_work_outlined, size: 80, color: Colors.white70),
          SizedBox(height: 16),
          Text('No halls added yet', style: TextStyle(fontSize: 18, color: Colors.white70)),
          SizedBox(height: 6),
          Text('Tap "Add Hall" to add your wedding hall',
              style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _hallList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: myHalls.length,
      itemBuilder: (context, index) {
        final hall = myHalls[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => HallPreviewScreen(hall: hall)));
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(2, 4)),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Image.asset(
                    hall.image,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.1),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    bottom: 12,
                    right: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(hall.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(hall.location,
                            style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 4),
                        Text('${hall.price} / day',
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
