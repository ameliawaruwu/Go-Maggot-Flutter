import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pesanan_model.dart';

class PesananService {
  // Ganti dengan IP laptop temanmu
  final String baseUrl = "http://:8000/api"; 

  Future<List<PesananModel>> getPesananUser(String idPengguna) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/pesanan/user/$idPengguna"));

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        // Mengubah list JSON menjadi list objek PesananModel
        return data.map((json) => PesananModel.fromJson(json)).toList();
      } else {
        throw Exception("Gagal memuat data pesanan");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}