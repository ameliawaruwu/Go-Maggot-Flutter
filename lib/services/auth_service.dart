import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/pengguna.dart';
import '../models/register_result.dart';
import '../models/login_result.dart';
import '../utils/session_helper.dart'; // Tambahkan import

class AuthService {
  static const String baseUrl = 'http://192.168.1.12:8000/api';
  
  // LOGIN 
  static Future<LoginResult> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Accept': 'application/json'},
        body: {
          'email': email,
          'password': password,
        },
      );

      print('LOGIN STATUS: ${response.statusCode}');
      print('LOGIN BODY: ${response.body}');

      final json = jsonDecode(response.body);

      // ✅ LOGIN BERHASIL
      if (response.statusCode == 200) {
        // 1. Ambil token dari JSON (cek apakah key-nya 'token' atau 'access_token')
        String? token = json['token'] ?? json['access_token'];

        // 2. SIMPAN DATA KE STORAGE (Langkah yang sebelumnya hilang)
        if (token != null) {
          await SessionHelper.saveToken(token); // Simpan token agar bisa dipakai di FeedbackService
          
          // Simpan data user (gunakan null check '??' untuk keamanan)
          await SessionHelper.saveUser(
            json['user']['name'] ?? json['user']['username'] ?? 'User',
            json['user']['email'] ?? '',
          );
        }

        return LoginResult(
          success: true,
          message: json['message'] ?? 'Login berhasil',
          user: Pengguna.fromJson(json['user']),
        );
      }

      // ❌ LOGIN GAGAL (EMAIL / PASSWORD SALAH)
      if (response.statusCode == 401 || response.statusCode == 422) {
        return LoginResult(
          success: false,
          message: json['message'] ?? 'Email atau password salah',
        );
      }

      return LoginResult(
        success: false,
        message: 'Terjadi kesalahan, coba lagi',
      );
    } catch (e) {
      print('ERROR LOGIN: $e');
      return LoginResult(
        success: false,
        message: 'Tidak dapat terhubung ke server',
      );
    }
  }

  static Future<RegisterResult> register(
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Accept': 'application/json'},
        body: {
          'name': username,
          'email': email,
          'password': password,
        },
      );

      print('REGISTER STATUS: ${response.statusCode}');
      print('REGISTER BODY: ${response.body}');

      final json = jsonDecode(response.body);

      // ✅ REGISTER BERHASIL
      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResult(
          success: true,
          message: 'Registrasi berhasil, silakan login',
        );
      }

      // ⚠️ VALIDASI GAGAL
      if (response.statusCode == 422) {
        if (json['errors'] != null && json['errors']['email'] != null) {
          return RegisterResult(
            success: false,
            message: 'Email sudah terdaftar',
          );
        }

        return RegisterResult(
          success: false,
          message: 'Data tidak valid',
        );
      }

      return RegisterResult(
        success: false,
        message: 'Terjadi kesalahan, coba lagi',
      );
    } catch (e) {
      print('ERROR REGISTER: $e');
      return RegisterResult(
        success: false,
        message: 'Tidak dapat terhubung ke server',
      );
    }
  }
}