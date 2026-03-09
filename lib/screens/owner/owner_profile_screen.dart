import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../helpers/app_settings.dart';
import '../../helpers/owner_data_provider.dart';

class OwnerProfileScreen extends StatefulWidget {
  const OwnerProfileScreen({super.key});

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final owner = OwnerDataProvider(); // Initialize if needed
    _nameController = TextEditingController(text: owner.name);
    _emailController = TextEditingController(text: owner.email);
    _phoneController = TextEditingController(text: owner.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveProfile(OwnerDataProvider owner) {
    if (_formKey.currentState!.validate()) {
      owner.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
    }
  }

  Widget _buildStatCard(String title, int value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: color.withOpacity(0.8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 8),
              Text("$value",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyBookingsChart(List<int> monthlyBookings) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.deepPurple.shade700,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Monthly Bookings",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  barGroups: List.generate(
                      12,
                      (index) => BarChartGroupData(x: index + 1, barRods: [
                            BarChartRodData(
                                toY: monthlyBookings[index].toDouble(),
                                color: Colors.orangeAccent)
                          ])),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          "${value.toInt()}",
                          style:
                              const TextStyle(color: Colors.white, fontSize: 10),
                        );
                      },
                    )),
                    leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                "${value.toInt()}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              );
                            })),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final owner = context.watch<OwnerDataProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Owner Profile"),
        backgroundColor: Colors.deepPurple.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Picture + Edit
            Stack(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundImage: const AssetImage("assets/images/profile.jpg"),
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: pick new image
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.deepPurple.shade700,
                          border: Border.all(color: Colors.white, width: 2)),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(Icons.edit, color: Colors.white, size: 20),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            // Editable profile form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        labelText: "Full Name", prefixIcon: Icon(Icons.person)),
                    validator: (value) =>
                        value!.isEmpty ? "Enter your name" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                        labelText: "Email", prefixIcon: Icon(Icons.email)),
                    validator: (value) =>
                        value!.isEmpty ? "Enter your email" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                        labelText: "Phone", prefixIcon: Icon(Icons.phone)),
                    validator: (value) =>
                        value!.isEmpty ? "Enter your phone" : null,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _saveProfile(owner),
                    icon: const Icon(Icons.save),
                    label: const Text("Save Profile"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple.shade700,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Owner Stats
            Row(
              children: [
                _buildStatCard(
                    "Halls", owner.activeHalls, Icons.event_seat, Colors.purpleAccent),
                const SizedBox(width: 12),
                _buildStatCard(
                    "Hotels", owner.activeHotels, Icons.hotel, Colors.blueAccent),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatCard("Restaurants", owner.activeRestaurants,
                    Icons.restaurant, Colors.orangeAccent),
                const SizedBox(width: 12),
                _buildStatCard(
                    "Caterings", owner.activeCaterings, Icons.food_bank, Colors.greenAccent),
              ],
            ),
            const SizedBox(height: 24),
            // Total uploads
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: Colors.deepPurple.shade700,
              child: ListTile(
                leading: const Icon(Icons.upload_file, color: Colors.white),
                title: const Text("Total Uploads",
                    style: TextStyle(color: Colors.white)),
                trailing: Text("${owner.totalUploads}",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
            // Monthly Bookings Graph
            _buildMonthlyBookingsChart(owner.monthlyBookings),
          ],
        ),
      ),
    );
  }
}