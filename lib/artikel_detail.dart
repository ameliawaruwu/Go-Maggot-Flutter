import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'models/artikel_model.dart';

class ArtikelDetailPage extends StatelessWidget {
  // 1. Tambahkan parameter untuk menerima data artikel
  final ArtikelModel artikel;

  const ArtikelDetailPage({super.key, required this.artikel});

  @override
  Widget build(BuildContext context) {
    // --- PALET WARNA ---
    const Color primaryDarkGreen = Color(0xFF385E39); // Hijau Tua
    const Color lightCardGreen = Color(0xFFE4EDE5);   // Hijau Pucat (Background)
    
    return Scaffold(
      backgroundColor: lightCardGreen, 
      
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. GAMBAR UTAMA (MENGGUNAKAN URL DARI API)
            Container(
              height: 250,
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade200,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  artikel.gambarUrl, // Menggunakan URL lengkap dari Laravel
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.broken_image, size: 80, color: Colors.grey),
                    );
                  },
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: primaryDarkGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          artikel.penulis,
                          style: const TextStyle(color: primaryDarkGreen, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        artikel.tanggal,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  Text(
                    artikel.judul,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryDarkGreen,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),

                  // 3. MENGGUNAKAN WIDGET HTML (AGAR KODE DIV/H4 TIDAK MUNCUL)
                 Html(
  data: artikel.konten,
  style: {
    "body": Style(
      fontSize: FontSize(16.0),
      textAlign: TextAlign.justify,
      lineHeight: LineHeight.em(1.6),
      // Gunakan .all(0) atau .zero sesuai yang tidak merah di editor Anda
      margin: Margins.all(0), 
      padding: HtmlPaddings.all(0),
    ),
    "h4": Style(
      color: const Color(0xFF385E39),
      fontWeight: FontWeight.bold,
    ),
  },
),
                  const SizedBox(height: 20),
                  Text(
                    "Sumber: ${artikel.hakCipta}",
                    style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}