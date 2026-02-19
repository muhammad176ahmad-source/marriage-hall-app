import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

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
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
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
      validator: (val) => val == null || val.isEmpty ? 'Enter $label' : null,
      onChanged: onChanged,
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // ✅ Yahan future me Firebase auth laga sakte ho
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context); // ✅ Sirf previous screen par jayega
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Login'),
          backgroundColor: Colors.black87,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.amber),
            onPressed: () {
              Navigator.pop(context); // ✅ FIXED
            },
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
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 12,
                    color: Colors.white.withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 10),
                            Icon(Icons.lock_outline,
                                size: 80, color: Colors.amber[700]),
                            const SizedBox(height: 12),
                            const Text(
                              'User Login',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                letterSpacing: 1.2,
                              ),
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
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: _handleLogin,
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.amber[600]!,
                                        Colors.amber[900]!,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.amber.withOpacity(0.5),
                                        offset: const Offset(0, 4),
                                        blurRadius: 8,
                                      )
                                    ],
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16),
                                  child: const Center(
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87),
                                    ),
                                  ),
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
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
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
    );
  }
}
