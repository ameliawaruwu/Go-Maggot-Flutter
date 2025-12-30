import 'package:shared_preferences/shared_preferences.dart';

class SessionHelper {
  static const String _tokenKey = 'auth_token'; 
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    print(" Token berhasil disimpan ke HP");
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(_tokenKey);
    return token;
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    print("Token dihapus (Logout)");
  }
}