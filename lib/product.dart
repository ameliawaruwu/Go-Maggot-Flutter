import 'package:flutter/material.dart';
import 'keranjang.dart';
import 'main.dart'; 
import 'detail_produk.dart'; 
import 'komponen-navbar.dart'; 


class Product {
  final String name;
  final String price;
  final String imagePath;
  final String category; // PROPERTI BARU UNTUK FILTER

  Product({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.category, // HARUS DIISI
  });
}

// List data produk (DITAMBAH KATEGORI)
final List<Product> allProducts = [
  Product(name: "Bibit Maggot", price: "Rp 50.000", imagePath: "assets/Bibit-remove_bg.png", category: "Maggot"), 
  Product(name: "Maggot Siap Pakai", price: "Rp 70.000", imagePath: "assets/maggot_removebg.png", category: "Maggot"),
  Product(name: "Kompos Maggot (Pupuk Organik)", price: "Rp 25.000", imagePath: "assets/kompos_remove_bg.png", category: "Pupuk"), 
  Product(name: "Kandang Maggot", price: "Rp 75.000", imagePath: "assets/Kandang.png", category: "Kandang"),
  Product(name: "Paket Bundling Maggot Starter", price: "Rp 170.000", imagePath: "assets/Bundling_Maggot.png", category: "Maggot"), 
  Product(name: "Pupuk Cair Maggot", price: "Rp 40.000", imagePath: "assets/kompos_remove_bg.png", category: "Pupuk"), 
];


class ProductContent extends StatefulWidget {
  const ProductContent({super.key});

  @override
  State<ProductContent> createState() => _ProductContentState();
}

class _ProductContentState extends State<ProductContent> {
  // State untuk Kategori yang dipilih
  String selectedCategory = 'Maggot'; // Default saat pertama dibuka
  
  // Getter untuk menghasilkan list produk yang difilter
  List<Product> get _filteredProducts {
    return allProducts
        .where((product) => product.category == selectedCategory)
        .toList();
  }

  // Widget untuk tombol Kategori (SEKARANG INTERAKTIF)
  Widget _buildCategoryTab(BuildContext context, String title) {
    final isSelected = selectedCategory == title;
      return Expanded(
        child: GestureDetector( // Menambahkan GestureDetector
          onTap: () {
            setState(() {
              selectedCategory = title; // Update state kategori saat diklik
            });
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : const Color(0xFF688969), 
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isSelected ? Colors.green.shade800 : Colors.transparent),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.green.shade800 : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Warna latar belakang 
    const Color customGreenBg = Color(0xFF385E39);

    return Container(
      color: customGreenBg,
      child: Column(
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
                          // Menggunakan CartRoute yang sudah didefinisikan
                          Navigator.pushNamed(context, CartRoute);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Kategori Tabs
                Row(
                  children: [
                    _buildCategoryTab(context, 'Maggot'),
                    _buildCategoryTab(context, 'Pupuk'),
                    _buildCategoryTab(context, 'Kandang'),
                  ],
                ),
              ],
            ),
          ),

          // Grid Produk
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, 
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  // childAspectRatio disesuaikan agar kartu lebih kecil
                  childAspectRatio: 0.70, 
                ),
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: _filteredProducts[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  // State untuk status favorit (ikon love)
  bool isFavorite = false;

  // Fungsi untuk menampilkan Notifikasi (SnackBar) saat ditambah ke keranjang
  void _showCartNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} berhasil ditambahkan ke keranjang!'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

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
            Stack(
              children: [
                Center(
                  child: ClipRRect( 
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      widget.product.imagePath, 
                      // Tinggi gambar diperkecil
                      height: 80, 
                      fit: BoxFit.contain, 
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 80, 
                          color: Colors.red.shade100,
                          child: const Center(
                            child: Text('❌ GAGAL', textAlign: TextAlign.center, style: TextStyle(fontSize: 10)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  // Ikon Love interaktif
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            
            // Nama Produk
            Text(
              widget.product.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            // Harga
            Text(
              widget.product.price,
              style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),

            // Rating dan Tombol Detail/Add
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
                    // Tombol Detail
                    InkWell(
                      onTap: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (context) => ProductDetailPage(product: widget.product),
                           ),
                         );
                      },
                      child: const Text(
                        'Detail',
                        style: TextStyle(
                          color: Colors.black54, 
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    
                    // Tombol Add (+) interaktif
                    GestureDetector(
                      onTap: () => _showCartNotification(context), 
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 18),
                      ),
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