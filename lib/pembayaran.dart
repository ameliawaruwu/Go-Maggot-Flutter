import 'package:flutter/material.dart';
import 'qr-code.dart'; // Pastikan file ini ada
import 'status_pesanan.dart'; // <--- PENTING: Import halaman tujuan

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? _fileName; 

  void _selectFile() {
    setState(() {
      _fileName = 'bukti_bayar_01.jpg'; 
    });
    debugPrint('File dipilih: $_fileName');
  }

  void _submitPayment() {
    // 1. Cek apakah file sudah dipilih
    if (_fileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih bukti bayar terlebih dahulu!'),
          backgroundColor: Colors.red, // Merah untuk error
        ),
      );
    } else {
      // 2. Tampilkan Notifikasi Sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Pembayaran Berhasil!'),
            ],
          ),
          backgroundColor: Colors.green, // Hijau untuk sukses
          duration: Duration(seconds: 2), // Muncul selama 2 detik
        ),
      );
      
      debugPrint('Bukti bayar $_fileName dikirim.');

      // 3. Beri jeda 2 detik agar notifikasi terbaca, lalu pindah halaman
      Future.delayed(const Duration(seconds: 2), () {
        // Cek mounted agar tidak error jika user keluar sebelum 2 detik
        if (mounted) {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => const StatusPesananPage()),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF385E39);
    const Color cardColor = Color(0xFFE4EDE1); 
    
    return Scaffold(
      backgroundColor: primaryColor, 
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0, 
        title: const Text(
          'Pembayaran',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Ubah icon jadi putih biar kontras
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView( // Tambahkan Scroll agar aman di layar kecil
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, 
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Judul "Scan QR Code"
                  const Text(
                    'Scan QR Code',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Widget QR Code
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(10), 
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      // Pastikan class QrCodeImage ada di file qr-code.dart
                      // Jika error, ganti sementara dengan Icon(Icons.qr_code, size: 150)
                      child: const QrCodeImage(size: 150), 
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Bagian Unggah Bukti Bayar
                  const Text(
                    'Kirim Bukti Bayar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  // Input Unggah File
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Teks nama file
                        Expanded(
                          child: Text(
                            _fileName ?? 'Belum ada file...',
                            style: TextStyle(
                              color: _fileName == null ? Colors.grey : Colors.black,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        // Tombol "choose file"
                        InkWell(
                          onTap: _selectFile,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Pilih File',
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Teks "Lihat gambar"
                  const Text(
                    'Format: JPG, PNG',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Tombol "Kirim"
                  ElevatedButton(
                    onPressed: _submitPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, 
                      foregroundColor: Colors.white, 
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      'Kirim',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}