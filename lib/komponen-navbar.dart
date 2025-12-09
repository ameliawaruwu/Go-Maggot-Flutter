import 'package:flutter/material.dart';
import 'colors.dart'; 
import 'product.dart';

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
    final selectedColor = accentLightGreen; 
    final unselectedColor = secondaryTextColor; 

    return InkWell(
      onTap: () => onItemSelected(index),
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
                fontSize: 12, 
                color: isSelected ? selectedColor : unselectedColor,
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
          _buildNavItem(context, Icons.home, 'Beranda', 0), 
          _buildNavItem(context, Icons.shopping_bag, 'Produk', 1), 
          _buildNavItem(context, Icons.group, 'Komunitas', 2), 
          _buildNavItem(context, Icons.person, 'Profile', 3), 
          _buildNavItem(context, Icons.school, 'Edukasi', 4), 
        ],
      ),
    );
  }
}