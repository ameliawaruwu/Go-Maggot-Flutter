import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/pesanan_model.dart';

class PesananService {
  // Fetch pesanan untuk pengguna tertentu
  Future<List<Pesanan>> fetchPesanan(String token) async {
    final response = await http.get(
      Uri.parse(ApiConfig.myOrders),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Pesanan.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pesanan');
    }
  }

  // Fetch detail pesanan berdasarkan ID
  Future<Pesanan> fetchPesananDetail(String idPesanan, String token) async {
    final response = await http.get(
      Uri.parse(ApiConfig.myOrderDetail(idPesanan)),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Pesanan.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load pesanan detail');
    }
  }

  // Create pesanan baru (Lama - Menggunakan Model)
  Future<Pesanan> createPesanan(Pesanan pesanan, String token) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/pesanan'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(pesanan.toJson()),
    );

    if (response.statusCode == 201) {
      return Pesanan.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create pesanan');
    }
  }

  // PERBAIKAN: Fungsi baru khusus untuk memproses Map dari CheckoutPage
  // Gunakan ini untuk memanggil endpoint checkout/process yang kita buat di Laravel
  Future<Map<String, dynamic>> submitCheckout(Map<String, dynamic> data, String token) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/checkout/process'), // Sesuaikan dengan route Laravel
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json', // Penting agar Laravel mengirim JSON
      },
      body: json.encode(data),
    );

    final responseData = json.decode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return responseData;
    } else {
      // Mengambil pesan error dari Laravel jika ada
      String errorMessage = responseData['message'] ?? 'Gagal memproses checkout';
      throw Exception(errorMessage);
    }
  }
}