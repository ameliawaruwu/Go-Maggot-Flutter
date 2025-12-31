import 'package:flutter/material.dart';
import 'pembayaran.dart';
import 'models/pesanan_model.dart';
import 'services/pesanan_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'keranjang.dart';
import 'utils/session_helper.dart';

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

  final TextEditingController namaCtrl = TextEditingController();
  final TextEditingController telpCtrl = TextEditingController();
  final TextEditingController alamatCtrl = TextEditingController();
  final TextEditingController kotaCtrl = TextEditingController();
  final TextEditingController metodeCtrl = TextEditingController();

  final PesananService _pesananService = PesananService();

  // PERBAIKAN FINAL: Menghindari error double? pada fungsi fold
  double get totalHarga {
    if (widget.cartItems == null || widget.cartItems!.isEmpty) {
      return 0.0;
    }
    // Menggunakan sum tanpa deklarasi tipe double di dalam agar otomatis matching
    return widget.cartItems!.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  void _submitCheckout() async {
    if (namaCtrl.text.isEmpty ||
        telpCtrl.text.isEmpty ||
        alamatCtrl.text.isEmpty ||
        kotaCtrl.text.isEmpty ||
        metodeCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tolong masukkan data'), backgroundColor: Colors.red),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await SessionHelper.getToken();

    if (token == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Silakan login terlebih dahulu (Token tidak ditemukan)'), 
        backgroundColor: Colors.red
      ),
    );
    return;
  }

    final Map<String, dynamic> dataCheckout = {
      'nama_penerima': namaCtrl.text,
      'nomor_telepon': telpCtrl.text,
      'alamat_lengkap': '${alamatCtrl.text}, ${kotaCtrl.text}',
      'pengiriman': 'Reguler',
      'metode_pembayaran': metodeCtrl.text,
      'total_harga': totalHarga, // Tambahkan total harga
      'items': widget.cartItems?.map((item) => {
        'idproduk': item.product.idProduk,
        'harga': item.product.harga,
        'jumlah': item.quantity,
      }).toList(),
    };

    try {
      // PERBAIKAN: Menggunakan submitCheckout karena mengirim Map
      final response = await _pesananService.submitCheckout(dataCheckout, token);
      
      if (mounted) {
        // Ambil ID Pesanan dari response API
        String orderId = response['id_pesanan']?.toString() ?? '0';
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pesanan berhasil dibuat'), backgroundColor: Colors.green),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentPage(orderId: orderId),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuat pesanan: $e'), backgroundColor: Colors.red),
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
        title: const Text('Checkout Produk', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
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
              if (widget.cartItems != null && widget.cartItems!.isNotEmpty)
                ...widget.cartItems!.map((item) => _buildProductItem(item)).toList()
              else
                _buildDefaultItem(),

              const SizedBox(height: 16),
              Text(
                'Total Harga: Rp. ${totalHarga.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Divider(height: 32),
              const Text('Detail Pengiriman', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildInput('Nama Penerima', namaCtrl),
              _buildInput('Nomor Telepon', telpCtrl),
              _buildInput('Alamat', alamatCtrl),
              _buildInput('Kota', kotaCtrl),
              _buildInput('Metode Pembayaran', metodeCtrl),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: barColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Kirim', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductItem(CartItem item) {
    return Container(
      decoration: BoxDecoration(
        color: barColor, 
        borderRadius: BorderRadius.circular(12)
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: (item.product.gambarUrl != null && item.product.gambarUrl!.isNotEmpty)
                ? Image.network(
                    item.product.gambarUrl!, // MEMANGGIL URL GAMBAR DARI MODEL
                    width: 60, 
                    height: 60, 
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Jika URL error (404), tampilkan gambar default
                      return Image.asset(
                        'assets/maggot_removebg.png', 
                        width: 60, height: 60, fit: BoxFit.cover
                      );
                    },
                  )
                : Image.asset(
                    'assets/maggot_removebg.png', // Jika URL null, tampilkan gambar default
                    width: 60, 
                    height: 60, 
                    fit: BoxFit.cover
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.namaProduk, 
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                ),
                Text(
                  'x${item.quantity}  Rp. ${item.product.harga}', 
                  style: const TextStyle(color: Colors.white70)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultItem() {
    return Container(
      decoration: BoxDecoration(color: barColor, borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(12),
      child: const Text('Keranjang kosong', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildInput(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}