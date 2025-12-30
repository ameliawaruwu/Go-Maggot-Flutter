import 'package:flutter/material.dart';
import 'keranjang.dart'; 
import 'main.dart'; 
import 'chat_produk.dart';
import 'checkout_page.dart'; // Pastikan file checkout diimport
import 'models/product_model.dart'; 

class ProductDetailPage extends StatelessWidget {
  final ProdukModel product;

  const ProductDetailPage({super.key, required this.product});

  // WARNA TEMA
  static const Color primaryDarkGreen = Color(0xFF385E39); 
  static const Color accentLightGreen = Color(0xFF6E9E4F); 
  static const Color lightCardGreen = Color(0xFFE4EDE5);

  // Fungsi SnackBar untuk notifikasi keranjang
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
            
            // GAMBAR PRODUK DENGAN HANDLING ERROR
            Center(
              child: Container(
                height: 250,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: product.gambarUrl != null
                      ? Image.network(
                          Uri.encodeFull(product.gambarUrl!), 
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
                  Text(
                    "Rp ${product.harga}", 
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryDarkGreen),
                  ),
                  const SizedBox(height: 15),
                  const Text("Deskripsi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 5),
                  Text(
                    product.deskripsiProduk, 
                    style: const TextStyle(color: Colors.black54, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // INFO SPESIFIKASI DALAM KOTAK
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryDarkGreen, 
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildInfoRow("Merk:", product.merk),
                  const Divider(color: Colors.white24, height: 20),
                  _buildInfoRow("Stok :", "${product.stok}"),
                  const Divider(color: Colors.white24, height: 20),
                  _buildInfoRow("Kategori:", product.kategori),
                  const Divider(color: Colors.white24, height: 20),
                  _buildInfoRow("Berat:", product.berat),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      height: 85,
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
            icon: const Icon(Icons.chat_bubble_outline, color: primaryDarkGreen),
          ),
          const VerticalDivider(width: 20, indent: 25, endIndent: 25),
          IconButton(
            onPressed: () => _showSuccessSnackBar(context),
            icon: const Icon(Icons.add_shopping_cart, color: primaryDarkGreen),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryDarkGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(vertical: 15),
                elevation: 0,
              ),
              onPressed: () {
                // Berpindah ke CheckoutPage dengan parameter product yang didefinisikan
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutPage(Product: product),
                  ),
                );
              },
              child: const Text("Beli Sekarang", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 80, 
          child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14))
        ),
        Expanded(
          child: Text(
            value, 
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)
          )
        ),
      ],
    );
  }
}