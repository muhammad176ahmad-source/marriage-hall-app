// lib/screens/agent/agent_login_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'agent_signup_screen.dart';
import '../../models/agent_model.dart';
import '../../data/app_data.dart';
import 'welcome_screen.dart';

class AgentLoginScreen extends StatefulWidget {
  const AgentLoginScreen({Key? key}) : super(key: key);

  @override
  State<AgentLoginScreen> createState() => _AgentLoginScreenState();
}

class _AgentLoginScreenState extends State<AgentLoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _idController = TextEditingController(); // updated from CNIC
  final TextEditingController _passwordController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 900));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
            .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_passwordController.text.isEmpty ||
        (_emailController.text.isEmpty &&
            _phoneController.text.isEmpty &&
            _idController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill email/phone/ID and password")),
      );
      return;
    }

    // Updated to match your AgentModel fields
    final existingAgent = AppData.agents.firstWhere(
      (agent) =>
          (agent.email == _emailController.text ||
              agent.phone == _phoneController.text ||
              agent.idNumber == _idController.text), // updated
      orElse: () => AgentModel.empty(), // make sure AgentModel has .empty() constructor
    );

    if (existingAgent.idNumber.isEmpty) { // updated check
      // First-time login → show profile submission
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AgentSignupScreen()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("First login detected. Please submit your profile.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Agent login successful!")),
      );
      // Normally navigate to agent home or dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff141E30), Color(0xff243B55)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white70),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: SingleChildScrollView(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Agent Portal Login",
                                        style: GoogleFonts.poppins(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 25),

                                      _buildTextField("Email", _emailController,
                                          icon: Icons.email),
                                      const SizedBox(height: 16),
                                      _buildTextField("Phone Number", _phoneController,
                                          icon: Icons.phone),
                                      const SizedBox(height: 16),
                                      _buildTextField(
                                          "ID Number (xxxxx-xxxxxxx-x)", _idController,
                                          icon: Icons.credit_card), // updated
                                      const SizedBox(height: 16),
                                      _buildPasswordField(
                                          "Password", _passwordController),
                                      const SizedBox(height: 30),

                                      InkWell(
                                        borderRadius: BorderRadius.circular(20),
                                        onTap: _login,
                                        child: Ink(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(vertical: 18),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [Color(0xfffc466b), Color(0xff3f5efb)],
                                            ),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "LOGIN",
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 20),

                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => const AgentSignupScreen()),
                                          );
                                        },
                                        child: Text(
                                          "Create new agent account",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white70,
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {IconData? icon}) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: Colors.white12,
        prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: _obscurePassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.white70,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
    );
  }
}