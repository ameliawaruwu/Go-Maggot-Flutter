import 'package:flutter/material.dart';
import 'product.dart'; // Pastikan file ini ada
import 'keranjang.dart'; // Agar CartRoute dikenali
import 'main.dart'; 
import 'chat_produk.dart'; // <--- Import Halaman Chat Produk

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  // Fungsi Alert Berhasil Masuk Keranjang
  void _showSuccessAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 50),
              const SizedBox(height: 10),
              const Text("Berhasil!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 5),
              Text("${product.name} telah masuk keranjang."),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Definisi Warna sesuai Desain Gambar
    const Color darkGreen = Color(0xFF5F7155); // Hijau tentara (Header & Box Info)
    const Color lightBg = Color(0xFFE3E9D8);   // Background krem kehijauan
    const Color btnGreen = Color(0xFF6A9E25);  // Hijau cerah untuk tombol Beli

    return Scaffold(
      backgroundColor: lightBg,
      
      // --- 1. HEADER (AppBar) ---
      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Kembali", style: TextStyle(color: Colors.white, fontSize: 18)),
        actions: [
          // --- NAVIGASI KE KERANJANG (Header) ---
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, CartRoute);
            },
          ),
        ],
      ),

      // --- 2. KONTEN (Body) ---
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Gambar Produk
            Center(
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  // Efek bayangan halus di bawah gambar
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ]
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    product.imagePath,
                    height: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, err, stack) => const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Judul dan Harga
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Serif'),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.price,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text("5Rb Terjual", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Kotak Info Hijau (Merk, Stok, Jenis)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: darkGreen, // Warna hijau gelap
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildInfoRow("Merk:", "GoMaggot"),
                  const SizedBox(height: 8),
                  _buildInfoRow("Stok :", "3kg"),
                  const SizedBox(height: 8),
                  _buildInfoRow("Jenis:", "Maggot"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Header Review
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(child: Container(height: 1, color: Colors.black45)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Review", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Serif')),
                  ),
                  Expanded(child: Container(height: 1, color: Colors.black45)),
                ],
              ),
            ),

            // List Review
            _buildReviewItem("Santi", "Produk bersih, packagingnya juga rapih", product.imagePath),
            _buildReviewItem("Sinta", "Produk bersih, packagingnya juga rapih", product.imagePath),

            const SizedBox(height: 30),
          ],
        ),
      ),

      // --- 3. BOTTOM BAR (Tombol Aksi) ---
      bottomNavigationBar: Container(
        height: 80, 
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: darkGreen,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // --- EDIT: TOMBOL CHAT (SUDAH AKTIF) ---
            IconButton(
              onPressed: () {
                // Pindah ke Halaman Chat Produk
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatProdukPage()),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 28),
            ),
            
            // Garis Pemisah (Aman dari error layar hijau)
            Container(width: 1, height: 40, color: Colors.white54),

            // Icon Add Cart (Alert)
            IconButton(
              onPressed: () => _showSuccessAlert(context),
              icon: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 28),
            ),

            // Garis Pemisah 2
            Container(width: 1, height: 40, color: Colors.white54),

            // Tombol Beli Sekarang
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: btnGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              ),
              onPressed: () {},
              child: const Text(
                "Beli Sekarang",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Kecil untuk Baris Info
  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(width: 80, child: Text(label, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16))),
        Text(value, style: const TextStyle(color: Colors.black87, fontSize: 16)),
      ],
    );
  }

  // Widget Kecil untuk Review
  Widget _buildReviewItem(String name, String comment, String imgPath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05), // Warna abu transparan
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 14),
                    Icon(Icons.star, color: Colors.amber, size: 14),
                    Icon(Icons.star, color: Colors.amber, size: 14),
                    Icon(Icons.star, color: Colors.amber, size: 14),
                    Icon(Icons.star_border, color: Colors.amber, size: 14),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(imgPath, width: 50, height: 50, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}