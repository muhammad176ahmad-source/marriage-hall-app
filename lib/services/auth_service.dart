import 'package:flutter_secure_storage/flutter_secure_storage.dart';  // For local storage

class AuthService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();  // Using local storage

  /// Save the email securely
  Future<void> saveEmail(String email) async {
    await _storage.write(key: 'userEmail', value: email);  // Save email securely
  }

  /// Get saved email
  Future<String?> getEmail() async {
    return await _storage.read(key: 'userEmail');
  }

  /// Log out (remove saved email)
  Future<void> logout() async {
    await _storage.delete(key: 'userEmail');  // Remove email from local storage
  }
}
