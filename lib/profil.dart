import 'package:flutter/material.dart';
import 'bantuan.dart'; 
import 'faq_page.dart'; 
import '../utils/session_helper.dart'; // Pastikan import helper ini

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  // --- FUNGSI LOGOUT ---
  void _handleLogout(BuildContext context) async {
    // 1. Hapus token dan data sesi di penyimpanan lokal
    await SessionHelper.logout();

    // 2. Navigasi ke halaman Login (Route '/') dan hapus semua history halaman
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      
      // Berikan feedback visual bahwa logout berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Berhasil keluar, silakan login kembali."),
          backgroundColor: Color(0xFF385E39),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color darkGreenBg = const Color(0xFF385E39);
    final Color lightGreenBtn = const Color(0xFF6C856C);
    final Color whiteCard = const Color(0xFFFFFFFF);
    final Color darkButton = const Color(0xFF1B3022);

    return Scaffold(
      backgroundColor: darkGreenBg,
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
      ),
      body: Column(
        children: [
          // 1. HEADER (Info User)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
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
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 50, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Riri", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Text("riri@example.gmail.com", style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
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

          // 2. BODY (Menu List)
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
              decoration: BoxDecoration(
                color: whiteCard,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  _buildMenuItem(context, "Akun Saya", null),
                  _buildMenuItem(context, "Notifikasi", null),
                  _buildMenuItem(context, "Bahasa", null),
                  _buildMenuItem(context, "Bantuan", () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BantuanPage()))),
                  _buildMenuItem(context, "FAQ", () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FAQPage()))),

                  const Spacer(),

                  // --- TOMBOL KELUAR (LOGOUT) ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _handleLogout(context), // Memanggil fungsi logout
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkButton,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
    );
  }

  // WIDGET HELPERS (Tombol Atas & Menu Item Tetap Sama)
  Widget _buildHeaderButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(backgroundColor: color, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
    );
  }

  Widget _buildMenuItem(BuildContext context, String text, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12))),
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B3022))),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black87),
          ],
        ),
      ),
    );
  }
}