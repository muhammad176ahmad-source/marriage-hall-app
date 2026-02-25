import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'helpers/app_settings.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/user_signup_screen.dart';
import 'screens/owner/owner_signup_screen.dart';
import 'screens/owner/owner_login_screen.dart';
import 'screens/owner/owner_home_screen.dart';
import 'screens/marriage_splash_screen.dart';
import 'screens/owner/add_hall_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppSettings(),
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
          ? ThemeData.dark()
          : ThemeData(primarySwatch: Colors.blue),

      // ✅ App starts from Splash
      initialRoute: '/splash',

      routes: {
        '/splash': (context) => const MarriageSplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/userSignup': (context) => const UserSignupScreen(),
        '/ownerSignup': (context) => const OwnerSignupScreen(),
        '/ownerLogin': (context) => const OwnerLoginScreen(),
        '/ownerHome': (context) => OwnerHomeScreen(), // no const
        '/addHall': (context) => const AddHallScreen(),
      },
    );
  }
}