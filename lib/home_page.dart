import 'package:flutter/material.dart';
import 'komponen-navbar.dart'; // Pastikan ini ada
// import 'colors.dart'; // Aktifkan jika punya

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi Warna Lokal (Supaya aman jika colors.dart belum ada)
    const Color primaryDarkGreen = Color(0xFF385E39);
    const Color accentLightGreen = Color(0xFF6E9E4F);
    const Color secondaryTextColor = Colors.white;

    return Scaffold(
      backgroundColor: Colors.white,
      
      // --- APP BAR ---
      appBar: AppBar(
        backgroundColor: primaryDarkGreen,
        automaticallyImplyLeading: false, // Hilangkan tombol back di Home
        elevation: 0,
        toolbarHeight: 90, 
        flexibleSpace: Container(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
          decoration: const BoxDecoration(
            color: primaryDarkGreen,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo Teks
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 28, 
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Kaushan Script', 
                    color: accentLightGreen, 
                  ),
                  children: <TextSpan>[
                    TextSpan(text: 'Go'),
                    TextSpan(
                      text: 'Maggot',
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Kaushan Script', 
                      ),
                    ),
                  ],
                ),
              ),
              // Ikon Kanan
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.search, color: secondaryTextColor, size: 30),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none, color: secondaryTextColor, size: 30),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      
      // --- BODY ---
      // Langsung panggil konten beranda
      body: const HomeContent(),
      
      // --- BOTTOM NAVIGATION BAR ---
      // Perbaikan Line 68 ada di sini:
      // Kita set index 0 (Beranda) dan HAPUS onItemSelected
      bottomNavigationBar: const CustomBottomNavBar(
        indexSelected: 0, 
      ),
    );
  }
}

// === KONTEN BERANDA (DIPISAH SUPAYA RAPI) ===
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  // Warna Static untuk Class ini
  static const Color primaryDarkGreen = Color(0xFF385E39);
  static const Color accentLightGreen = Color(0xFF6E9E4F);
  static const Color secondaryTextColor = Colors.white; 
  static const Color primaryTextColor = Colors.black; 
  static const Color backgroundLightGreen = Color(0xFFE8F5E9); 
  static const Color cardColor = Colors.white; 

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildAboutMaggotSection(context),
            const SizedBox(height: 20),
            _buildTopProductsSection(context),
            const SizedBox(height: 20),
            _buildCultivationPromotion(context),
            const SizedBox(height: 20),
          ],
        ),
      );
  }

  Widget _buildAboutMaggotSection(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: backgroundLightGreen,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 3)),],
        ),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Gambar Maggot
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/maggot_removebg.png', 
                  width: 100, 
                  height: 100, 
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => const Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 15),
              // Deskripsi
              const Expanded(
                child: Text('Apa itu maggot?\nMaggot atau lebih sering disebut sebagai belatung, merupakan larva dari jenis lalat Black Soldier Fly (BSF).', 
                  style: TextStyle(fontSize: 14, color: primaryTextColor, height: 1.4,), 
                  textAlign: TextAlign.justify,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
      );
  }

  Widget _buildTopProductsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Produk Terlaris Bulan Ini!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryDarkGreen,),),
          const SizedBox(height: 15),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.0, 
            children: [
              _buildProductItem('assets/Bibit-remove_bg.png'), 
              _buildProductItem('assets/Bundling_Maggot.png'),
              _buildProductItem('assets/maggot_removebg.png'), 
              _buildProductItem('assets/kompos_remove_bg.png'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          imagePath, 
          fit: BoxFit.contain, // Contain agar gambar utuh
          errorBuilder: (ctx, err, stack) => const Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildCultivationPromotion(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: primaryDarkGreen,
        borderRadius: BorderRadius.circular(15),
        image: const DecorationImage(
          image: AssetImage('assets/bg.png'),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          opacity: 0.5,
        ),
      ),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Yuk budidaya maggot!', style: TextStyle(color: secondaryTextColor, fontSize: 22, fontWeight: FontWeight.bold,),),
                SizedBox(height: 5),
                Text('Mengenal lebih dalam seputar budidaya maggot yang mudah.', style: TextStyle(color: secondaryTextColor, fontSize: 14,), maxLines: 2, overflow: TextOverflow.ellipsis,),
                SizedBox(height: 40),
              ],
            ),
          ),
          Positioned(
            right: 15,
            bottom: 20,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: accentLightGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
              ),
              child: const Text('selengkapnya', style: TextStyle(color: secondaryTextColor, fontWeight: FontWeight.bold),),
            ),
          ),
        ],
      ),
    );
  }
}