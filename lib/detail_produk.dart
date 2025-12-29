import 'package:flutter/material.dart';
import 'keranjang.dart'; 
import 'main.dart'; 
import 'chat_produk.dart';
// IMPORT MODEL YANG BENAR
import 'models/product_model.dart'; 

const Color primaryDarkGreen = Color(0xFF385E39); 
const Color accentLightGreen = Color(0xFF6E9E4F); 
const Color lightCardGreen = Color(0xFFE4EDE5);    

class ProductDetailPage extends StatelessWidget {
  // GANTI DARI 'Product' KE 'ProdukModel'
  final ProdukModel product;

  const ProductDetailPage({super.key, required this.product});

  void _showSuccessAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: primaryDarkGreen, size: 50),
              const SizedBox(height: 10),
              const Text("Berhasil!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 5),
              // GANTI .name JADI .namaProduk
              Text("${product.namaProduk} telah masuk keranjang."),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK", style: TextStyle(color: primaryDarkGreen)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightCardGreen, 
      
      appBar: AppBar(
        backgroundColor: primaryDarkGreen, 
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Kembali", style: TextStyle(color: Colors.white, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              // Pastikan route ini ada di main.dart
              Navigator.pushNamed(context, '/cart'); 
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // --- GAMBAR UTAMA (DARI INTERNET) ---
            Center(
              child: Container(
                height: 220,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  // LOGIKA GAMBAR: Cek URL ada atau tidak
                  child: product.gambarUrl != null
                      ? Image.network(
                          product.gambarUrl!,
                          fit: BoxFit.contain,
                          errorBuilder: (ctx, err, stack) => const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                        )
                      : const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NAMA PRODUK
                  Text(
                    product.namaProduk, // Dari API
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Serif', color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // HARGA (Format Manual dari int ke String)
                      Text(
                        "Rp ${product.harga}", 
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const Text("5Rb Terjual", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- INFO BOX (DATA DARI API) ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryDarkGreen.withOpacity(0.9), 
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildInfoRow("Merk:", product.merk), // Dari API
                  const SizedBox(height: 8),
                  _buildInfoRow("Stok :", "${product.stok}"), // Dari API (int ke String)
                  const SizedBox(height: 8),
                  _buildInfoRow("Kategori:", product.kategori), // Dari API
                   const SizedBox(height: 8),
                  _buildInfoRow("Berat:", product.berat), // Dari API
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 4. HEADER REVIEW
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(child: Container(height: 1, color: Colors.black45)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Review", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Serif')),
                  ),
                  Expanded(child: Container(height: 1, color: Colors.black45)),
                ],
              ),
            ),

            // 5. LIST REVIEW
            // Kirim gambarUrl (bisa null) ke widget review
            _buildReviewItem("Santi", "Produk bersih, packagingnya juga rapih", product.gambarUrl),
            _buildReviewItem("Sinta", "Pengiriman cepat dan aman", product.gambarUrl),

            const SizedBox(height: 30),
          ],
        ),
      ),

      // --- BOTTOM BAR (TOMBOL AKSI) ---
      bottomNavigationBar: Container(
        height: 90, 
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          color: primaryDarkGreen, 
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Ikon Chat
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatProdukPage()),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 28),
            ),
            
            Container(width: 1, height: 40, color: Colors.white54),

            // Ikon Add Cart
            IconButton(
              onPressed: () => _showSuccessAlert(context),
              icon: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 28),
            ),

            Container(width: 1, height: 40, color: Colors.white54),

            // Tombol Beli Sekarang
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentLightGreen, 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                elevation: 2,
              ),
              onPressed: () {},
              child: const Text(
                "Beli Sekarang",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(width: 80, child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
        Expanded(child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 16), overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  // Update Widget Review untuk menerima String nullable (String?)
  Widget _buildReviewItem(String name, String comment, String? imgPath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
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
          // Gambar User/Produk Kecil di Kanan (Handle Null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imgPath != null 
                ? Image.network(imgPath, width: 60, height: 60, fit: BoxFit.cover)
                : const Icon(Icons.account_circle, size: 60, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}