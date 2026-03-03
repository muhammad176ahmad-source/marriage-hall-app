import 'package:flutter/material.dart';
import '../../models/agent_model.dart';

class RegistrationStep3 extends StatefulWidget {
  final Agent agent;
  const RegistrationStep3({super.key, required this.agent});

  @override
  State<RegistrationStep3> createState() => _RegistrationStep3State();
}

class _RegistrationStep3State extends State<RegistrationStep3> {
  final categories = ["Hall", "Hotel", "Restaurant", "Catering"];
  List<String> selectedCategories = [];
  bool agreeTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agent Registration - Step 3")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Select Your Services"),
            ...categories.map((cat) => CheckboxListTile(
                  title: Text(cat),
                  value: selectedCategories.contains(cat),
                  onChanged: (v) {
                    setState(() {
                      if (v == true) {
                        selectedCategories.add(cat);
                      } else {
                        selectedCategories.remove(cat);
                      }
                    });
                  },
                )),
            CheckboxListTile(
              title: const Text("I agree to terms & conditions"),
              value: agreeTerms,
              onChanged: (v) => setState(() => agreeTerms = v!),
            ),
            ElevatedButton(
              onPressed: () {
                if (agreeTerms && selectedCategories.isNotEmpty) {
                  widget.agent.categories = selectedCategories;
                  // Save agent locally or navigate to Dashboard
                  Navigator.pushReplacementNamed(context, '/dashboard');
                }
              },
              child: const Text("Finish Registration"),
            )
          ],
        ),
      ),
    );
  }
}