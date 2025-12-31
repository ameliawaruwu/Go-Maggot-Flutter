import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../utils/session_helper.dart';
import '../models/review_model.dart';

class FeedbackService {
  
  static Future<bool> kirimReview(ReviewModel dataReview, {File? foto, File? video}) async {
    try {
      // 1. Ambil Token dari Session
      String? token = await SessionHelper.getToken();
      if (token == null) {
        print("❌ Token tidak ditemukan.");
        return false;
      }

      // 2. Gunakan MultipartRequest untuk mengirim file
      var request = http.MultipartRequest('POST', Uri.parse(ApiConfig.reviews));

      // 3. Tambahkan Header
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      // 4. Tambahkan Field Teks (Ambil dari model toJson)
      Map<String, dynamic> reviewMap = dataReview.toJson();
      reviewMap.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // 5. Tambahkan File Foto jika ada
      if (foto != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'foto', // Nama field harus sesuai dengan $request->file('foto') di Laravel
          foto.path,
        ));
      }

      // 6. Tambahkan File Video jika ada
      if (video != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'video', // Nama field harus sesuai dengan $request->file('video') di Laravel
          video.path,
        ));
      }

      // 7. Eksekusi Request
      print("📤 Mengirim data multipart...");
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Respon Server: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("❌ Gagal Kirim: ${response.body}");
        return false;
      }
    } catch (e) {
      print("⚠️ Error Koneksi FeedbackService: $e");
      return false;
    }
  }
}