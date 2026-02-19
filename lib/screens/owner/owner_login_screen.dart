import 'package:flutter/material.dart';

class OwnerLoginScreen extends StatefulWidget {
  const OwnerLoginScreen({super.key});

  @override
  _OwnerLoginScreenState createState() => _OwnerLoginScreenState();
}

class _OwnerLoginScreenState extends State<OwnerLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String phone = '';
  String password = '';

  Widget glassTextField(String label, bool obscure, Function(String) onChanged) {
    return TextFormField(
      obscureText: obscure,
      keyboardType: label == 'Phone Number' ? TextInputType.phone : TextInputType.text,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.amber),
        ),
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

  void handleLogin() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Owner logged in successfully!")),
      );
      Navigator.pushReplacementNamed(context, '/ownerHome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Owner Login"),
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/login_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(color: Colors.black.withOpacity(0.4)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                color: Colors.white.withOpacity(0.9),
                elevation: 12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Icon(Icons.business, size: 80, color: Colors.amber),
                        const SizedBox(height: 12),
                        const Text(
                          'Owner Login',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 20),
                        glassTextField('Phone Number', false, (val) => phone = val),
                        const SizedBox(height: 16),
                        glassTextField('Password', true, (val) => password = val),
                        const SizedBox(height: 24),
                        glassButton("Login", handleLogin),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/ownerSignup');
                          },
                          child: const Text(
                            "Don't have an account? Sign Up",
                            style: TextStyle(
                                color: Colors.amber, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
