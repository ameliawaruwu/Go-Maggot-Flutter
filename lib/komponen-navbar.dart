import 'package:flutter/material.dart';
import 'main.dart'; // PENTING: Import ini agar ProductRoute & ProfileRoute dikenali

class CustomBottomNavBar extends StatelessWidget {
  final int indexSelected;

  const CustomBottomNavBar({
    super.key,
    required this.indexSelected,
  });

  // Fungsi Internal untuk Menangani Navigasi
  void _onNavBarTap(BuildContext context, int index) {
    // 1. Cek: Jika menekan tombol halaman yang sedang aktif, jangan lakukan apa-apa
    if (index == indexSelected) return;

    // 2. Logika Pindah Halaman
    switch (index) {
      case 0:
        // Beranda
        print("Ke Beranda"); 
        // Navigator.pushReplacementNamed(context, '/home'); // Aktifkan jika sudah ada
        break;
      
      case 1:
        // Produk
        // Gunakan pushReplacementNamed agar halaman tidak menumpuk
        Navigator.pushReplacementNamed(context, ProductRoute);
        break;
      
      case 2:
        // Komunitas
        print("Ke Komunitas");
        break;

      case 3:
        // Profile
        // Gunakan pushReplacementNamed agar user tidak bisa 'Back' bolak-balik antara Produk & Profil
        print("Ke Profil");
        break;
       
      
      case 4:
        // Edukasi
       Navigator.pushReplacementNamed(context, ProfileRoute);
        break;
    }
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index) {
    final isSelected = index == indexSelected;
    
    return InkWell(
      onTap: () => _onNavBarTap(context, index), // Panggil fungsi internal di atas
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.green.shade700 : Colors.black54,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.green.shade700 : Colors.black54,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, Icons.home_outlined, 'Beranda', 0),
          _buildNavItem(context, Icons.store, 'Produk', 1),
          _buildNavItem(context, Icons.chat_bubble_outline, 'Komunitas', 2),
          _buildNavItem(context, Icons.menu_book_outlined, 'Edukasi', 3),
          _buildNavItem(context, Icons.person_outline, 'Profil', 4),
        ],
      ),
    );
  }
}