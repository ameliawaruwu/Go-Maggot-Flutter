import 'package:shared_preferences/shared_preferences.dart';

class SessionHelper {
  static const String _tokenKey = 'auth_token'; // Kunci rahasia untuk simpan token

  // ----------------------------------------------------------
  // 1. SIMPAN TOKEN (Dipanggil saat Login Berhasil)
  // ----------------------------------------------------------
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    print("💾 Token berhasil disimpan ke HP");
  }

  // ----------------------------------------------------------
  // 2. AMBIL TOKEN (Dipanggil saat mau Request ke API)
  // ----------------------------------------------------------
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(_tokenKey);
    // print("🔑 Mengambil Token: $token"); // Debugging (opsional)
    return token;
  }

  // ----------------------------------------------------------
  // 3. HAPUS TOKEN (Dipanggil saat Logout)
  // ----------------------------------------------------------
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    print("🗑️ Token dihapus (Logout)");
  }
}