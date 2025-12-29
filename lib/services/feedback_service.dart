import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../utils/session_helper.dart';
import '../models/review_model.dart';

class FeedbackService {
  
  // Fungsi Kirim Review
  static Future<bool> kirimReview(ReviewModel dataReview) async {
    try {
      // 1. Ambil Token (Wajib)
      String? token = await SessionHelper.getToken();
      if (token == null) {
        print("❌ Token tidak ditemukan (Belum Login)");
        return false;
      }

      // 2. Kirim Request
      var response = await http.post(
        Uri.parse(ApiConfig.reviews), // Pastikan URL ini benar (/api/reviews)
        headers: {
          'Content-Type': 'application/json', // Wajib JSON
          'Accept': 'application/json',       // Biar errornya kebaca
          'Authorization': 'Bearer $token',   // Tiket Masuk
        },
        // 3. Ubah Model jadi JSON pakai fungsi toJson() tadi
        body: jsonEncode(dataReview.toJson()), 
      );

      print("📤 Mengirim Data: ${dataReview.toJson()}");
      print("📥 Respon Server: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("⚠️ Error Koneksi: $e");
      return false;
    }
  }
}