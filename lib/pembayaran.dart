import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import Picker
import 'qr-code.dart'; 
import 'status_pesanan.dart'; 
import '../services/pembayaran_service.dart'; // Import Service Anda

class PaymentPage extends StatefulWidget {
  final String orderId;

  const PaymentPage({super.key, required this.orderId});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  File? _imageFile; // Menyimpan file asli
  String? _fileName; 
  bool _isLoading = false; // Untuk indikator loading
  final PembayaranService _pembayaranService = PembayaranService();

  // FUNGSI PILIH GAMBAR ASLI
  Future<void> _selectFile() async {
    final ImagePicker picker = ImagePicker();
    // Membuka galeri
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _fileName = pickedFile.name;
      });
      debugPrint('File dipilih: ${pickedFile.path}');
    }
  }

  // FUNGSI KIRIM KE SERVICE
 // FUNGSI KIRIM KE SERVICE - UPDATE BAGIAN INI
Future<void> _submitPayment() async {
  if (_imageFile == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pilih bukti bayar terlebih dahulu!'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  setState(() => _isLoading = true);

  try {
    // MEMANGGIL SERVICE UPLOAD
    bool isSuccess = await _pembayaranService.uploadBuktiBayar(
      widget.orderId, 
      _imageFile!
    );

    if (isSuccess && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pembayaran Pesanan ${widget.orderId} Berhasil Dikirim!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => StatusPesananPage()),
          );
        }
      });
    }
  } on SocketException {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tidak ada koneksi internet'),
        backgroundColor: Colors.red,
      ),
    );
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString().replaceAll('Exception: ', '')),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
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
        title: const Text('Pembayaran', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), 
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.white))
        : Center(
            child: SingleChildScrollView( 
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
                      Text(
                        'Scan QR Code\nID Pesanan: ${widget.orderId}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      
                      // QR CODE (TETAP SAMA)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(10), 
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 5),
                            ],
                          ),
                          child: const QrCodeImage(size: 150), 
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      const Text(
                        'Kirim Bukti Bayar',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      
                      // PREVIEW GAMBAR (MEMUDAHKAN UI)
                      if (_imageFile != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(_imageFile!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                      // INPUT PILIH FILE
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
                            Expanded(
                              child: Text(
                                _fileName ?? 'Belum ada file...',
                                style: TextStyle(color: _fileName == null ? Colors.grey : Colors.black, overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            InkWell(
                              onTap: _selectFile,
                              child: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text('Pilih File', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      ElevatedButton(
                        onPressed: _submitPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor, 
                          foregroundColor: Colors.white, 
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                        child: const Text('Kirim', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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