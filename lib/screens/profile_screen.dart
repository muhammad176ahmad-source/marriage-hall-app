import 'dart:ui';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double responsiveWidth(double p) => MediaQuery.of(context).size.width * p;
    double responsiveHeight(double p) => MediaQuery.of(context).size.height * p;
    double responsiveFont(double p) => MediaQuery.of(context).size.width * (p / 100);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= Top Profile Banner =================
            Container(
              width: double.infinity,
              height: responsiveHeight(0.25),
              decoration: BoxDecoration(
                image: const DecorationImage(
                    image: AssetImage("assets/images/profile_banner.jpg"),
                    fit: BoxFit.cover),
              ),
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Text(
                    "Your Profile",
                    style: TextStyle(
                      fontSize: responsiveFont(7),
                      fontWeight: FontWeight.bold,
                      color: Colors.amberAccent,
                      shadows: const [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 6,
                          offset: Offset(2, 2),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ================= Profile Card =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage("assets/images/user_avatar.jpg"),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "John Doe",
                          style: TextStyle(
                              fontSize: responsiveFont(5),
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "john.doe@example.com",
                          style: TextStyle(
                              fontSize: responsiveFont(3.5),
                              color: Colors.black54),
                        ),
                        const SizedBox(height: 16),
                        Divider(color: Colors.black26),
                        const SizedBox(height: 12),
                        _profileOption(Icons.edit, "Edit Profile", context),
                        const SizedBox(height: 12),
                        _profileOption(Icons.lock, "Change Password", context),
                        const SizedBox(height: 12),
                        _profileOption(Icons.logout, "Logout", context),
                      ],
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

  Widget _profileOption(IconData icon, String label, BuildContext context) {
    return InkWell(
      onTap: () {
        // Add your actions here
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$label tapped")));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.amber.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.amber[700]),
            const SizedBox(width: 12),
            Text(label,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}