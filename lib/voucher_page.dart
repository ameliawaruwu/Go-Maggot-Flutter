import 'package:flutter/material.dart';
import 'voucher_history_page.dart';


class VoucherPage extends StatelessWidget {
  const VoucherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
    appBar: AppBar(
      backgroundColor: const Color(0xFF385E39),
      elevation: 0,
      leading: const BackButton(color: Colors.white),
      title: const Text(
        'Voucher Saya',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VoucherRiwayatPage(),
              ),
            );
          },
          child: const Text(
            'Riwayat',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),

      body: Column(
        children: [
          // ================= SEARCH VOUCHER =================
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Masukkan kode voucher',
                      prefixIcon: const Icon(Icons.confirmation_number),
                      filled: true,
                      fillColor: const Color(0xFFF1F2F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6E9E4F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Pakai',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ================= LIST VOUCHER =================
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                TicketVoucherCard(
                  icon: Icons.local_shipping,
                  title: 'Gratis Ongkir',
                  subtitle: 'Min. Belanja Rp0\nBerlaku hingga 31.01.2026',
                  themeColor: const Color(0xFF6E9E4F),
                ),
                TicketVoucherCard(
                  icon: Icons.local_fire_department,
                  title: 'Diskon Rp10RB',
                  subtitle: 'Min. Belanja Rp100RB\nBerlaku hingga 31.01.2026',
                  themeColor: Colors.red,
                ),
                TicketVoucherCard(
                  icon: Icons.attach_money,
                  title: 'Diskon 20% hingga Rp50RB',
                  subtitle: 'Kategori Pilihan\nBerlaku 7 hari',
                  themeColor: Colors.red,
                ),
                TicketVoucherCard(
                  icon: Icons.local_shipping,
                  title: 'Gratis Ongkir',
                  subtitle: 'Min. Belanja Rp25RB\nBerlaku hingga 12.02.2026',
                  themeColor: const Color(0xFF6E9E4F),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= TICKET CARD =================
class TicketVoucherCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color themeColor;

  const TicketVoucherCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          // ================= MAIN CARD =================
          Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                // ===== ICON =====
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: themeColor,
                    size: 30,
                  ),
                ),

                const SizedBox(width: 14),

                // ===== DASH LINE =====
                SizedBox(
                  height: 70,
                  child: CustomPaint(
                    painter: VerticalDashedLinePainter(),
                  ),
                ),

                const SizedBox(width: 14),

                // ===== TEXT =====
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                // ===== BUTTON =====
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Pakai',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ===== NOTCH LEFT =====
          _buildNotch(left: -8),

          // ===== NOTCH RIGHT =====
          _buildNotch(right: -8),
        ],
      ),
    );
  }

  Widget _buildNotch({double? left, double? right}) {
    return Positioned(
      left: left,
      right: right,
      top: 0,
      bottom: 0,
      child: Center(
        child: Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }
}

// ================= DASH LINE =================
class VerticalDashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;

    const dashHeight = 4;
    const dashSpace = 4;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
