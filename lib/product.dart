import 'package:flutter/material.dart';
import 'keranjang.dart'; 
import 'detail_produk.dart'; 

// 1. IMPORT MODEL
import 'models/product_model.dart'; 

// 2. IMPORT SERVICE
import '../services/product_service.dart'; 

class ProductContent extends StatefulWidget {
  const ProductContent({super.key});

  @override
  State<ProductContent> createState() => _ProductContentState();
}

class _ProductContentState extends State<ProductContent> {
  List<ProdukModel> _allProducts = []; 
  bool _isLoading = true; 

  String selectedCategory = 'BSF'; 
  String searchQuery = ''; 
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProducts(); 
  }

  Future<void> _fetchProducts() async {
    try {
      List<ProdukModel> data = await ProdukService().getAllProducts();
      
      if (mounted) { 
        setState(() {
          _allProducts = data;
          _isLoading = false; 
        });
        
        // DEBUG: Cek kategori DAN gambar
        print("========================================");
        print("✅ DATA MASUK: ${_allProducts.length} produk");
        print("========================================");
        for (var p in _allProducts) {
          print("📦 Produk: ${p.namaProduk}");
          print("   ├─ Kategori: '${p.kategori}'");
          print("   ├─ gambarUrl: ${p.gambarUrl ?? 'NULL'}");
          print("   └─ gambar: ${p.gambar ?? 'NULL'}");
          print("---");
        }
        print("========================================");
      }
    } catch (e) {
      print("❌ Error ambil data di UI: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<ProdukModel> get _filteredProducts {
    return _allProducts.where((product) {
      String katDb = product.kategori.toLowerCase().trim();
      String katTab = selectedCategory.toLowerCase().trim();
      String nama = product.namaProduk.toLowerCase();
      String cari = searchQuery.toLowerCase();

      bool matchCategory = katDb == katTab;
      bool matchSearch = nama.contains(cari);

      return matchCategory && matchSearch;
    }).toList();
  }

  Widget _buildCategoryTab(BuildContext context, String title) {
    final isSelected = selectedCategory == title;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCategory = title;
          });
          print("👉 Pindah ke Kategori: $title");
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
              fontSize: title.length > 10 ? 12 : 14,
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
    const Color customGreenBg = Color(0xFF385E39);

    return Container(
      color: customGreenBg,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Ayo Pilih Maggotmu!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) => setState(() => searchQuery = value),
                          decoration: const InputDecoration(
                            hintText: 'Cari...',
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search, color: Colors.black54),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                        icon: const Icon(Icons.shopping_cart, color: Colors.white, size: 30),
                        onPressed: () => Navigator.pushNamed(context, '/cart'), 
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                Row(
                  children: [
                    _buildCategoryTab(context, 'BSF'),
                    _buildCategoryTab(context, 'Kandang Maggot'),
                    _buildCategoryTab(context, 'Kompos'),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _isLoading 
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : _filteredProducts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.search_off, size: 50, color: Colors.white70),
                              const SizedBox(height: 10),
                              Text(
                                "Belum ada produk di kategori '$selectedCategory'.\nCek penulisan di Database.", 
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: EdgeInsets.zero,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
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

// --- PRODUCT CARD dengan DEBUG GAMBAR LENGKAP ---
class ProductCard extends StatefulWidget {
  final ProdukModel product; 

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;

  void _showCartNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.namaProduk} masuk keranjang!'),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

  Widget _buildProductImage() {
    print("🖼️ Rendering gambar untuk: ${widget.product.namaProduk}");
    
    // Prioritas 1: Cek gambarUrl
    if (widget.product.gambarUrl != null && widget.product.gambarUrl!.isNotEmpty) {
      final url = widget.product.gambarUrl!;
      print("   ✅ Menggunakan gambarUrl: $url");
      
      return Image.network(
        url,
        height: 80,
        width: 80,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            print("   ✅ Gambar berhasil dimuat: ${widget.product.namaProduk}");
            return child;
          }
          return Container(
            height: 80,
            width: 80,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.green,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print("   ❌ ERROR loading gambar: ${widget.product.namaProduk}");
          print("   ❌ Error detail: $error");
          print("   ❌ URL: $url");
          return Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red[200]!, width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, size: 30, color: Colors.red[300]),
                SizedBox(height: 4),
                Text('Error', style: TextStyle(fontSize: 9, color: Colors.red[600])),
              ],
            ),
          );
        },
      );
    }
    
    // Prioritas 2: Cek gambar (fallback)
    if (widget.product.gambar != null && widget.product.gambar!.isNotEmpty) {
      final url = widget.product.gambar!;
      print("   ⚠️ gambarUrl NULL, mencoba field 'gambar': $url");
      
      return Image.network(
        url,
        height: 80,
        width: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print("   ❌ Field 'gambar' juga error: $error");
          return _buildNoImagePlaceholder();
        },
      );
    }
    
    // Jika semua NULL
    print("   ❌ Tidak ada URL gambar sama sekali untuk: ${widget.product.namaProduk}");
    return _buildNoImagePlaceholder();
  }

  Widget _buildNoImagePlaceholder() {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, size: 30, color: Colors.grey[400]),
          SizedBox(height: 4),
          Text('No Image', style: TextStyle(fontSize: 9, color: Colors.grey[600])),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String hargaFormatted = "Rp ${widget.product.harga}";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
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
                    child: _buildProductImage(),
                  ),
                ),
                Positioned(
                  top: 0, right: 0,
                  child: GestureDetector(
                    onTap: () => setState(() => isFavorite = !isFavorite),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border, 
                      color: isFavorite ? Colors.red : Colors.grey.shade600
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              widget.product.namaProduk, 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), 
              maxLines: 2, 
              overflow: TextOverflow.ellipsis
            ),
            Text(
              hargaFormatted, 
              style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 14), 
                    Text('5.0', style: TextStyle(fontSize: 12))
                  ]
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(product: widget.product)
                          )
                        );
                      },
                      child: const Text(
                        'Detail', 
                        style: TextStyle(
                          color: Colors.black54, 
                          fontSize: 12, 
                          fontWeight: FontWeight.bold, 
                          decoration: TextDecoration.underline
                        )
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => _showCartNotification(context),
                      child: Container(
                        width: 24, 
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.green.shade700, 
                          borderRadius: BorderRadius.circular(5)
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