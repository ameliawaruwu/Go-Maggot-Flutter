import 'package:flutter/material.dart';
import 'feedback.dart';

// Pastikan import halaman-halaman yang diperlukan (misal: HomeRoute dari main.dart)
// import 'main.dart'; 

class StatusPesananPage extends StatelessWidget {
  const StatusPesananPage({super.key});

  @override
  Widget build(BuildContext context) {
    // --- PALET WARNA (Sesuai Detail Produk) ---
    const Color primaryDarkGreen = Color(0xFF385E39); // Hijau Tua
    const Color lightCardGreen = Color(0xFFE4EDE5);   // Hijau Pucat (Background)
    const Color accentLightGreen = Color(0xFF6E9E4F); // Hijau Aksen
    const Color greyColor = Color(0xFF888888);        // Abu-abu

    return Scaffold(
      backgroundColor: lightCardGreen, // Background Hijau Pucat

      // --- HEADER ---
      appBar: AppBar(
        backgroundColor: primaryDarkGreen, // Header Hijau Tua
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () {
             // Navigasi kembali ke Beranda atau halaman sebelumnya
             // Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false); 
             // Atau sekadar pop jika stack-nya benar:
             Navigator.pop(context); 
          },
        ),
        title: const Text(
          "Status Pesanan",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),

      // --- BODY ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // 1. Kotak Judul Status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: primaryDarkGreen.withOpacity(0.9), // Hijau Tua sedikit transparan
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Ini Status Pesanan Kamu!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 2. Detail Pesanan
            Container(
               padding: const EdgeInsets.all(20),
               decoration: BoxDecoration(
                 color: Colors.white, // Kartu putih agar kontras
                 borderRadius: BorderRadius.circular(15),
               ),
               child: Column(
                 children: [
                    _buildDetailRow("ID Pesanan", "33", primaryDarkGreen),
                    _buildDetailRow("Nama Penerima", "Aeltforries", primaryDarkGreen),
                    _buildDetailRow("Alamat Pengiriman", "Jl. Cinta, Jakarta", primaryDarkGreen),
                    _buildDetailRow("Tanggal Pesanan", "2025-06-12 14:51:29", primaryDarkGreen),
                    _buildDetailRow("Total Harga", "Rp. 70.000", primaryDarkGreen),
                    _buildDetailRow("Metode Pembayaran", "Qris", primaryDarkGreen),
                 ],
               ),
            ),
            const SizedBox(height: 40),

            // 3. Status Tracker (Stepper)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStepItem(Icons.check, "Di Kemas", true, primaryDarkGreen, greyColor),
                  Expanded(child: Container(height: 2, color: primaryDarkGreen)), // Garis aktif
                  _buildStepItem(Icons.check, "Di Kirim", false, primaryDarkGreen, greyColor),
                  Expanded(child: Container(height: 2, color: greyColor)), // Garis belum aktif
                  _buildStepItem(Icons.check, "Sudah Sampai", false, primaryDarkGreen, greyColor),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // 4. Tombol Aksi
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Kembali ke Beranda (Ganti '/home' dengan nama route Home kamu)
                      // Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryDarkGreen, // Hijau Tua
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text(
                      "KEMBALI KE\nBERANDA",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greyColor, // Abu-abu
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text(
                      "REFRESH\nSTATUS",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

             // 5. Tombol BERI FEEDBACK
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FeedbackPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8FA88F),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text(
                  "BERI FEEDBACK",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper: Baris Detail
  Widget _buildDetailRow(String label, String value, Color labelColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130, 
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: labelColor, // Teks Label Hijau Tua
                fontSize: 14,
              ),
            ),
          ),
          const Text(": ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper: Lingkaran Step
  Widget _buildStepItem(IconData icon, String label, bool isActive, Color activeColor, Color inactiveColor) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isActive ? activeColor : inactiveColor,
          ),
        ),
      ],
    );
  }
}