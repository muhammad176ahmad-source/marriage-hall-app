import 'package:flutter/material.dart';

class UserSignupScreen extends StatefulWidget {
  const UserSignupScreen({super.key});

  @override
  State<UserSignupScreen> createState() => _UserSignupScreenState();
}

class _UserSignupScreenState extends State<UserSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '', phone = '', email = '', password = '';

  Widget glassTextField(String label, Function(String) onChanged,
      {bool obscure = false}) {
    return TextFormField(
      obscureText: obscure,
      keyboardType: label.contains('Phone') ? TextInputType.phone : TextInputType.text,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.amber, width: 2),
        ),
      ),
      validator: (val) => val!.isEmpty ? 'Enter $label' : null,
      onChanged: onChanged,
    );
  }

  Widget glassButton(String text, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber[600]!, Colors.amber[900]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.6), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.5),
              offset: const Offset(0, 4),
              blurRadius: 8,
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void handleSignup() {
    if (_formKey.currentState!.validate()) {
      // Local simulation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Signup"),
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset('assets/images/signup_bg.jpg', fit: BoxFit.cover),
          ),
          Container(color: Colors.black.withOpacity(0.4)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                color: Colors.white.withOpacity(0.95),
                elevation: 12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text('Create Your Account',
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                        const SizedBox(height: 20),
                        glassTextField('Full Name', (val) => name = val),
                        const SizedBox(height: 16),
                        glassTextField('Phone Number', (val) => phone = val),
                        const SizedBox(height: 16),
                        glassTextField('Email', (val) => email = val),
                        const SizedBox(height: 16),
                        glassTextField('Password', (val) => password = val, obscure: true),
                        const SizedBox(height: 24),
                        glassButton("Signup", handleSignup),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
