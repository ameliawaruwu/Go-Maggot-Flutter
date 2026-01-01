import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pembayaran.dart';
import 'models/pesanan_model.dart';
import 'services/pesanan_service.dart';
import 'keranjang.dart';
import 'utils/session_helper.dart';
import 'config/api_config.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartItem>? cartItems;

  const CheckoutPage({super.key, this.cartItems});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  static const Color primaryDarkGreen = Color(0xFF385E39);
  static const Color lightGreen = Color(0xFFE4EDE1);
  static const Color barColor = Color(0xFF6E8761);

  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController namaCtrl = TextEditingController();
  final TextEditingController telpCtrl = TextEditingController();
  final TextEditingController alamatCtrl = TextEditingController();
  final TextEditingController kotaCtrl = TextEditingController();
  final TextEditingController metodeCtrl = TextEditingController();

  final PesananService _pesananService = PesananService();
  bool _isLoading = false;

  // Hitung total harga
  double get totalHarga {
    if (widget.cartItems == null || widget.cartItems!.isEmpty) {
      return 0.0;
    }
    return widget.cartItems!.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  @override
  void dispose() {
    namaCtrl.dispose();
    telpCtrl.dispose();
    alamatCtrl.dispose();
    kotaCtrl.dispose();
    metodeCtrl.dispose();
    super.dispose();
  }

  // ==================== TEST AUTH (BARU) ====================
  Future<void> _testAuth() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );

      final token = await SessionHelper.getToken();
      
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login ulang.');
      }

      print('╔════════════════════════════════════════╗');
      print('║           TEST AUTH DEBUG              ║');
      print('╠════════════════════════════════════════╣');
      print('║ Token: ${token.substring(0, 30)}...');
      print('║ URL: ${ApiConfig.baseUrl}/test-auth');
      print('╚════════════════════════════════════════╝');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/test-auth'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (mounted) Navigator.pop(context);

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 32),
                  SizedBox(width: 12),
                  Text('✅ Auth Berhasil'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Message: ${data['message']}'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${data['user']['id_pengguna']}'),
                        Text('Email: ${data['user']['email']}'),
                        Text('Role: ${data['user']['role']}'),
                        Text('Username: ${data['user']['username'] ?? 'N/A'}'),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } else if (response.statusCode == 401) {
        throw Exception('Token tidak valid atau expired. Silakan login ulang.');
      } else {
        throw Exception('Auth gagal (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      
      print('❌ Test Auth Error: $e');
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.error, color: Colors.red, size: 32),
                SizedBox(width: 12),
                Text('❌ Auth Gagal'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Token tidak valid atau expired.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Error: $e'),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    '💡 Solusi:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text('• Logout dan login kembali'),
                  const Text('• Pastikan koneksi internet stabil'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  // ==================== TEST KONEKSI ====================
  Future<void> _testConnection() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );

      print('╔════════════════════════════════════════╗');
      print('║        TEST KONEKSI DEBUG              ║');
      print('╠════════════════════════════════════════╣');
      print('║ Base URL: ${ApiConfig.baseUrl}');
      print('╚════════════════════════════════════════╝');
      
      // Test endpoint public
      final testPublic = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/produk'),
      ).timeout(const Duration(seconds: 10));
      
      print('✅ Public endpoint (produk): ${testPublic.statusCode}');

      // Test endpoint dengan auth
      final token = await SessionHelper.getToken();
      if (token != null) {
        final testAuth = await http.get(
          Uri.parse('${ApiConfig.baseUrl}/profile'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ).timeout(const Duration(seconds: 10));
        
        print('✅ Auth endpoint (profile): ${testAuth.statusCode}');
        print('Response: ${testAuth.body}');
      }

      if (mounted) Navigator.pop(context);

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 32),
                SizedBox(width: 12),
                Text('✅ Koneksi OK'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Server: ${ApiConfig.baseUrl}'),
                const SizedBox(height: 8),
                Text('Status: Terhubung'),
                const SizedBox(height: 8),
                Text('Public API: ${testPublic.statusCode == 200 ? "✅" : "❌"}'),
                if (token != null)
                  const Text('Auth Token: ✅ Valid'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      
      print('❌ Test koneksi gagal: $e');
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.error, color: Colors.red, size: 32),
                SizedBox(width: 12),
                Text('❌ Koneksi Gagal'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Error: $e'),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    '💡 Pastikan:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text('• Server Laravel berjalan'),
                  const Text('  → php artisan serve --host=0.0.0.0'),
                  Text('• URL benar: ${ApiConfig.baseUrl}'),
                  const Text('• Koneksi internet aktif'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  // ==================== SUBMIT CHECKOUT ====================
  Future<void> _submitCheckout() async {
    // Validasi form
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Mohon lengkapi semua field'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validasi cart tidak kosong
    if (widget.cartItems == null || widget.cartItems!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Keranjang belanja kosong'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Cek loading state
    if (_isLoading) return;

    setState(() => _isLoading = true);

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Memproses pesanan...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      // Ambil token
      final token = await SessionHelper.getToken();
      
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login ulang');
      }

      print('╔════════════════════════════════════════╗');
      print('║         SUBMIT CHECKOUT DEBUG          ║');
      print('╠════════════════════════════════════════╣');
      print('║ Token: ${token.substring(0, 30)}...');
      print('║ URL: ${ApiConfig.checkoutProcess}');
      print('╚════════════════════════════════════════╝');

      // Siapkan data checkout
      final checkoutData = {
        'nama_penerima': namaCtrl.text.trim(),
        'nomor_telepon': telpCtrl.text.trim(),
        'alamat_lengkap': '${alamatCtrl.text.trim()}, ${kotaCtrl.text.trim()}',
        'metode_pembayaran': metodeCtrl.text.trim().toUpperCase(),
        'total_harga': totalHarga.toInt(),
        'items': widget.cartItems!.map((item) => {
          'id_produk': item.product.idProduk,
          'harga': item.product.harga.toInt(),
          'jumlah': item.quantity,
        }).toList(),
      };

      print('📦 Checkout Data:');
      print(json.encode(checkoutData));

      // Kirim request
      final response = await _pesananService.submitCheckout(
        checkoutData,
        token,
      );

      // Tutup loading
      if (mounted) {
        Navigator.of(context).pop();
        setState(() => _isLoading = false);
      }

      print('✅ Checkout Success!');
      print('Response: ${json.encode(response)}');

      // Handle success
      if (mounted) {
        // Ambil id_pesanan dari response
        final idPesanan = response['data']?['id_pesanan']?.toString() ?? 
                          response['id_pesanan']?.toString() ?? 
                          'Unknown';
        
        final totalBayar = response['data']?['total_harga']?.toString() ?? 
                           totalHarga.toStringAsFixed(0);

        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 32),
                SizedBox(width: 12),
                Text('Pesanan Berhasil!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  response['message'] ?? 'Pesanan berhasil dibuat',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ID Pesanan:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        idPesanan,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Total Pembayaran:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp. $totalBayar',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryDarkGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                  // Navigate ke halaman pembayaran
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(orderId: idPesanan),
                    ),
                  );
                },
                child: const Text('Lanjut ke Pembayaran'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Tutup loading
      if (mounted) {
        Navigator.of(context).pop();
        setState(() => _isLoading = false);
      }

      print('❌ Error submit checkout: $e');

      // Show error dialog
      if (mounted) {
        String errorMessage = e.toString().replaceAll('Exception: ', '');
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.error, color: Colors.red, size: 32),
                SizedBox(width: 12),
                Text('Gagal'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(errorMessage),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _testAuth();
                          },
                          icon: const Icon(Icons.verified_user, size: 16),
                          label: const Text('Test Auth', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _testConnection();
                          },
                          icon: const Icon(Icons.wifi, size: 16),
                          label: const Text('Test Koneksi', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDarkGreen,
      appBar: AppBar(
        backgroundColor: primaryDarkGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Checkout Produk',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          // ✅ BUTTON TEST AUTH (BARU)
          IconButton(
            icon: const Icon(Icons.verified_user, color: Colors.white),
            onPressed: _testAuth,
            tooltip: 'Test Auth',
          ),
          // Button test koneksi
          IconButton(
            icon: const Icon(Icons.wifi, color: Colors.white),
            onPressed: _testConnection,
            tooltip: 'Test Koneksi',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: lightGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Cart Items
                if (widget.cartItems != null && widget.cartItems!.isNotEmpty)
                  ...widget.cartItems!.map((item) => _buildProductItem(item))
                else
                  _buildDefaultItem(),

                const SizedBox(height: 16),
                
                // Total Harga
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: barColor, width: 2),
                  ),
                  child: Text(
                    'Total Harga: Rp. ${totalHarga.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: primaryDarkGreen,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const Divider(height: 32, thickness: 2),
                
                // Form Pengiriman
                const Text(
                  'Detail Pengiriman',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                
                _buildInput(
                  'Nama Penerima',
                  namaCtrl,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama penerima wajib diisi';
                    }
                    return null;
                  },
                ),
                
                _buildInput(
                  'Nomor Telepon',
                  telpCtrl,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor telepon wajib diisi';
                    }
                    if (value.length < 10) {
                      return 'Nomor telepon minimal 10 digit';
                    }
                    return null;
                  },
                ),
                
                _buildInput(
                  'Alamat Lengkap',
                  alamatCtrl,
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat wajib diisi';
                    }
                    return null;
                  },
                ),
                
                _buildInput(
                  'Kota',
                  kotaCtrl,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kota wajib diisi';
                    }
                    return null;
                  },
                ),
                
                _buildInput(
                  'Metode Pembayaran (COD/QRIS)',
                  metodeCtrl,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Metode pembayaran wajib diisi';
                    }
                    final upper = value.toUpperCase();
                    if (upper != 'COD' && upper != 'QRIS') {
                      return 'Hanya tersedia COD atau QRIS';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Button Submit
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: barColor,
                    disabledBackgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Kirim',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==================== WIDGET BUILDERS ====================
  
  Widget _buildProductItem(CartItem item) {
    return Container(
      decoration: BoxDecoration(
        color: barColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: (item.product.gambarUrl != null &&
                    item.product.gambarUrl!.isNotEmpty)
                ? Image.network(
                    item.product.gambarUrl!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/maggot_removebg.png',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(
                    'assets/maggot_removebg.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.namaProduk,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'x${item.quantity}  Rp. ${item.product.harga.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Text(
            'Rp. ${item.subtotal.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultItem() {
    return Container(
      decoration: BoxDecoration(
        color: barColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: const Center(
        child: Text(
          'Keranjang kosong',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildInput(
    String hint,
    TextEditingController controller, {
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: barColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}