import 'package:flutter/material.dart';
import 'main.dart';
import 'product.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int indexSelected;

  const CustomBottomNavBar({
    super.key,
    required this.indexSelected,
  });

  void _onNavBarTap(BuildContext context, int index) {
    if (index == indexSelected) return;

    switch (index) {
      case 0: 
        Navigator.pushReplacementNamed(context, HomeRoute);
        break;

      case 1: 
        Navigator.pushReplacementNamed(context, ProductRoute);
        break;

      case 2: 
        Navigator.pushNamed(context, ForumRoute);
        break;

      case 3: 
        Navigator.pushReplacementNamed(context, EdukasiRoute);
        break;

      case 4: // Profil
        Navigator.pushReplacementNamed(context, ProfileRoute);
        break;
    }
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
  ) {
    final isSelected = index == indexSelected;
    const selectedColor = Color(0xFF6B8E23); // hijau olive
    const unselectedColor = Colors.grey;

    return InkWell(
      onTap: () => _onNavBarTap(context, index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? selectedColor : unselectedColor,
              size: 24,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? selectedColor : unselectedColor,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryDarkGreen = Color(0xFF2C4A34);

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: primaryDarkGreen,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3),
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
