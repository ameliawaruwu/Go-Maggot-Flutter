import 'package:flutter/material.dart';

class ArtikelDetailPage extends StatelessWidget {
  const ArtikelDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // --- PALET WARNA ---
    const Color primaryDarkGreen = Color(0xFF385E39); // Hijau Tua
    const Color lightCardGreen = Color(0xFFE4EDE5);   // Hijau Pucat (Background)
    
    return Scaffold(
      backgroundColor: lightCardGreen, // Background Hijau Pucat
      
      // --- HEADER ---
      appBar: AppBar(
        backgroundColor: primaryDarkGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Detail Artikel",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // Lengkungan bawah header
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // Fitur share nanti
            },
          ),
        ],
      ),

      // --- BODY ---
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. GAMBAR UTAMA
            Container(
              height: 250,
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade300, // Placeholder
                // image: const DecorationImage(image: AssetImage('assets/images/article_sample.png'), fit: BoxFit.cover,),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: const Center(
                  child: Icon(Icons.image, size: 80, color: Colors.grey),
                ),
              ),
            ),

            // 2. KONTEN TEKS
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tanggal & Kategori
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: primaryDarkGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Tips Budidaya",
                          style: TextStyle(color: primaryDarkGreen, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "12 Juni 2025",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Judul Artikel
                  const Text(
                    "Manfaat Maggot BSF untuk Pakan Ternak",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryDarkGreen,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Isi Artikel (Dummy Text)
                  const Text(
                    "Maggot BSF (Black Soldier Fly) kini semakin populer di kalangan peternak sebagai alternatif pakan yang kaya protein. Tidak hanya murah, maggot juga mudah dibudidayakan di rumah dengan memanfaatkan limbah organik.\n\n"
                    "Kandungan protein pada maggot bisa mencapai 40-50%, yang sangat baik untuk pertumbuhan ayam, ikan, dan bebek. Selain itu, penggunaan maggot dapat menekan biaya pakan pabrikan yang semakin mahal.\n\n"
                    "Cara budidaya maggot pun terbilang sederhana. Anda hanya perlu menyiapkan kandang lalat BSF, media penetasan telur, dan biopond untuk pembesaran larva. Makanannya pun gratis, cukup sisa sayuran atau buah busuk dari dapur Anda!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.6, // Jarak antar baris agar enak dibaca
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 40), // Spasi bawah
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}