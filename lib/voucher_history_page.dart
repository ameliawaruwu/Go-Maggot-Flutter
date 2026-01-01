import 'package:flutter/material.dart';

class VoucherRiwayatPage extends StatelessWidget {
  const VoucherRiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF385E39),
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Riwayat Voucher',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          TicketVoucherHistoryCard(
            icon: Icons.local_fire_department,
            iconColor: Colors.red,
            title: 'Diskon Rp10RB',
            subtitle: 'Min. Belanja Rp100RB',
            statusText: 'Digunakan 12 Jan 2025',
          ),
          TicketVoucherHistoryCard(
            icon: Icons.local_shipping,
            iconColor: Colors.green,
            title: 'Gratis Ongkir',
            subtitle: 'Min. Belanja Rp0',
            statusText: 'Digunakan 05 Jan 2025',
          ),
          TicketVoucherHistoryCard(
            icon: Icons.attach_money,
            iconColor: Colors.orange,
            title: 'Diskon 20%',
            subtitle: 'Kategori Pilihan',
            statusText: 'Kadaluarsa',
          ),
        ],
      ),
    );
  }
}

// ================= TICKET CARD RIWAYAT =================
class TicketVoucherHistoryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String statusText;

  const TicketVoucherHistoryCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.statusText,
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
                // ===== ICON WITH GREY OVERLAY =====
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: 30,
                      ),
                    ),
                    // GREY OVERLAY
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
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
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        statusText,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ===== TERPAKAI BADGE (TOP LEFT) =====
          Positioned(
            top: 8,
            right: 12,
            child: Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Terpakai',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
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
