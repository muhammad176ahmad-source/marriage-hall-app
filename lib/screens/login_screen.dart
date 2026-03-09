// lib/screens/login_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'welcome_screen.dart'; // make sure you have this screen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  Widget _buildTextField(
      String label, bool isPassword, Function(String) onChanged) {
    return TextFormField(
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
            color: Colors.amberAccent, fontWeight: FontWeight.bold),
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
      validator: (val) => val == null || val.isEmpty ? 'Enter $label' : null,
      onChanged: onChanged,
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // TODO: Add real authentication here
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
          // Optional: Add a background image or gradient
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
                  const SizedBox(height: 24),
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
                                    Icon(Icons.lock_outline,
                                        size: 80, color: Colors.amber[400]),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'User Login',
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
                                    _buildTextField(
                                        'Email', false, (val) => email = val),
                                    const SizedBox(height: 16),
                                    _buildTextField(
                                        'Password', true, (val) => password = val),
                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          backgroundColor: Colors.amber,
                                          elevation: 8,
                                          shadowColor: Colors.amberAccent,
                                        ),
                                        onPressed: _handleLogin,
                                        child: const Text(
                                          'Login',
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const SignupScreen()),
                                        );
                                      },
                                      child: const Text(
                                        'Don\'t have an account? Sign Up',
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