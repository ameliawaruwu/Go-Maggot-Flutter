import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/pesanan_model.dart';

class PesananService {
  // ==================== FETCH PESANAN ====================
  /// Mengambil daftar semua pesanan milik user yang sedang login
  Future<List<Pesanan>> fetchPesanan(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.orderStatus),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      print('Fetch Pesanan Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        // Handle jika response berupa object dengan key 'data'
        final List<dynamic> pesananList;
        if (responseData is Map && responseData.containsKey('data')) {
          pesananList = responseData['data'] as List<dynamic>;
        } else if (responseData is List) {
          pesananList = responseData;
        } else {
          throw Exception('Format response tidak sesuai');
        }

        return pesananList.map((json) => Pesanan.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login ulang');
      } else {
        throw Exception('Gagal memuat daftar pesanan');
      }
    } on SocketException {
      throw Exception('Tidak dapat terhubung ke server');
    } on TimeoutException {
      throw Exception('Request timeout');
    } catch (e) {
      print('Error fetchPesanan: $e');
      rethrow;
    }
  }

  // ==================== FETCH DETAIL PESANAN ====================
  /// Mengambil detail pesanan berdasarkan ID
  Future<Pesanan> fetchPesananDetail(String idPesanan, String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.myOrderDetail(idPesanan)),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      print('Fetch Detail Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        // Langsung extract data pesanan
        if (responseData is Map) {
          // Jika ada key 'data', ambil itu; jika tidak, gunakan responseData langsung
          final pesananJson = responseData.containsKey('data') 
              ? responseData['data'] as Map<String, dynamic>
              : responseData as Map<String, dynamic>;
          
          return Pesanan.fromJson(pesananJson);
        } else {
          throw Exception('Format response tidak sesuai');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Pesanan tidak ditemukan');
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir. Silakan login ulang');
      } else {
        throw Exception('Gagal memuat detail pesanan');
      }
    } on SocketException {
      throw Exception('Tidak dapat terhubung ke server');
    } on TimeoutException {
      throw Exception('Request timeout');
    } catch (e) {
      print('Error fetchPesananDetail: $e');
      rethrow;
    }
  }

  // ==================== SUBMIT CHECKOUT ====================
  /// Memproses checkout dan membuat pesanan baru
  Future<Map<String, dynamic>> submitCheckout(
    Map<String, dynamic> data,
    String token,
  ) async {
    try {
      // ===== DEBUG LOGS =====
      print('╔════════════════════════════════════════╗');
      print('║       CHECKOUT DEBUG INFO              ║');
      print('╠════════════════════════════════════════╣');
      print('║ URL: ${ApiConfig.checkoutProcess}');
      print('║ Token: Bearer ${token.length > 20 ? token.substring(0, 20) + '...' : token}');
      print('║ Data:');
      print('║   - Nama: ${data['nama_penerima']}');
      print('║   - Telp: ${data['nomor_telepon']}');
      print('║   - Alamat: ${data['alamat_lengkap']}');
      print('║   - Metode: ${data['metode_pembayaran']}');
      print('║   - Total: ${data['total_harga']}');
      print('║   - Items: ${data['items']?.length ?? 0} item(s)');
      print('╚════════════════════════════════════════╝');

      // Validasi data sebelum dikirim
      _validateCheckoutData(data);

      // ===== HTTP REQUEST =====
      final response = await http.post(
        Uri.parse(ApiConfig.checkoutProcess),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(data),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Server tidak merespons dalam 30 detik');
        },
      );

      // ===== RESPONSE LOGS =====
      print('╔════════════════════════════════════════╗');
      print('║       CHECKOUT RESPONSE                ║');
      print('╠════════════════════════════════════════╣');
      print('║ Status: ${response.statusCode}');
      print('║ Body: ${response.body}');
      print('╚════════════════════════════════════════╝');

      // ===== HANDLE SUCCESS (200 atau 201) =====
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        
        // Validasi response structure
        if (responseData['status'] == 'success') {
          print('✅ Checkout berhasil!');
          return responseData;
        } else {
          throw Exception(responseData['message'] ?? 'Checkout gagal');
        }
      }

      // ===== HANDLE ERROR 401 (Unauthorized) =====
      else if (response.statusCode == 401) {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ?? 'Token tidak valid. Silakan login ulang'
        );
      }

      // ===== HANDLE ERROR 422 (Validation Error) =====
      else if (response.statusCode == 422) {
        final errorData = json.decode(response.body);
        String errorMsg = errorData['message'] ?? 'Validasi gagal';

        // Parse validation errors
        if (errorData['errors'] != null) {
          final errors = errorData['errors'] as Map<String, dynamic>;
          List<String> errorMessages = [];

          errors.forEach((field, messages) {
            if (messages is List) {
              errorMessages.addAll(
                messages.map((msg) => '• $msg').toList()
              );
            } else {
              errorMessages.add('• $messages');
            }
          });

          if (errorMessages.isNotEmpty) {
            errorMsg += ':\n${errorMessages.join('\n')}';
          }
        }

        throw Exception(errorMsg);
      }

      // ===== HANDLE ERROR 500 (Server Error) =====
      else if (response.statusCode == 500) {
        final errorData = json.decode(response.body);
        throw Exception(
          'Server error: ${errorData['message'] ?? 'Terjadi kesalahan pada server'}'
        );
      }

      // ===== HANDLE OTHER ERRORS =====
      else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ?? 'Gagal memproses checkout (${response.statusCode})'
        );
      }
    }

    // ===== EXCEPTION HANDLERS =====
    on SocketException catch (e) {
      print('❌ SocketException: $e');
      throw Exception(
        'Tidak dapat terhubung ke server\n\n'
        'Pastikan:\n'
        '• Server Laravel berjalan\n'
        '  → php artisan serve --host=0.0.0.0\n'
        '• URL benar: ${ApiConfig.baseUrl}\n'
        '• Koneksi internet aktif'
      );
    } on TimeoutException catch (e) {
      print('❌ TimeoutException: $e');
      throw Exception('Server tidak merespons. Coba lagi');
    } on FormatException catch (e) {
      print('❌ FormatException: $e');
      throw Exception('Format response dari server tidak valid');
    } on http.ClientException catch (e) {
      print('❌ ClientException: $e');
      throw Exception('Koneksi terputus saat mengirim data');
    } catch (e) {
      print('❌ Unknown Error: $e');
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // ==================== VALIDASI DATA CHECKOUT ====================
  void _validateCheckoutData(Map<String, dynamic> data) {
    final requiredFields = [
      'nama_penerima',
      'nomor_telepon',
      'alamat_lengkap',
      'metode_pembayaran',
      'total_harga',
      'items'
    ];

    for (var field in requiredFields) {
      if (!data.containsKey(field) || data[field] == null) {
        throw Exception('Field $field wajib diisi');
      }
    }

    // Validasi items tidak kosong
    if (data['items'] is! List || (data['items'] as List).isEmpty) {
      throw Exception('Keranjang belanja kosong');
    }

    // Validasi setiap item
    for (var item in data['items']) {
      if (item['id_produk'] == null ||
          item['harga'] == null ||
          item['jumlah'] == null) {
        throw Exception('Data produk tidak lengkap');
      }
    }

    print('✅ Validasi data checkout berhasil');
  }

  // ==================== UPLOAD BUKTI PEMBAYARAN ====================
  Future<Map<String, dynamic>> uploadBuktiPembayaran(
  String idPesanan,
  File imageFile,
  String token,
) async {
  try {
    print('╔════════════════════════════════════════╗');
    print('║       UPLOAD BUKTI BAYAR DEBUG         ║');
    print('╠════════════════════════════════════════╣');
    print('║ URL: ${ApiConfig.uploadPaymentProof}');
    print('║ ID Pesanan: $idPesanan');
    print('║ File Path: ${imageFile.path}');
    print('║ File Size: ${await imageFile.length()} bytes');
    print('║ Token: Bearer ${token.substring(0, 20)}...');
    print('╚════════════════════════════════════════╝');

    // Validasi file exists
    if (!await imageFile.exists()) {
      throw Exception('File tidak ditemukan di path: ${imageFile.path}');
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConfig.uploadPaymentProof),
    );

    // Headers
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    // Fields
    request.fields['id_pesanan'] = idPesanan;

    // File
    var multipartFile = await http.MultipartFile.fromPath(
      'bukti_bayar',
      imageFile.path,
      filename: 'bukti_bayar_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    
    request.files.add(multipartFile);

    print('📤 Sending request...');

    // Send request
    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw TimeoutException('Upload timeout setelah 30 detik');
      },
    );

    final response = await http.Response.fromStream(streamedResponse);

    print('╔════════════════════════════════════════╗');
    print('║       UPLOAD RESPONSE                  ║');
    print('╠════════════════════════════════════════╣');
    print('║ Status: ${response.statusCode}');
    print('║ Body: ${response.body}');
    print('╚════════════════════════════════════════╝');

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      
      if (responseData['status'] == 'success') {
        print('✅ Upload berhasil!');
        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Upload gagal');
      }
    } else if (response.statusCode == 422) {
      // Validation error
      final errorData = json.decode(response.body);
      String errorMsg = errorData['message'] ?? 'Validasi gagal';
      
      if (errorData['errors'] != null) {
        final errors = errorData['errors'] as Map<String, dynamic>;
        List<String> errorMessages = [];
        
        errors.forEach((field, messages) {
          if (messages is List) {
            errorMessages.addAll(messages.map((msg) => '• $msg').toList());
          }
        });
        
        if (errorMessages.isNotEmpty) {
          errorMsg += ':\n${errorMessages.join('\n')}';
        }
      }
      
      throw Exception(errorMsg);
    } else if (response.statusCode == 401) {
      throw Exception('Sesi telah berakhir. Silakan login ulang');
    } else if (response.statusCode == 404) {
      throw Exception('Pesanan tidak ditemukan');
    } else {
      final errorData = json.decode(response.body);
      throw Exception(
        errorData['message'] ?? 'Upload gagal (${response.statusCode})'
      );
    }
  } on SocketException {
    print('❌ SocketException');
    throw Exception('Tidak dapat terhubung ke server. Pastikan server Laravel berjalan');
  } on TimeoutException catch (e) {
    print('❌ TimeoutException: $e');
    throw Exception('Upload timeout. Coba lagi');
  } on FormatException catch (e) {
    print('❌ FormatException: $e');
    throw Exception('Response dari server tidak valid');
  } catch (e) {
    print('❌ Upload Error: $e');
    if (e is Exception) {
      rethrow;
    }
    throw Exception('Gagal upload: $e');
  }
}
}