import 'package:flutter/material.dart';
import 'main.dart'; // supaya bisa pakai LoginRoute

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

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
    const Color accentLightGreen = Color(0xFF6E9E4F);
    const Color buttonBg = Color(0xFFEAF2C9);

    return Scaffold(
      backgroundColor: const Color(0xFF163822),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: _bgGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LOGO + PANAH
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: const [
                          TextSpan(
                            text: 'Go',
                            style: TextStyle(
                              color: accentLightGreen,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kaushan Script',
                            ),
                          ),
                          TextSpan(
                            text: 'Maggot',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kaushan Script',
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // ke halaman login
                        Navigator.pushReplacementNamed(context, LoginRoute);
                      },
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          size: 26,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // JUDUL
                const Text(
                  'Selamat Datang di GoMaggot!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 16),

                // DESKRIPSI
                const Text(
                  'Mari menciptakan masa depan yang hijau dengan '
                  'mengelola limbah organik secara inovatif dan '
                  'ramah lingkungan.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 17,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                const SizedBox(height: 40),

                // LOGO TANAMAN
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 180,
                        height: 180,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              bottom: 16,
                              child: Container(
                                width: 150,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.06),
                                  borderRadius: BorderRadius.circular(80),
                                ),
                                child: CustomPaint(
                                  painter: _FieldPainter(
                                    color: Colors.yellow.shade200
                                        .withOpacity(0.95),
                                  ),
                                ),
                              ),
                            ),
                            Icon(
                              Icons.spa_rounded,
                              size: 95,
                              color: Colors.yellow.shade200.withOpacity(0.95),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // TOMBOL
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // ke halaman login
                      Navigator.pushReplacementNamed(context, LoginRoute);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonBg,
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Mulai Sekarang!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// LOGO LADANG
class _FieldPainter extends CustomPainter {
  _FieldPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final path1 = Path()
      ..moveTo(0, size.height * 0.8)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.45,
        size.width * 0.5,
        size.height * 0.8,
      );
    final path2 = Path()
      ..moveTo(size.width * 0.5, size.height * 0.8)
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.45,
        size.width,
        size.height * 0.8,
      );
    final path3 = Path()
      ..moveTo(size.width * 0.25, size.height * 0.8)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.55,
        size.width * 0.75,
        size.height * 0.8,
      );

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
