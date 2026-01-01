import 'package:shared_preferences/shared_preferences.dart';

class SessionHelper {
  static const String _tokenKey = 'auth_token';
  static const String _usernameKey = 'username';
  static const String _emailKey = 'email';

  // --- TOKEN MANAGEMENT ---
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    // Tambahkan log untuk memudahkan debug saat development
    print("SessionHelper: Menyimpan Token Baru: $token");
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return token;
  }

  // --- USER DATA MANAGEMENT ---
  // SARAN: Gabungkan penyimpanan user dan token dalam satu fungsi 
  // agar sinkron saat login berhasil
  static Future<void> saveSession({
    required String token,
    required String username,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_emailKey, email);
    print("SessionHelper: Sesi berhasil disimpan untuk $username");
  }

  static Future<void> saveUser(String username, String email) async {
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

  // --- AUTH CHECK ---
  static Future<bool> isLoggedIn() async {
    String? token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // --- LOGOUT ---
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    print("SessionHelper: Menghapus sesi (Logout)");
    await prefs.clear(); 
  }
}