import 'package:flutter/material.dart';
import 'dart:ui';

class FunctionCalculatorScreen extends StatefulWidget {
  const FunctionCalculatorScreen({super.key}); // ✅ const constructor added

  @override
  State<FunctionCalculatorScreen> createState() => _FunctionCalculatorScreenState();
}

class _FunctionCalculatorScreenState extends State<FunctionCalculatorScreen> {
  int children = 0;
  int adults = 0;
  int youngAdults = 0;
  int seniors = 0;

  double hallPerHead = 0;
  double hotelPerHead = 0;
  double restaurantPerHead = 0;
  double cateringPerHead = 0;

  double get hallTotal => hallPerHead * (children + adults + youngAdults + seniors);
  double get hotelTotal => hotelPerHead * (children + adults + youngAdults + seniors);
  double get restaurantTotal => restaurantPerHead * (children + adults + youngAdults + seniors);
  double get cateringTotal => cateringPerHead * (children + adults + youngAdults + seniors);
  double get grandTotal => hallTotal + hotelTotal + restaurantTotal + cateringTotal;

  Widget numberInput(String label, int value, Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove, color: Colors.amber),
              onPressed: () => setState(() { if (value > 0) onChanged(value - 1); }),
            ),
            Text('$value', style: const TextStyle(color: Colors.white, fontSize: 16)),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.amber),
              onPressed: () => setState(() => onChanged(value + 1)),
            ),
          ],
        ),
      ],
    );
  }

  Widget priceInput(String label, double value, Function(String) onChanged) {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.amber),
        filled: true,
        fillColor: Colors.black.withOpacity(0.4),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: onChanged,
    );
  }

  Widget _glassCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withOpacity(0.25),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Function Calculator"),
        backgroundColor: Colors.black87,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/background_home.jpg", fit: BoxFit.cover),
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _glassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Guest Count", style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      numberInput("Children", children, (val) => children = val),
                      numberInput("Adults", adults, (val) => adults = val),
                      numberInput("Young Adults", youngAdults, (val) => youngAdults = val),
                      numberInput("Seniors", seniors, (val) => seniors = val),
                    ],
                  ),
                ),
                _glassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Per-Head Pricing", style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      priceInput("Hall per head", hallPerHead, (val) => setState(() => hallPerHead = double.tryParse(val) ?? 0)),
                      const SizedBox(height: 8),
                      priceInput("Hotel per head", hotelPerHead, (val) => setState(() => hotelPerHead = double.tryParse(val) ?? 0)),
                      const SizedBox(height: 8),
                      priceInput("Restaurant per head", restaurantPerHead, (val) => setState(() => restaurantPerHead = double.tryParse(val) ?? 0)),
                      const SizedBox(height: 8),
                      priceInput("Catering per head", cateringPerHead, (val) => setState(() => cateringPerHead = double.tryParse(val) ?? 0)),
                    ],
                  ),
                ),
                _glassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Estimated Bill", style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text("Hall: \$${hallTotal.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 16)),
                      Text("Hotel: \$${hotelTotal.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 16)),
                      Text("Restaurant: \$${restaurantTotal.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 16)),
                      Text("Catering: \$${cateringTotal.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 16)),
                      const Divider(color: Colors.amber),
                      Text("Total: \$${grandTotal.toStringAsFixed(2)}", style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}