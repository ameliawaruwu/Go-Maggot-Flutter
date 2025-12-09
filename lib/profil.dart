import 'package:flutter/material.dart';
import 'komponen-navbar.dart'; // <--- PENTING: Import Navbar agar muncul di bawah

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color darkGreenBg = const Color(0xFF2C4A34);  // Hijau tua background
    final Color lightGreenBtn = const Color(0xFF6C856C); // Hijau pudar untuk tombol Orders/Reviews
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
          "My Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false, 
      ),

      // --- BODY ---
      body: Column(
        children: [
          // 1. BAGIAN HEADER (Foto & Tombol Atas)
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
                        color: Colors.white, // Warna dasar jika gambar gagal muat
                      ),
                      // Menggunakan ClipOval agar gambar benar-benar bulat
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/profile_pic.png',
                          fit: BoxFit.cover,
                          // Error Builder: Jika gambar tidak ditemukan, tampilkan ikon orang
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.person, size: 50, color: Colors.grey.shade400);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Teks Login/Register
                    const Text(
                      "Login/Register",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // Baris Tombol Orders & Reviews
                Row(
                  children: [
                    Expanded(child: _buildHeaderButton("Orders", lightGreenBtn)),
                    const SizedBox(width: 15),
                    Expanded(child: _buildHeaderButton("Reviews", lightGreenBtn)), 
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
                  // List Menu
                  _buildMenuItem("Account"),
                  _buildMenuItem("Notifications"),
                  _buildMenuItem("Language"),
                  _buildMenuItem("Help"),
                  _buildMenuItem("FAQ"),

                  const Spacer(), // Mendorong tombol ke bawah

                  // Tombol Logout & Add Account
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkButton,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("LOGOUT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkButton,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("Add Account", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10), 
                ],
              ),
            ),
          ),
        ],
      ),

      
      bottomNavigationBar: const CustomBottomNavBar(
        indexSelected: 4, 
      ),
    );
  }

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

  // WIDGET ITEM MENU (Account, Notif, dll)
  Widget _buildMenuItem(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black12, width: 1), // Garis bawah tipis
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
              color: Color(0xFF1B3022), // Hijau sangat gelap (hampir hitam)
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black87),
        ],
      ),
    );
  }
}