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

// ================== HomeScreen ==================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Random _random = Random();
  final GlobalKey _proposalCardKey = GlobalKey();

  List<Map<String, dynamic>> halls = [];
  List<String> selectedDishes = [];
  String selectedCity = '';
  List<ConfettiParticle> _confetti = [];

  final List<String> functions = ['Mehndi', 'Barat', 'Walima', 'Mehfil', 'Others'];

  final PageController _sliderController = PageController();
  int _currentSlide = 0;

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

  @override
  void initState() {
    super.initState();
    halls = availableHalls; // keep old halls
  }

  // ================= Filtered Halls Based on Selection =================
  List<Map<String, dynamic>> get filteredHalls {
    return availableHalls.where((hall) {
      bool matchesCity = selectedCity.isEmpty || hall["city"] == selectedCity;
      bool matchesDishes = selectedDishes.isEmpty || selectedDishes.any((d) => hall["menu"].contains(d));
      bool isAvailable = hall["status"] == "Available";
      return matchesCity && matchesDishes && isAvailable;
    }).toList();
  }

  // ================= Category Images =================
  String getCategoryImage(String category) {
    switch (category) {
      case 'Mehndi': return 'assets/images/mehndi.jpg';
      case 'Barat': return 'assets/images/barat.jpg';
      case 'Walima': return 'assets/images/walima.jpg';
      case 'Mehfil': return 'assets/images/mehfil.jpg';
      default: return 'assets/images/others.jpg';
    }
  }

  // ================= On Function Tap =================
  Future<void> _onFunctionTap(String func, Offset tapPosition) async {
    final selectedHall = halls.firstWhere(
      (h) => h['category'] == func,
      orElse: () => {},
    );

    if (selectedHall.isEmpty) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("No Hall Available for $func"),
          content: const Text("Owner has not added any hall for this function yet."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
          ],
        ),
      );
      return;
    }

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
      builder: (_) => AlertDialog(
        title: const Text("Next Action"),
        content: const Text("View menu or book hall?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => MenuScreen(hall: selectedHall)));
            },
            child: const Text("View Menu"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => AdvancedFunctionBookingScreen(hall: selectedHall)));
            },
            child: const Text("Book Now"),
          ),
        ],
      ),
    );
  }

  // ================= Proposal Card =================
  void _showProposalDialog() {
    String functionType = 'Mehndi';
    String groomName = '';
    String inviteeName = '';
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Create Proposal Card"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: functionType,
                    items: functions.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                    onChanged: (val) => setState(() => functionType = val!),
                    decoration: const InputDecoration(labelText: "Function Type"),
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: "Groom/Bride Name"),
                    onChanged: (val) => groomName = val,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: "Invitee Name"),
                    onChanged: (val) => inviteeName = val,
                  ),
                  Row(
                    children: [
                      const Text("Select Date: "),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) setState(() => selectedDate = picked);
                        },
                        child: Text(DateFormat('dd MMM yyyy').format(selectedDate)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showGeneratedProposalCard(functionType, groomName, inviteeName, selectedDate);
                },
                child: const Text("Generate & Share"),
              )
            ],
          );
        },
      ),
    );
  }

  Future<void> _showGeneratedProposalCard(String functionType, String groomName, String inviteeName, DateTime date) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: RepaintBoundary(
          key: _proposalCardKey,
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Colors.purple, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("$functionType Proposal", style: const TextStyle(color: Colors.yellowAccent, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                CircleAvatar(radius: 50, backgroundImage: AssetImage(getCategoryImage(functionType))),
                const SizedBox(height: 12),
                Text("From: $groomName", style: const TextStyle(color: Colors.white, fontSize: 16)),
                Text("To: $inviteeName", style: const TextStyle(color: Colors.white, fontSize: 16)),
                Text("Date: ${DateFormat('dd MMM yyyy').format(date)}", style: const TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 10),
                const Text(
                  "Aap ko dil ki attha gehraiyon se dawat dete hain is function ki aap zarur ayayin.\nThank you!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.share),
                  label: const Text("Share Invitation"),
                  onPressed: () => _shareProposalCard(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _shareProposalCard() async {
    try {
      RenderRepaintBoundary boundary = _proposalCardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/proposal.png').create();
      await file.writeAsBytes(pngBytes);

      final xfile = XFile(file.path);
      await Share.shareXFiles([xfile], text: 'Invitation Card');
    } catch (e) {
      print("Error sharing proposal card: $e");
    }
  }

  // ================= Folder Card =================
  Widget _buildFolderCard(String title, List<Widget> items, {double height = 160}) {
    return _FolderCard(title: title, items: items, height: height);
  }

  // ================= Card Builders =================
  Widget _buildMenuCard(Map<String, dynamic> dish) {
    bool isSelected = selectedDishes.contains(dish["name"]);
    return GestureDetector(
      onTap: () {
        setState(() {
          if(isSelected) selectedDishes.remove(dish["name"]);
          else selectedDishes.add(dish["name"]);
        });
      },
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: Colors.yellowAccent, width: 3) : null,
          image: DecorationImage(image: AssetImage(dish["image"]), fit: BoxFit.cover),
          boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 6, offset: const Offset(2,2))],
        ),
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.black54,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(dish["name"], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ),
      ),
    );
  }

  Widget _buildCityCard(Map<String, dynamic> city) {
    bool isSelected = selectedCity == city["name"];
    return GestureDetector(
      onTap: () => setState(() => selectedCity = city["name"]),
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: Colors.yellowAccent, width: 3) : null,
          image: DecorationImage(image: AssetImage(city["image"]), fit: BoxFit.cover),
          boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 6, offset: const Offset(2,2))],
        ),
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.black54,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(city["name"], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ),
      ),
    );
  }

  Widget _buildHallCard(Map<String, dynamic> hall) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: AssetImage(hall["image"]), fit: BoxFit.cover),
        boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 6, offset: const Offset(2,2))],
      ),
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.black54,
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(hall["name"], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            Text(hall["city"], style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center),
            Text(hall["status"], style: TextStyle(color: hall["status"]=="Available"? Colors.greenAccent : Colors.redAccent, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // ================= Build UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(child: Image.asset('assets/images/home_bg.jpg', fit: BoxFit.cover)),
          Container(color: Colors.black.withOpacity(0.3)),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ===== Top Nav =====
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(icon: const Icon(Icons.menu, color: Colors.white, size: 28), onPressed: () {}),
                        Text("Event Planner", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, shadows: const [Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(2, 2))])),
                        IconButton(icon: const Icon(Icons.person, color: Colors.white, size: 28), onPressed: () {}),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ===== Functions Slider =====
                  SizedBox(
                    height: 220,
                    child: PageView.builder(
                      controller: _sliderController,
                      itemCount: functions.length,
                      onPageChanged: (index) => setState(() => _currentSlide = index),
                      itemBuilder: (context, index) {
                        String func = functions[index];
                        return GestureDetector(
                          onTapDown: (details) => _onFunctionTap(func, details.globalPosition),
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            clipBehavior: Clip.antiAlias,
                            elevation: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(getCategoryImage(func), fit: BoxFit.cover),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [Colors.black.withOpacity(0.2), Colors.black.withOpacity(0.7)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                                  ),
                                ),
                                Center(
                                  child: AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 400),
                                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.yellowAccent.shade100, fontStyle: FontStyle.italic, shadows: const [Shadow(color: Colors.black38, blurRadius: 4, offset: Offset(2, 2))]),
                                    child: Text(func, textAlign: TextAlign.center),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      functions.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentSlide == index ? 12 : 8,
                        height: _currentSlide == index ? 12 : 8,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: _currentSlide == index ? Colors.deepPurple : Colors.grey),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ===== Folder Cards for Menus, Cities, Halls =====
                  _buildFolderCard("Menus", dishes.map((d) => _buildMenuCard(d)).toList(), height: 160),
                  _buildFolderCard("Cities", cities.map((c) => _buildCityCard(c)).toList(), height: 120),
                  _buildFolderCard("Available Halls", filteredHalls.map((h) => _buildHallCard(h)).toList(), height: 180),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // ===== Floating Proposal Button =====
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: _showProposalDialog,
              label: const Text("Proposal Card"),
              icon: const Icon(Icons.card_giftcard),
              backgroundColor: Colors.purple,
              elevation: 6,
            ),
          ),

          // ===== Confetti Layer =====
          if (_confetti.isNotEmpty)
            Positioned.fill(
              child: CustomPaint(
                painter: ConfettiPainter(_confetti),
              ),
            ),
        ],
      ),
    );
  }
}

// ================= Folder Card Widget =================
class _FolderCard extends StatefulWidget {
  final String title;
  final double height;
  final List<Widget> items;

  const _FolderCard({super.key, required this.title, required this.items, this.height = 160});

  @override
  State<_FolderCard> createState() => _FolderCardState();
}

class _FolderCardState extends State<_FolderCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 6,
      child: Column(
        children: [
          ListTile(
            title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            onTap: () => setState(() => isExpanded = !isExpanded),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: SizedBox(
              height: widget.height,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: widget.items.map((w) => Container(margin: const EdgeInsets.symmetric(horizontal: 8), child: w)).toList(),
              ),
            ),
            crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
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
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (var p in particles) {
      paint.color = p.color;
      canvas.drawCircle(p.position, p.radius, paint);
      p.position = Offset(p.position.dx + p.dx, p.position.dy + p.dy);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
