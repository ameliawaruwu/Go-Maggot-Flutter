import 'package:shared_preferences/shared_preferences.dart';

class SessionHelper {
<<<<<<< HEAD
  static const String _tokenKey = 'auth_token'; 
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    print(" Token berhasil disimpan ke HP");
=======
  static const String _tokenKey = 'auth_token';
  static const String _usernameKey = 'username';
  static const String _emailKey = 'email';

  // ----------------------------------------------------------
  // 1. SIMPAN TOKEN (jika nanti pakai Sanctum / JWT)
  // ----------------------------------------------------------
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
>>>>>>> a958cfd2cc239bdca994ab247fbc9acfe161977a
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
<<<<<<< HEAD
    String? token = prefs.getString(_tokenKey);
    return token;
=======
    return prefs.getString(_tokenKey);
>>>>>>> a958cfd2cc239bdca994ab247fbc9acfe161977a
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
<<<<<<< HEAD
    print("Token dihapus (Logout)");
=======
>>>>>>> a958cfd2cc239bdca994ab247fbc9acfe161977a
  }

  // ----------------------------------------------------------
  // 2. SIMPAN DATA USER (LOGIN)
  // ----------------------------------------------------------
  static Future<void> saveUser(
    String username,
    String email,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_emailKey, email);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  // ----------------------------------------------------------
  // 3. CLEAR SEMUA SESSION (LOGOUT TOTAL)
  // ----------------------------------------------------------
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
