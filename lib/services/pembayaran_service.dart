import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PembayaranService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<bool> uploadBuktiBayar(String orderId, File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Gunakan MultipartRequest untuk upload file
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/pembayaran/upload'), // Sesuaikan route Laravel nanti
    );

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    request.fields['id_pesanan'] = orderId;
    
    // Tambahkan file gambar
    request.files.add(
      await http.MultipartFile.fromPath('bukti_bayar', imageFile.path),
    );

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print('Upload Error: ${response.body}');
      return false;
    }
  }
}