// lib/screens/category_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/app_data.dart';
import '../models/item_model.dart';
import '../models/agent_model.dart';

// ================== Action Card Model =================
class ActionCardModel {
  final String title;
  final IconData icon;
  final String action;
  ActionCardModel({
    required this.title,
    required this.icon,
    required this.action,
  });
}

// ================== Agent Screen =================
class AgentListScreen extends StatelessWidget {
  const AgentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agents")),
      body: ListView.builder(
        itemCount: AppData.agents.length,
        itemBuilder: (context, index) {
          final agent = AppData.agents[index];

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.person, size: 40),
              title: Text(agent.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Email: ${agent.email}"),
                  Text("Phone: ${agent.phone}"),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text("Hire"),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ================== Category Screen =================
class CategoryScreen extends StatefulWidget {
  final String title;
  final List<dynamic>? items;
  final List<String>? itemImages; // ✅ updated parameter

  const CategoryScreen({
    super.key,
    required this.title,
    this.items,
    this.itemImages, // ✅ accept List<String> from HomeScreen
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String activeCategory = "";
  List<dynamic> displayedItems = [];
  List<dynamic> filteredItems = [];

  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  String locationFilter = "All";
  RangeValues feeRange = const RangeValues(0, 1000000);

  Set<String> selectedItemsForBooking = {};

  // ================= Responsive =================
  double w(BuildContext context, double p) => MediaQuery.of(context).size.width * p;
  double h(BuildContext context, double p) => MediaQuery.of(context).size.height * p;
  double f(BuildContext context, double p) => MediaQuery.of(context).size.width * (p / 100);

  @override
  void initState() {
    super.initState();

    // 🔹 If items passed from HomeScreen
    if (widget.items != null && widget.items!.isNotEmpty) {
      displayedItems = widget.items!;
      filteredItems = displayedItems;
    }

    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
        _applyFilters();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ================= Filters =================
  void _applyFilters() {
    filteredItems = displayedItems.where((item) {
      if (item is ItemModel) {
        final matchesSearch = item.name.toLowerCase().contains(searchQuery);
        final matchesLocation = locationFilter == "All" || item.location == locationFilter;
        final matchesFee = item.fee >= feeRange.start && item.fee <= feeRange.end;
        return matchesSearch && matchesLocation && matchesFee;
      } else if (item is AgentModel) {
        return item.name.toLowerCase().contains(searchQuery);
      }
      return false;
    }).toList();
  }

  // ================= Category Select =================
  void _selectCategory(String action) {
    setState(() {
      activeCategory = action;
      selectedItemsForBooking.clear();
      displayedItems.clear();

      if (action == "hire") {
        displayedItems = AppData.agents;
      } else if (action == "direct") {
        displayedItems = AppData.adminItems;
      } else if (action == "hall") {
        displayedItems = AppData.ownerHalls;
      }

      filteredItems = displayedItems;
      searchController.clear();
      locationFilter = "All";
      feeRange = const RangeValues(0, 1000000);
    });
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          if (selectedItemsForBooking.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.done_all),
              onPressed: _bookSelectedItems,
            )
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: h(context, 0.02)),
          _buildTopBanner(),
          SizedBox(height: h(context, 0.02)),
          _buildCategoryCards(),
          if (displayedItems.isNotEmpty && activeCategory != "hire")
            _buildFilters(),
          if (displayedItems.isNotEmpty)
            _buildSearchBar(),
          Expanded(child: _buildItemList()),
        ],
      ),
    );
  }

  // ================= Banner =================
  Widget _buildTopBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Container(
              height: h(context, 0.2),
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/glass_banner.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                height: h(context, 0.2),
                alignment: Alignment.center,
                color: Colors.black.withOpacity(0.2),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: f(context, 8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= Category Cards =================
  Widget _buildCategoryCards() {
    final cards = [
      ActionCardModel(
        title: "Hire Agent",
        icon: Icons.person_search,
        action: "hire",
      ),
      ActionCardModel(
        title: "Direct Booking",
        icon: Icons.book_online,
        action: "direct",
      ),
      ActionCardModel(
        title: "Hall",
        icon: Icons.location_city,
        action: "hall",
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: cards.map((c) {
          return _AnimatedActionCard(
            card: c,
            width: w(context, 0.28),
            height: h(context, 0.15),
            fontSize: f(context, 10),
            onTap: () => _selectCategory(c.action),
          );
        }).toList(),
      ),
    );
  }

  // ================= Filters =================
  Widget _buildFilters() {
    final locations = <String>{"All"}
      ..addAll(displayedItems
          .whereType<ItemModel>()
          .map((e) => e.location)
          .toSet());

    return ExpansionTile(
      title: const Text("Filters"),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: DropdownButtonFormField<String>(
            value: locationFilter,
            items: locations
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            onChanged: (val) {
              setState(() {
                locationFilter = val!;
                _applyFilters();
              });
            },
            decoration: const InputDecoration(labelText: "Location"),
          ),
        ),
      ],
    );
  }

  // ================= Search =================
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Search...",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ================= Item List =================
  Widget _buildItemList() {
    if (filteredItems.isEmpty) {
      return const Center(child: Text("No items found"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];

        if (item is ItemModel) {
          // ✅ show image if passed from HomeScreen
          final image = widget.itemImages != null && widget.itemImages!.length > index
              ? widget.itemImages![index]
              : null;

          return _buildProfessionalCard(item, image);
        }

        if (item is AgentModel) {
          return _buildAgentCard(item);
        }

        return const SizedBox();
      },
    );
  }

  // ================= Item Card =================
  Widget _buildProfessionalCard(ItemModel item, String? imagePath) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: imagePath != null
            ? Image.asset(imagePath, width: 50, height: 50, fit: BoxFit.cover)
            : const Icon(Icons.work),
        title: Text(item.name),
        subtitle: Text(item.location),
        trailing: ElevatedButton(
          onPressed: () => _bookItem(item),
          child: const Text("Book"),
        ),
      ),
    );
  }

  // ================= Agent Card =================
  Widget _buildAgentCard(AgentModel agent) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text(agent.name),
        subtitle: Text(agent.email),
        trailing: ElevatedButton(
          onPressed: () {},
          child: const Text("Hire"),
        ),
      ),
    );
  }

  // ================= Booking =================
  void _bookItem(ItemModel item) {
    AppData.bookingRequests.add({
      "item": item,
      "time": DateTime.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${item.name} booked")),
    );
  }

  void _bookSelectedItems() {}
}

// ================= Animated Card =================
class _AnimatedActionCard extends StatefulWidget {
  final ActionCardModel card;
  final double width;
  final double height;
  final double fontSize;
  final VoidCallback onTap;

  const _AnimatedActionCard({
    required this.card,
    required this.width,
    required this.height,
    required this.fontSize,
    required this.onTap,
  });

  @override
  State<_AnimatedActionCard> createState() => _AnimatedActionCardState();
}

class _AnimatedActionCardState extends State<_AnimatedActionCard> {
  double scale = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => scale = 0.95),
      onTapUp: (_) {
        setState(() => scale = 1);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 100),
        child: Column(
          children: [
            Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                widget.card.icon,
                color: Colors.white,
                size: widget.fontSize,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.card.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}