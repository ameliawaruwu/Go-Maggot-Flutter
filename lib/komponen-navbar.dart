import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int indexSelected;
  final ValueChanged<int> onItemSelected;

  const CustomBottomNavBar({
    super.key,
    required this.indexSelected,
    required this.onItemSelected,
  });
  
  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index) {
    final isSelected = index == indexSelected;
    return InkWell(
      // Panggil fungsi callback onItemSelected saat item diklik
      onTap: () => onItemSelected(index),
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
          _buildNavItem(context, Icons.person_outline, 'Profile', 3),
          _buildNavItem(context, Icons.menu_book_outlined, 'Edukasi', 4),
        ],
      ),
    );
  }
}