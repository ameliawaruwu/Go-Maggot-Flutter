import 'package:flutter/material.dart';
import 'komponen-navbar.dart'; 
import 'keranjang.dart';
import 'main.dart'; 
import 'detail_produk.dart'; // <--- SAYA TAMBAHKAN INI AGAR BISA PINDAH HALAMAN

class Product {
  final String name;
  final String price;
  final String imagePath;

  Product({
    required this.name,
    required this.price,
    required this.imagePath,
  });
}

// List data produk
final List<Product> products = [
  Product(name: "Bibit Maggot", price: "Rp 50.000", imagePath: "assets/Bibit-remove_bg.png"), 
  Product(name: "Maggot Siap Pakai", price: "Rp 70.000", imagePath: "assets/maggot_removebg.png"),
  Product(name: "Kompos Maggot", price: "Rp 25.000", imagePath: "assets/kompos_remove_bg.png"),
  Product(name: "Kandang Maggot", price: "Rp 75.000", imagePath: "assets/Kandang.png"),
  Product(name: "Paket Bundling Maggot", price: "Rp 170.000", imagePath: "assets/Bundling_Maggot.png"), 
  Product(name: "Kompos Maggot", price: "Rp 25.000", imagePath: "assets/kompos_remove_bg.png"), 
];

// Halaman Utama Produk 
class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  // Widget untuk tombol Kategori (Maggot, Kandang, Pupuk) 
  Widget _buildCategoryTab(BuildContext context, String title, bool isSelected) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.green.shade800 : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Warna latar belakang 
    const Color customGreenBg = Color(0xFFA5C6A0);

    return Scaffold(
      backgroundColor: customGreenBg,
      
      appBar: AppBar(
        toolbarHeight: 0, 
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Column(
        children: [
          // Bagian Judul dan Search Bar
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Ayo Pilih Maggotmu!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    // Search Bar
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Cari...',
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search, color: Colors.black54),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Shopping Cart Icon
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.shopping_cart, color: Colors.white, size: 30),
                        onPressed: () {
                          Navigator.pushNamed(context, CartRoute);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Tab Kategori
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategoryTab(context, 'Maggot', true),
                _buildCategoryTab(context, 'Kandang', false),
                _buildCategoryTab(context, 'Pupuk', false),
              ],
            ),
          ),
          
          // Grid Produk 
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
              decoration: const BoxDecoration(
                // Warna latar belakang yang lebih terang untuk area produk
                color: Color(0xFFE8F0E4), 
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75, 
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: products[index]);
                },
              ),
            ),
          ),
          
          // Bottom Navigation Bar
          CustomBottomNavBar(
            indexSelected: 1, // Cukup kasih tau ini halaman index ke-1 (Produk)
          ),
        ],
      ),
    );
  }
}


// Widget Kartu Produk
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk dan Tombol Favorite
            Stack(
              children: [
                Center(
                  child: ClipRRect( 
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      product.imagePath, 
                      height: 100,
                      fit: BoxFit.contain, 
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 100,
                          color: Colors.red.shade100,
                          child: const Center(
                            child: Text('❌ GAGAL MUAT GAMBAR', textAlign: TextAlign.center, style: TextStyle(fontSize: 10)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(Icons.favorite_border, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 5),
            
            // Nama Produk
            Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            // Harga
            Text(
              product.price,
              style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),

            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const Text('5.0', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Row(
                  children: [
                    // --- TOMBOL DETAIL (DIEDIT DI SINI) ---
                    InkWell(
                      onTap: () {
                         // Logika Pindah Halaman
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (context) => ProductDetailPage(product: product),
                           ),
                         );
                      },
                      child: const Text(
                        'Detail',
                        style: TextStyle(
                            color: Colors.black54, 
                            fontSize: 12,
                            fontWeight: FontWeight.bold, // Saya tambahkan bold sedikit agar enak dilihat
                            decoration: TextDecoration.underline // Garis bawah penanda link
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    // Tombol Add (+)
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.green.shade700,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 18),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}