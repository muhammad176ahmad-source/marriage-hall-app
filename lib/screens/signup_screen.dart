// lib/screens/signup_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'welcome_screen.dart'; // Make sure you have this

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String phone = '';

  Widget _buildTextField(String label, Function(String) onChanged,
      {bool isPassword = false, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      obscureText: isPassword,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.amberAccent.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.amberAccent, width: 2),
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) return 'Enter $label';
        if (label == 'Confirm Password' && val != password) return 'Passwords do not match';
        if (label == 'Phone Number' && val.length < 10) return 'Enter valid phone';
        return null;
      },
      onChanged: onChanged,
    );
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      // TODO: Add real signup logic
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey.shade900, Colors.black87],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.amberAccent),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const WelcomeScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.4),
                                    Colors.black.withOpacity(0.2),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                    color: Colors.amberAccent.withOpacity(0.5),
                                    width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.person_add_alt_1,
                                        size: 80, color: Colors.amber[400]),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'User Signup',
                                      style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amberAccent,
                                          letterSpacing: 1.2,
                                          shadows: [
                                            Shadow(
                                                color: Colors.black45,
                                                offset: Offset(2, 2),
                                                blurRadius: 4)
                                          ]),
                                    ),
                                    const SizedBox(height: 20),
                                    _buildTextField('Full Name', (val) => name = val),
                                    const SizedBox(height: 16),
                                    _buildTextField('Email', (val) => email = val,
                                        keyboardType: TextInputType.emailAddress),
                                    const SizedBox(height: 16),
                                    _buildTextField('Phone Number', (val) => phone = val,
                                        keyboardType: TextInputType.phone),
                                    const SizedBox(height: 16),
                                    _buildTextField('Password', (val) => password = val,
                                        isPassword: true),
                                    const SizedBox(height: 16),
                                    _buildTextField('Confirm Password',
                                        (val) => confirmPassword = val,
                                        isPassword: true),
                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16)),
                                          backgroundColor: Colors.amber,
                                          elevation: 8,
                                          shadowColor: Colors.amberAccent,
                                        ),
                                        onPressed: _handleSignup,
                                        child: const Text(
                                          'Sign Up',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => const LoginScreen()),
                                        );
                                      },
                                      child: const Text(
                                        'Already have an account? Login',
                                        style: TextStyle(
                                          color: Colors.amberAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}