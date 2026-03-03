import 'dart:ui';
import 'package:flutter/material.dart';

class EliteBookingTab extends StatelessWidget {
  final List<Map<String, dynamic>> bookings;
  final Function(int, String) onEditBooking;
  final Function(int) onDeleteBooking;

  const EliteBookingTab({
    super.key,
    required this.bookings,
    required this.onEditBooking,
    required this.onDeleteBooking,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff0f2027), Color(0xff203a43), Color(0xff2c5364)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: bookings.isEmpty
            ? const Center(
                child: Text(
                  "No bookings yet",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final item = bookings[index];
                  return Dismissible(
                    key: Key(item['name'] + index.toString()),
                    background: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.redAccent,
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (_) => onDeleteBooking(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(color: Colors.white.withOpacity(0.2)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "${item['city']} - ${item['date']}",
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.white70),
                                ),
                                if (item['menu'] != null && item['menu'].toString().isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      "Menu: ${item['menu']}",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.white70),
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.edit, color: Colors.white),
                                    label: const Text("Edit Date",
                                        style: TextStyle(color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurpleAccent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                    ),
                                    onPressed: () =>
                                        _editDateDialog(context, index, item['date']),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _editDateDialog(BuildContext context, int index, String currentDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(currentDate),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      onEditBooking(index, picked.toLocal().toString().split(' ')[0]);
    }
  }
}