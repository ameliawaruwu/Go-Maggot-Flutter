import 'package:flutter/material.dart';

class EdukasiPage extends StatelessWidget {
  const EdukasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    // --- PALET WARNA DARI FIGMA ---
    // Background menggunakan gradasi, jadi kita siapkan 2 warna
    final Color bgGradientTop = const Color(0xFF4A6653);    // Hijau bagian atas
    final Color bgGradientBottom = const Color(0xFF2C3E32); // Hijau bagian bawah (gelap)
    
    final Color limeText = const Color(0xFF7BBC38);         // Teks "Let's Learn!"
    final Color cardColor = const Color(0xFFF1F5EB);        // Background kartu artikel
    final Color buttonGreen = const Color(0xFF6AA336);      // Tombol "selengkapnya"
    final Color searchBarColor = const Color(0xFFD9D9D9);   // Warna abu kolom search

    return Scaffold(
      // Kita tidak pakai backgroundColor di sini karena akan ditimpa Container gradasi
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgGradientTop, bgGradientBottom],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HEADER (Search Bar + Notif)
                Row(
                  children: [
                    // Search Bar
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: searchBarColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: "",
                            prefixIcon: Icon(Icons.search, size: 28, color: Colors.black87),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    
                    // Icon Notifikasi (Circle)
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.notifications_none_outlined, color: Colors.white, size: 28),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // 2. TEKS SAMBUTAN
                const Text(
                  "Hai Gomma,",
                  style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Let’s Learn!",
                  style: TextStyle(fontSize: 24, color: limeText, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 25),

                // 3. VIDEO THUMBNAIL
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.black26, // Placeholder warna background
                    image: const DecorationImage(
                      // Pastikan file gambar ada di assets ya!
                      image: AssetImage('assets/images/video_thumbnail.png'), 
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    // Tombol Play Youtube Style
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white, // Sedikit border putih di belakang tombol merah
                        shape: BoxShape.circle, 
                      ),
                      padding: const EdgeInsets.all(2), // Ketebalan border putih
                      child: const Icon(Icons.play_circle_fill, color: Colors.red, size: 70),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // 4. DIVIDER "Artikel Kami"
                Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.white70, thickness: 1)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "Artikel Kami",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Expanded(child: Divider(color: Colors.white70, thickness: 1)),
                  ],
                ),
                const SizedBox(height: 20),

                // 5. GRID ARTIKEL
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.8, // Mengatur proporsi kartu (lebar vs tinggi)
                  ),
                  itemCount: 6, // Contoh 6 artikel
                  itemBuilder: (context, index) {
                    return _buildArticleCard(cardColor, buttonGreen);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      
      // Bottom Navigation Bar (Sesuai Desain)
      bottomNavigationBar: Container(
        color: const Color(0xFFF1F5EB), // Warna background nav bar
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, "Beranda", false),
            _buildNavItem(Icons.storefront_outlined, "Produk", false),
            _buildNavItem(Icons.chat_bubble_outline, "Komunitas", false),
            _buildNavItem(Icons.person_outline, "Profile", false),
            // Menu Edukasi Aktif (Icon filled & background gelap)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3325), // Hijau gelap icon aktif
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.menu_book, color: Colors.white),
                  Text("Edukasi", style: TextStyle(fontSize: 10, color: Colors.white))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET KARTU ARTIKEL
  Widget _buildArticleCard(Color cardBg, Color btnColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Artikel
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: AssetImage('assets/images/article_sample.png'), // Ganti asset
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          // Teks Deskripsi
          const Expanded(
            flex: 3,
            child: Text(
              "Maggot ini dapat dipakai untuk pakan hewan ternak loh!",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Tombol Selengkapnya (Pill Shape)
          SizedBox(
            height: 24,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: btnColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "selengkapnya",
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

 
  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 28, color: Colors.black87),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.black87)),
      ],
    );
  }
}