import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  final String title;
  final Map<String, List<String>>? groupedItems; // For dishes/cities
  final List<String>? items; // For functions or flat list
  final Map<String, String>? itemImages; // item -> image path

  const CategoryScreen({
    super.key,
    required this.title,
    this.groupedItems,
    this.items,
    this.itemImages,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Set<String> selectedItems = {};

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
        title: Text(widget.title),
      ),
      body: widget.groupedItems != null
          ? _buildGroupedList(widget.groupedItems!)
          : _buildFlatList(widget.items ?? []),
      floatingActionButton: selectedItems.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pop(context, selectedItems.toList());
              },
              label: const Text("Select"),
              icon: const Icon(Icons.check),
            )
          : null,
    );
  }

  // ================= Grouped List =================
  Widget _buildGroupedList(Map<String, List<String>> groupedItems) {
    return SingleChildScrollView(
      child: Column(
        children: groupedItems.entries.map((entry) {
          final category = entry.key;
          final items = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                  child: Text(
                    category,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: responsiveHeight(context, 0.28),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (_, index) {
                      final item = items[index];
                      final imagePath =
                          widget.itemImages?[item] ?? "assets/images/placeholder.jpg";
                      final isSelected = selectedItems.contains(item);

                      return Container(
                        width: responsiveWidth(context, 0.4),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(15)),
                                  child: Image.asset(
                                    imagePath,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4),
                                child: Column(
                                  children: [
                                    Text(
                                      item,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isSelected
                                            ? Colors.green
                                            : Colors.redAccent,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (isSelected) {
                                            selectedItems.remove(item);
                                          } else {
                                            selectedItems.add(item);
                                          }
                                        });
                                      },
                                      child: Text(isSelected ? "Added" : "Add"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ================= Flat List =================
  Widget _buildFlatList(List<String> items) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: responsiveHeight(context, 0.02)),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: items.map((item) {
              final imagePath =
                  widget.itemImages?[item] ?? "assets/images/placeholder.jpg";
              final isSelected = selectedItems.contains(item);

              return SizedBox(
                width: responsiveWidth(context, 0.45),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15)),
                        child: Image.asset(
                          imagePath,
                          height: responsiveHeight(context, 0.15),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4),
                        child: Column(
                          children: [
                            Text(
                              item,
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSelected
                                    ? Colors.green
                                    : Colors.redAccent,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedItems.remove(item);
                                  } else {
                                    selectedItems.add(item);
                                  }
                                });
                              },
                              child: Text(isSelected ? "Added" : "Add"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: responsiveHeight(context, 0.05)),
        ],
      ),
    );
  }
}