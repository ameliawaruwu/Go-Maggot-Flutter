import 'package:flutter/material.dart';
import 'qr-code.dart'; 

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
    if (_fileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih bukti bayar terlebih dahulu!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mengirim bukti bayar: $_fileName')),
      );
      debugPrint('Bukti bayar $_fileName dikirim.');
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
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
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
                      // Teks untuk menampilkan nama file atau placeholder
                      Text(
                        _fileName ?? '',
                        style: TextStyle(
                          color: _fileName == null ? Colors.grey : Colors.black,
                        ),
                      ),
                      // Tombol "choose file"
                      InkWell(
                        onTap: _selectFile,
                        child: const Text(
                          'choose file',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                // Teks "Lihat gambar"
                const Text(
                  'Lihat gambar',
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
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}