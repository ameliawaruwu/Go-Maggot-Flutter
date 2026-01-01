import 'package:shared_preferences/shared_preferences.dart';

class SessionHelper {
  static const String _tokenKey = 'auth_token';
  static const String _usernameKey = 'username';
  static const String _emailKey = 'email';
  static const String _photoKey = 'foto_profil'; // Tambahkan variabel key foto

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
  // Parameter tetap 2 agar tidak membuat error di file lain
  static Future<void> saveUser(String username, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_emailKey, email);
  }

  // Fungsi khusus untuk simpan foto agar tidak merusak saveUser yang sudah ada
  static Future<void> savePhoto(String photo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_photoKey, photo);
  }

  // Mengambil data user dalam bentuk Map
  static Future<Map<String, String>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(_usernameKey);
    String? email = prefs.getString(_emailKey);
    String? photo = prefs.getString(_photoKey); 

    if (username != null && email != null) {
      return {
        'username': username,
        'email': email,
        'foto_profil': photo ?? '',
      };
    }
    return null;
  }

  // --- LOGOUT / CLEAR ---
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 
  }
}