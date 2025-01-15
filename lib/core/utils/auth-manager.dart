import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static const String loginKey = 'isLoggedIn';

  // Save login state
  Future<void> saveLoginState(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(loginKey, isLoggedIn);
  }

  // Retrieve login state
  Future<bool> getLoginState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(loginKey) ??
        false; // Default to false if no value exists
  }

  // Clear login state
  Future<void> clearLoginState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(loginKey);
  }
}
