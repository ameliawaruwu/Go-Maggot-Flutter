import 'package:flutter/material.dart';
import 'bantuan.dart'; 
import 'faq_page.dart'; 

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    // --- PALET WARNA (Sesuai Kode Awal) ---
    final Color darkGreenBg = const Color(0xFF385E39);   // Hijau tua background
    final Color lightGreenBtn = const Color(0xFF6C856C); // Hijau pudar untuk tombol
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
          "Profil Saya",
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
                // Baris Foto & Nama
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
                          'assets/profile_pic.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Teks Nama & Email
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Riri",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "riri@example.gmail.com",
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

                // Baris Tombol Pesanan & Ulasan
                Row(
                  children: [
                    Expanded(
                      child: _buildHeaderButton("Pesanan", lightGreenBtn),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildHeaderButton("Ulasan", lightGreenBtn),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. BAGIAN BODY (Kartu Putih Melengkung)
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                top: 30,
                left: 24,
                right: 24,
                bottom: 20,
              ),
              decoration: BoxDecoration(
                color: whiteCard,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // List Menu
                  _buildMenuItem(context, "Akun Saya", null),
                  _buildMenuItem(context, "Notifikasi", null),
                  _buildMenuItem(context, "Bahasa", null),

                  // Menu dengan Navigasi Khusus
                  _buildMenuItem(context, "Bantuan", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BantuanPage(),
                      ),
                    );
                  }),

                  _buildMenuItem(context, "FAQ", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FAQPage(),
                      ),
                    );
                  }),

                  const Spacer(),

                  // Tombol Keluar (Logout)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Kembali ke halaman Login (Route '/')
                        // pushNamedAndRemoveUntil agar tidak bisa kembali ke profil setelah logout
                        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkButton,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "KELUAR",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
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

  // WIDGET ITEM MENU
  Widget _buildMenuItem(
    BuildContext context,
    String text,
    VoidCallback? onTap,
  ) {
    return InkWell(
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
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }
}