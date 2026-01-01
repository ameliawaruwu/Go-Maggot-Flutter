import 'package:flutter/material.dart';
import 'bantuan.dart'; 
import 'faq_page.dart'; 
import '../utils/session_helper.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  // Menggunakan Map<String, String> sesuai dengan return dari SessionHelper.getUser()
  Map<String, String>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fungsi mengambil data profil
  Future<void> _loadUserData() async {
    // Memanggil getUser() yang sudah diperbaiki untuk mengambil username dan email
    final data = await SessionHelper.getUser();
    if (mounted) {
      setState(() {
        userData = data;
        isLoading = false;
      });
    }
  }

  void _handleLogout(BuildContext context) async {
    await SessionHelper.logout();
    if (context.mounted) {
      // Mengarahkan ke login dan menghapus semua history navigasi
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      
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
    const Color darkGreenBg = Color(0xFF385E39);
    const Color lightGreenBtn = Color(0xFF6C856C);
    const Color whiteCard = Color(0xFFFFFFFF);
    const Color darkButton = Color(0xFF1B3022);

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
      body: isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.white))
        : Column(
            children: [
              // 1. HEADER (Info User Dinamis)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 80, height: 80,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                          child: ClipOval(
                            child: (userData?['foto_profil'] != null && userData?['foto_profil'] != '')
                                ? Image.network(
                                    // Menggunakan IP Server sesuai log aplikasi
                                    "http://10.121.188.89:8000/photo/${userData!['foto_profil']}",
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => const Icon(Icons.person, size: 50, color: Colors.grey),
                                  )
                                : Image.asset('assets/profile_pic.png', fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Username Dinamis
                              Text(
                                userData?['username'] ?? "Guest",
                                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)
                              ),
                              const SizedBox(height: 5),
                              // Email Dinamis
                              Text(
                                userData?['email'] ?? "No Email Available",
                                style: const TextStyle(color: Colors.white70, fontSize: 12)
                              ),
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
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _handleLogout(context),
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