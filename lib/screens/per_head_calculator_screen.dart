import 'package:flutter/material.dart';

class PerHeadCalculatorScreen extends StatefulWidget {
  const PerHeadCalculatorScreen({super.key});

  @override
  State<PerHeadCalculatorScreen> createState() => _PerHeadCalculatorScreenState();
}

class _PerHeadCalculatorScreenState extends State<PerHeadCalculatorScreen> {

  final TextEditingController budgetController = TextEditingController();
  final TextEditingController guestController = TextEditingController();
  double result = 0;

  void calculate() {
    double budget = double.tryParse(budgetController.text) ?? 0;
    double guests = double.tryParse(guestController.text) ?? 1;

    setState(() {
      result = budget / guests;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Per Head Calculator"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff11998E), Color(0xff38EF7D)],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: budgetController,
                  decoration: const InputDecoration(labelText: "Total Budget"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: guestController,
                  decoration: const InputDecoration(labelText: "Total Guests"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: calculate,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Calculate"),
                ),
                const SizedBox(height: 20),
                Text(
                  "Per Head: ${result.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
