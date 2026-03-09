import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ==================== Helpers & Settings ====================
import 'helpers/app_settings.dart';
import 'helpers/owner_data_provider.dart'; // NEW provider

// ==================== Screens ====================
import 'screens/welcome_screen.dart' as welcome;
import 'screens/login_screen.dart';
import 'screens/user_signup_screen.dart';
import 'screens/owner/owner_signup_screen.dart';
import 'screens/owner/owner_login_screen.dart';
import 'screens/owner/owner_home_screen.dart';
import 'screens/marriage_splash_screen.dart';
import 'screens/owner/add_hall_screen.dart';
import 'screens/agent/agent_login_screen.dart';
import 'screens/agent/agent_home_screen.dart';

// ==================== Professional Screens ====================
import 'screens/home_screen.dart' as professional_home;
import 'screens/category_screen.dart' as professional_category;
import 'screens/chat_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/owner/owner_profile_screen.dart'; // advanced profile

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppSettings()),
        ChangeNotifierProvider(create: (_) => OwnerDataProvider()), // NEW provider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettings>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Marriage Hall Booking',
      theme: settings.isDarkMode
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData(
              primarySwatch: Colors.deepPurple,
              useMaterial3: true,
            ),

      // ✅ Start from Splash Screen
      initialRoute: '/splash',

      routes: {
        '/splash': (context) => const MarriageSplashScreen(),
        '/welcome': (context) => welcome.WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/userSignup': (context) => const UserSignupScreen(),
        '/ownerSignup': (context) => const OwnerSignupScreen(),
        '/ownerLogin': (context) => const OwnerLoginScreen(),
        '/ownerHome': (context) => const OwnerHomeScreen(),
        '/addHall': (context) => const AddHallScreen(),
        '/agentLogin': (context) => const AgentLoginScreen(),
        '/agentHome': (context) => const AgentHomeScreen(),

        // ================== Professional Home & Categories ==================
        '/home': (context) => const professional_home.HomeScreen(),
        '/category': (context) =>
            professional_category.CategoryScreen(title: "Category"),

        // ================== Chat & Profile ==================
        '/chat': (context) => const ChatScreen(),
        '/profile': (context) => const ProfileScreen(),

        // ================== Owner Advanced Profile ==================
        '/ownerProfile': (context) => const OwnerProfileScreen(),
      },
    );
  }
}