import 'package:flutter/material.dart';

class QrCodeImage extends StatelessWidget {
  final double size;
  final String assetPath; 

  const QrCodeImage({
    super.key, 
    this.size = 200, 
    this.assetPath = 'assets/Qris_GoMaggot.png', 
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain, 
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.red.shade100,
            child: const Center(
              child: Text("QR Code Error", style: TextStyle(color: Colors.red)),
            ),
          );
        },
      ),
    );
  }
}