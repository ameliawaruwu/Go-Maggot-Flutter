import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../utils/session_helper.dart';
import 'dart:async'; 

class PembayaranService {
  static const String baseUrl = 'http://192.168.1.12:8000/api';

  Future<bool> uploadBuktiBayar(String orderId, File imageFile) async {
    try {
      final token = await SessionHelper.getToken();
      
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login ulang.');
      }

      print('📤 Starting upload...');
      print('Order ID: $orderId');
      print('File: ${imageFile.path}');

      // ✅ CEK FILE EXISTS & READABLE
      if (!await imageFile.exists()) {
        throw Exception('File tidak ditemukan');
      }

      // ✅ BUAT REQUEST DENGAN TIMEOUT
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/pembayaran/upload'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.fields['id_pesanan'] = orderId;

      // ✅ BACA FILE SEBAGAI BYTES (lebih reliable)
      final bytes = await imageFile.readAsBytes();
      final fileName = imageFile.path.split('/').last;

      print('📦 File size: ${bytes.length} bytes');
      print('📦 File name: $fileName');

      request.files.add(
        http.MultipartFile.fromBytes(
          'bukti_bayar',
          bytes,
          filename: fileName,
        ),
      );

      print('📤 Sending request...');

      // ✅ KIRIM DENGAN TIMEOUT
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Upload timeout. Periksa koneksi internet Anda.');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);

      print('📥 Response:');
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Upload berhasil!');
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('Sesi berakhir. Silakan login ulang.');
      } else if (response.statusCode == 422) {
        final json = jsonDecode(response.body);
        final errors = json['errors'] ?? json['message'] ?? 'Validasi gagal';
        throw Exception('Validasi gagal: $errors');
      } else if (response.statusCode == 404) {
        throw Exception('Pesanan tidak ditemukan');
      } else {
        final json = jsonDecode(response.body);
        final msg = json['message'] ?? 'Gagal upload';
        throw Exception(msg);
      }

    } on SocketException {
      throw Exception('Tidak ada koneksi internet');
    } on TimeoutException {
      throw Exception('Upload timeout. Coba lagi.');
    } on FormatException {
      throw Exception('Format respons tidak valid');
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }
}
