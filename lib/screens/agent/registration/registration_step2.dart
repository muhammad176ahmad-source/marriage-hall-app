import 'package:flutter/material.dart';
import '../../models/agent_model.dart';

class RegistrationStep2 extends StatefulWidget {
  final Agent agent;
  const RegistrationStep2({super.key, required this.agent});

  @override
  State<RegistrationStep2> createState() => _RegistrationStep2State();
}

class _RegistrationStep2State extends State<RegistrationStep2> {
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agent Registration - Step 2")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (v) => v!.length < 6 ? "At least 6 chars" : null,
              ),
              TextFormField(
                controller: confirmController,
                decoration: const InputDecoration(labelText: "Confirm Password"),
                obscureText: true,
                validator: (v) =>
                    v != passwordController.text ? "Passwords do not match" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    widget.agent.password = passwordController.text;
                    Navigator.pushNamed(context, '/registration3', arguments: widget.agent);
                  }
                },
                child: const Text("Next"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}