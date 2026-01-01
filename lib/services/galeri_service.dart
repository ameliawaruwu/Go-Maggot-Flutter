import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/galeri_model.dart'; // Sesuaikan path-nya


class GaleriService {
  // Ganti dengan IP lokal laptop Anda jika menggunakan emulator (biasanya 10.0.2.2)
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<GaleriModel>> fetchGaleri() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/galeri'));

     if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
        print("URL Gambar Pertama: ${body['data'][0]['gambar_url']}"); // Cek URL gambar
        print("Jumlah Data: ${body['data'].length}"); // Cek jumlah data
        List<dynamic> data = body['data'];
        return data.map((json) => GaleriModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil data galeri');
      }
    } catch (e) {
      throw Exception('Kesalahan koneksi: $e');
    }
  }
}