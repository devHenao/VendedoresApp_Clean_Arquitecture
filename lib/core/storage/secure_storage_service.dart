import 'package:shared_preferences/shared_preferences.dart';
class SecureStorageService {
  static const String _keyEmail = 'remembered_email';
  static const String _keyPassword = 'remembered_password';
  static const String _keyRememberMe = 'remember_me';

  // Save user credentials
  static Future<void> saveCredentials(String email, String password, bool rememberMe) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString(_keyEmail, email);
      await prefs.setString(_keyPassword, password);
    } else {
      await prefs.remove(_keyEmail);
      await prefs.remove(_keyPassword);
    }
    await prefs.setBool(_keyRememberMe, rememberMe);
  }

  // Get saved credentials
  static Future<Map<String, dynamic>> getCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(_keyRememberMe) ?? false;

    if (!rememberMe) {
      return {'rememberMe': false};
    }

    return {
      'email': prefs.getString(_keyEmail) ?? '',
      'password': prefs.getString(_keyPassword) ?? '',
      'rememberMe': rememberMe,
    };
  }

  // Clear saved credentials
  static Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyPassword);
    await prefs.setBool(_keyRememberMe, false);
  }
}
