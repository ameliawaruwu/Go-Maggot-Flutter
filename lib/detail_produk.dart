import 'package:flutter/material.dart';
import 'keranjang.dart'; 
import 'chat_produk.dart';
// import 'checkout_page.dart'; // Di-komen sementara agar tidak error saat testing

import 'models/product_model.dart'; 
import 'cart_helper.dart'; 

const Color primaryDarkGreen = Color(0xFF385E39); 
const Color accentLightGreen = Color(0xFF6E9E4F); 
const Color lightCardGreen = Color(0xFFE4EDE5);    

class ProductDetailPage extends StatelessWidget {
  final ProdukModel product;

  const ProductDetailPage({super.key, required this.product});

  // MENGGUNAKAN SNACKBAR SEBAGAI PENGGANTI ALERT DIALOG
  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "${product.namaProduk} berhasil ditambah ke keranjang!",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: primaryDarkGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: "LIHAT",
          textColor: Colors.yellow,
          onPressed: () => Navigator.pushNamed(context, '/cart'),
        ),
      ),
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
        title: const Text("Detail Produk", style: TextStyle(color: Colors.white, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/cart'), 
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // --- GAMBAR UTAMA ---
            Center(
              child: Container(
                height: 220,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
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
                  Text(
                    product.namaProduk,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rp ${product.harga}", 
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryDarkGreen),
                      ),
                      const Text("5Rb Terjual", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text("Deskripsi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 5),
                  Text(product.deskripsiProduk, style: const TextStyle(color: Colors.black54)),

                  // --- TOMBOL BERI ULASAN (UNTUK TESTING) ---
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                   
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- INFO BOX ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryDarkGreen.withOpacity(0.9), 
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildInfoRow("Merk:", product.merk),
                  const SizedBox(height: 8),
                  _buildInfoRow("Stok :", "${product.stok}"),
                  const SizedBox(height: 8),
                  _buildInfoRow("Kategori:", product.kategori),
                  const SizedBox(height: 8),
                  _buildInfoRow("Berat:", product.berat),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // HEADER REVIEW
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text("Review Pelanggan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            _buildReviewItem("Santi", "Produk bersih, packagingnya juga rapih", product.gambarUrl),
            _buildReviewItem("Sinta", "Pengiriman cepat dan aman", product.gambarUrl),

            const SizedBox(height: 30),
          ],
        ),
      ),

      // --- BOTTOM BAR ---
      bottomNavigationBar: Container(
        height: 90, 
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatProdukPage())),
              icon: const Icon(Icons.chat_bubble_outline, color: primaryDarkGreen, size: 28),
            ),
            const VerticalDivider(width: 20, indent: 25, endIndent: 25),
            IconButton(
              onPressed: () => _showSuccessSnackBar(context), 
              icon: const Icon(Icons.add_shopping_cart, color: primaryDarkGreen, size: 28),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentLightGreen, 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                   // SEMENTARA DIKOMEN AGAR TIDAK ERROR SAAT TESTING FEEDBACK
                   /*
                   Navigator.push(
                     context,
                     MaterialPageRoute(
                       builder: (context) => CheckoutPage(product: product),
                     ),
                   );
                   */
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text("Fitur Checkout sedang dinonaktifkan untuk testing")),
                   );
                },
                child: const Text(
                  "Beli Sekarang",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
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

  Widget _buildReviewItem(String name, String comment, String? imgPath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(comment, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imgPath != null 
                ? Image.network(imgPath, width: 50, height: 50, fit: BoxFit.cover)
                : const Icon(Icons.account_circle, size: 50, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}