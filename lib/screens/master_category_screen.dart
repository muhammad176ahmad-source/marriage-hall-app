import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MasterCategoryScreen extends StatefulWidget {
  final String title;

  const MasterCategoryScreen({super.key, required this.title});

  @override
  State<MasterCategoryScreen> createState() => _MasterCategoryScreenState();
}

class _MasterCategoryScreenState extends State<MasterCategoryScreen> {
  List<Map<String, dynamic>> activeItemsData = [];
  String activeTitle = "";

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  double responsiveWidth(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.width * percentage;

  double responsiveHeight(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.height * percentage;

  double responsiveFont(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.width * (percentage / 100);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(activeTitle.isEmpty ? widget.title : activeTitle),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: responsiveHeight(context, 0.02)),
            _buildTopGlassBanner(),
            SizedBox(height: responsiveHeight(context, 0.03)),
            _buildCategoryButtons(),
            SizedBox(height: responsiveHeight(context, 0.03)),
            if (activeItemsData.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        activeItemsData = [];
                        activeTitle = "";
                      });
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Back"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                  ),
                ),
              ),
            _buildFlatList(activeItemsData),
          ],
        ),
      ),
    );
  }

  Widget _buildTopGlassBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Container(
              height: responsiveHeight(context, 0.25),
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/glass_banner.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  height: responsiveHeight(context, 0.25),
                  color: Colors.black.withOpacity(0.2),
                  alignment: Alignment.center,
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsiveFont(context, 8),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
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

  Widget _buildCategoryButtons() {
    final categories = [
      {'title': 'Agents', 'collection': 'agents', 'icon': Icons.person_search},
      {'title': 'Halls', 'collection': 'halls', 'icon': Icons.location_city},
      {'title': 'Restaurants', 'collection': 'restaurants', 'icon': Icons.restaurant},
      {'title': 'Hotels', 'collection': 'hotels', 'icon': Icons.hotel},
      {'title': 'Catering', 'collection': 'catering', 'icon': Icons.fastfood},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: categories.map((cat) {
          return GestureDetector(
            onTap: () => _handleCategory(cat['title']!, cat['collection']!),
            child: Container(
              width: responsiveWidth(context, 0.28),
              height: responsiveHeight(context, 0.15),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(cat['icon'] as IconData, color: Colors.white, size: responsiveFont(context, 10)),
                  const SizedBox(height: 8),
                  Text(
                    cat['title']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _handleCategory(String title, String collection) async {
    final query = await _firestore.collection(collection).get();
    final itemsData = query.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();

    setState(() {
      activeItemsData = itemsData;
      activeTitle = title;
    });
  }

  Widget _buildFlatList(List<Map<String, dynamic>> itemsData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: itemsData.map((item) {
          return SizedBox(
            width: responsiveWidth(context, 0.45),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: InkWell(
                onTap: () => _showDetailsDialog(item),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                      child: Image.network(
                        item['image'] ?? 'https://via.placeholder.com/150',
                        height: responsiveHeight(context, 0.15),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                      child: Column(
                        children: [
                          Text(
                            item['name'] ?? "No Name",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          ElevatedButton(
                            onPressed: () => _showDetailsDialog(item),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
                            child: const Text("View Details"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showDetailsDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(item['name'] ?? "No Name"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              if (item['image'] != null)
                Image.network(item['image'], height: 150, fit: BoxFit.cover),
              const SizedBox(height: 12),
              if (item['location'] != null) Text("Location: ${item['location']}"),
              if (item['phone'] != null) Text("Phone: ${item['phone']}"),
              if (item['email'] != null) Text("Email: ${item['email']}"),
              if (item['address'] != null) Text("Address: ${item['address']}"),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.phone),
                label: const Text("Call"),
                onPressed: () async {
                  final url = Uri.parse("tel:${item['phone']}");
                  if (await canLaunchUrl(url)) await launchUrl(url);
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.chat),
                label: const Text("Chat"),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Chat clicked!")));
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text("Send Request"),
                onPressed: () async {
                  await _firestore.collection("requests").add({
                    "itemId": item['id'],
                    "type": activeTitle,
                    "status": "pending",
                    "timestamp": FieldValue.serverTimestamp(),
                  });
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("Request Sent!")));
                },
              ),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))],
      ),
    );
  }
}