import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {
  bool isDarkMode = false;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  bool reminderOn = false;

  void toggleReminder(bool val) {
    reminderOn = val;
    notifyListeners();
  }
}