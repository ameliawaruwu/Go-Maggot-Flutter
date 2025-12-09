// lib/qr-code.dart

import 'package:flutter/material.dart';

class QrCodeImage extends StatelessWidget {
  final double size;
  // Definisikan path gambar asset di sini
  final String assetPath; 

  const QrCodeImage({
    super.key, 
    this.size = 200, 
    // Ganti 'assets/my_qr_code.png' dengan path file QR Code Anda
    this.assetPath = 'assets/Qris_GoMaggot.png', 
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      // Menggunakan Image.asset untuk memuat gambar dari assets
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain, // Sesuaikan ukuran gambar di dalam box
        // Anda mungkin ingin menambahkan placeholder jika gambar tidak ditemukan
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.red.shade100,
            child: const Center(
              child: Text("QR Code Error", style: TextStyle(color: Colors.red)),
            ),
          );
        },
      ),
    );
  }
}