// lib/screens/agent_signup_screen.dart
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/agent_model.dart';
import '../../data/app_data.dart';
import 'welcome_screen.dart';

class AgentSignupScreen extends StatefulWidget {
  const AgentSignupScreen({Key? key}) : super(key: key);

  @override
  State<AgentSignupScreen> createState() => _AgentSignupScreenState();
}

class _AgentSignupScreenState extends State<AgentSignupScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _idController = TextEditingController(); // updated
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  File? _profileImage;
  File? _idFront;
  File? _idBack;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _experienceController.dispose();
    _bioController.dispose();
    _dobController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source, String type) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source, imageQuality: 70);
    if (image != null) {
      setState(() {
        if (type == 'profile') _profileImage = File(image.path);
        if (type == 'idFront') _idFront = File(image.path);
        if (type == 'idBack') _idBack = File(image.path);
      });
    }
  }

  bool _validateID(String id) {
    final regex = RegExp(r'^\d{5}-\d{7}-\d{1}$'); // keeps old CNIC validation
    return regex.hasMatch(id);
  }

  void _signup() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _idController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _experienceController.text.isEmpty ||
        _bioController.text.isEmpty ||
        _dobController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _profileImage == null ||
        _idFront == null ||
        _idBack == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields and images")),
      );
      return;
    }

    if (!_validateID(_idController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid ID (xxxxx-xxxxxxx-x)")),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match!")),
      );
      return;
    }

    /// Save agent
    AppData.agents.add(
      AgentModel(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        idNumber: _idController.text, // updated
        password: _passwordController.text,
        profileImage: _profileImage,
        idFront: _idFront, // updated
        idBack: _idBack,   // updated
        experience: _experienceController.text,
        bio: _bioController.text,
        dob: _dobController.text,
        city: _cityController.text,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Agent profile submitted! Waiting for approval...")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
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
                                        "Create Agent Account",
                                        style: GoogleFonts.poppins(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 20),

                                      /// Profile Image
                                      GestureDetector(
                                        onTap: () => _pickImage(ImageSource.gallery, 'profile'),
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundImage: _profileImage != null
                                              ? FileImage(_profileImage!)
                                              : null,
                                          child: _profileImage == null
                                              ? const Icon(Icons.person_add,
                                                  size: 40, color: Colors.white70)
                                              : null,
                                          backgroundColor: Colors.white12,
                                        ),
                                      ),
                                      const SizedBox(height: 20),

                                      _buildTextField("Full Name", _nameController),
                                      const SizedBox(height: 16),
                                      _buildTextField("Email", _emailController,
                                          keyboardType: TextInputType.emailAddress),
                                      const SizedBox(height: 16),
                                      _buildTextField("Phone Number", _phoneController,
                                          keyboardType: TextInputType.phone),
                                      const SizedBox(height: 16),
                                      _buildTextField("ID Number (xxxxx-xxxxxxx-x)", _idController,
                                          keyboardType: TextInputType.number),
                                      const SizedBox(height: 16),
                                      _buildPasswordField("Password", _passwordController, true),
                                      const SizedBox(height: 16),
                                      _buildPasswordField(
                                          "Confirm Password", _confirmPasswordController, false),
                                      const SizedBox(height: 16),
                                      _buildTextField("Experience (years)", _experienceController,
                                          keyboardType: TextInputType.number),
                                      const SizedBox(height: 16),
                                      _buildTextField("Bio", _bioController, maxLines: 3),
                                      const SizedBox(height: 16),
                                      _buildTextField("Date of Birth", _dobController, hint: "DD/MM/YYYY"),
                                      const SizedBox(height: 16),
                                      _buildTextField("City", _cityController),
                                      const SizedBox(height: 16),

                                      /// ID Images
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          _imagePickerButton("ID Front", _idFront, () {
                                            _pickImage(ImageSource.gallery, 'idFront');
                                          }),
                                          _imagePickerButton("ID Back", _idBack, () {
                                            _pickImage(ImageSource.gallery, 'idBack');
                                          }),
                                        ],
                                      ),
                                      const SizedBox(height: 30),

                                      /// Submit
                                      InkWell(
                                        borderRadius: BorderRadius.circular(20),
                                        onTap: _signup,
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
                                              "SUBMIT PROFILE",
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
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1, String? hint}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint ?? label,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool isMain) {
    return TextField(
      controller: controller,
      obscureText: isMain ? _obscurePassword : _obscureConfirmPassword,
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
            (isMain ? _obscurePassword : _obscureConfirmPassword)
                ? Icons.visibility_off
                : Icons.visibility,
            color: Colors.white70,
          ),
          onPressed: () {
            setState(() {
              if (isMain) _obscurePassword = !_obscurePassword;
              else _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
      ),
    );
  }

  Widget _imagePickerButton(String label, File? image, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white30),
        ),
        child: image != null
            ? Image.file(image, fit: BoxFit.cover)
            : Center(
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }
}