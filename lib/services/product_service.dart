import 'dart:convert';
import 'package:http/http.dart' as http;
// Import Config
import '../config/api_config.dart';
// Import Model (PASTIKAN NAMA FILENYA BENAR)
// Jika file model kamu namanya 'produk.dart', pakai ini:
import '../models/product_model.dart'; 

class ProdukService {
  
  // 1. Fungsi Ambil Semua Produk
  Future<List<ProdukModel>> getAllProducts() async {
    try {
      final Uri url = Uri.parse(ApiConfig.products);
      
      // CCTV 1: Cek URL yang ditembak
      print("--- MEMULAI REQUEST KE: $url ---"); 

      final response = await http.get(url);

      // CCTV 2: Cek Status & Isi Data
      print("Status Code: ${response.statusCode}");
      print("Isi Body: ${response.body}");

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        
        List<dynamic> listData;
        
        // Handler Format JSON Laravel (Apakah dibungkus 'data' atau tidak)
        if (decodedData is Map<String, dynamic> && decodedData.containsKey('data')) {
          listData = decodedData['data'];
        } else if (decodedData is List) {
          listData = decodedData;
        } else {
          print("Format JSON Aneh/Kosong: $decodedData"); // CCTV 3
          return [];
        }

        print("Berhasil parsing ${listData.length} data!"); // CCTV 4

        List<ProdukModel> products = listData
            .map((json) => ProdukModel.fromJson(json))
            .toList();
            
        return products;
      } else {
        throw Exception('Gagal ambil data: ${response.statusCode}');
      }
    } catch (e) {
      // CCTV 5: Tangkap Errornya
      print("ERROR FATAL DI SERVICE: $e");
      rethrow;
    }
  }

  // 2. Fungsi Ambil Detail Produk
  Future<ProdukModel> getDetail(String id) async {
    try {
      final Uri url = Uri.parse(ApiConfig.productDetail(id));
      print("--- GET DETAIL: $url ---");
      
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final item = (data is Map && data.containsKey('data')) ? data['data'] : data;
        return ProdukModel.fromJson(item);
      } else {
        throw Exception('Gagal load detail');
      }
    } catch (e) {
      print("Error Detail: $e");
      rethrow;
    }
  }
}