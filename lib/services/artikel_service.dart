import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/artikel_model.dart';

class ArtikelService {
  // Gunakan 10.0.2.2 untuk akses localhost laptop dari emulator Android
  static const String baseUrl = 'http://192.168.1.12:8000/api';

  Future<List<ArtikelModel>> fetchArtikels() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/artikel'));

      if (response.statusCode == 200) {
        // 1. Decode response body ke dalam Map karena Laravel mengirim Object { ... }
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        // 2. Ambil List artikel dari dalam key 'data' sesuai ArtikelApiController
        // Controller Laravel: return response()->json(['message' => '...', 'data' => $data]);
        final List<dynamic> jsonResponse = responseData['data']; 

        // 3. Map setiap item menjadi objek ArtikelModel
        return jsonResponse.map((data) => ArtikelModel.fromJson(data)).toList();
      } else {
        // Memberikan info jika status code bukan 200 (misal 404 atau 500)
        throw Exception('Gagal memuat data artikel: Status ${response.statusCode}');
      }
    } catch (e) {
      // Menangkap error koneksi atau error parsing
      throw Exception('Terjadi kesalahan koneksi: $e');
    }
  }
}