import 'package:flutter/material.dart';
import 'komponen-navbar.dart'; // Import Navbar
import 'bantuan.dart'; // Import halaman Bantuan (pastikan file ini ada/dibuat)
// import 'faq.dart';     // Import halaman FAQ (pastikan file ini ada/dibuat)

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color darkGreenBg = const Color(0xFF385E39);  // Hijau tua background
    final Color lightGreenBtn = const Color(0xFF6C856C); // Hijau pudar untuk tombol Pesanan/Ulasan
    final Color whiteCard = const Color(0xFFFFFFFF);
    final Color darkButton = const Color(0xFF1B3022);    // Hijau gelap tombol Logout

    return Scaffold(
      backgroundColor: darkGreenBg, 
      
      // --- HEADER APPBAR ---
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Profil Saya", // Bahasa Indonesia
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false, 
      ),

      // --- BODY ---
      body: Column(
        children: [
          // 1. BAGIAN HEADER (Foto & Info User)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: Column(
              children: [
                // Baris Foto & Nama (POV SUDAH LOGIN)
                Row(
                  children: [
                    // Foto Profil Lingkaran
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white, 
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/profile_pic.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.person, size: 50, color: Colors.grey.shade400);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Teks Nama & Email (User Login)
                    Expanded( // Gunakan Expanded agar teks panjang tidak overflow
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Amelia Waruwu", // Nama User
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "amelia@student.telkomuniversity.ac.id", // Email User
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // Baris Tombol Pesanan & Ulasan (Bahasa Indonesia)
                Row(
                  children: [
                    Expanded(child: _buildHeaderButton("Pesanan", lightGreenBtn)),
                    const SizedBox(width: 15),
                    Expanded(child: _buildHeaderButton("Ulasan", lightGreenBtn)), 
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. BAGIAN BODY (Kartu Putih Melengkung)
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 30, left: 24, right: 24, bottom: 20),
              decoration: BoxDecoration(
                color: whiteCard,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // List Menu (Bahasa Indonesia & Navigasi)
                  _buildMenuItem(context, "Akun Saya", null), // null = belum ada halaman
                  _buildMenuItem(context, "Notifikasi", null),
                  _buildMenuItem(context, "Bahasa", null),
                  
                  // Menu dengan Navigasi Khusus
                  _buildMenuItem(context, "Bantuan", () {
                    // Navigasi ke Halaman Bantuan
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const BantuanPage())
                    );
                  }),
                  
                  _buildMenuItem(context, "FAQ", () {
                    // Navigasi ke Halaman FAQ
                    // Navigator.push(
                    //   context, 
                    //   MaterialPageRoute(builder: (context) => const FaqPage())
                    // );
                  }),

                  const Spacer(), 

                  // Tombol Keluar (Logout)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Logika Logout (Misal kembali ke LoginScreen)
                        Navigator.pushReplacementNamed(context, '/'); // Asumsi '/' adalah LoginRoute
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkButton,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("KELUAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 10), 
                ],
              ),
            ),
          ),
        ],
      ),

      // --- BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: const CustomBottomNavBar(
        indexSelected: 4, // Index 4 = Profil
      ),
    );
  }

  // WIDGET TOMBOL ATAS
  Widget _buildHeaderButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 0,
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  // WIDGET ITEM MENU (Dengan Navigasi)
  Widget _buildMenuItem(BuildContext context, String text, VoidCallback? onTap) {
    return InkWell( // Bungkus dengan InkWell agar bisa diklik
      onTap: onTap, 
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black12, width: 1), 
          ),
        ),
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B3022), 
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black87),
          ],
        ),
      ),
    );
  }
}