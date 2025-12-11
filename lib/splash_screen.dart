import 'package:flutter/material.dart';
import 'main.dart'; // supaya bisa pakai LandingRoute

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const LinearGradient _bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0C2216),
      Color(0xFF163822),
      Color(0xFF0A1C12),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Saat layar di-tap, pindah ke LandingPage via route
        Navigator.pushReplacementNamed(context, LandingRoute);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF163822),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(gradient: _bgGradient),

          // LOGO DI TENGAH
          child: const Center(
            child: _Logo(),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: const [
          TextSpan(
            text: 'Go',
            style: TextStyle(
              color: Color(0xFF6E9E4F),
              fontSize: 54,
              fontWeight: FontWeight.bold,
              fontFamily: 'Kaushan Script',
            ),
          ),
          TextSpan(
            text: 'Maggot',
            style: TextStyle(
              color: Colors.white,
              fontSize: 54,
              fontWeight: FontWeight.bold,
              fontFamily: 'Kaushan Script',
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
