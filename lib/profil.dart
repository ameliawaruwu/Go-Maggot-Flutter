import 'package:flutter/material.dart';
import 'bantuan.dart';
import 'faq_page.dart';
import 'favorit_page.dart';
import 'voucher_page.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    final Color darkGreenBg = const Color(0xFF385E39);
    final Color lightGreenBtn = const Color(0xFF6C856C);
    final Color whiteCard = Colors.white;
    final Color darkButton = const Color(0xFF1B3022);

    return Scaffold(
      backgroundColor: darkGreenBg,

      // ================= APPBAR =================
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "Profil Saya",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      // ================= BODY =================
      body: Column(
        children: [
          // ---------- HEADER ----------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.person, size: 45, color: Colors.grey),
                    ),
                    const SizedBox(width: 20),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Riri",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "riri@example.gmail.com",
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(child: _headerButton("Pesanan", lightGreenBtn)),
                    const SizedBox(width: 15),
                    Expanded(child: _headerButton("Ulasan", lightGreenBtn)),
                  ],
                ),
              ],
            ),
          ),

          // ---------- CARD PUTIH ----------
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  _menuItem(
                    context,
                    icon: Icons.person_outline,
                    text: "Akun Saya",
                  ),

                  _menuItem(
                    context,
                    icon: Icons.notifications_none,
                    text: "Notifikasi",
                    showDot: true,
                  ),

                  _menuItem(
                    context,
                    icon: Icons.language,
                    text: "Bahasa",
                  ),

                  _menuItem(
                    context,
                    icon: Icons.favorite_border,
                    text: "Favorit Saya",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => FavoritPage()),
                    ),
                  ),

                  _menuItem(
                    context,
                    icon: Icons.card_giftcard,
                    text: "Voucher Saya",
                    label: "Baru",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const VoucherPage()),
                    ),
                  ),

                  _menuItem(
                    context,
                    icon: Icons.help_outline,
                    text: "Bantuan",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BantuanPage()),
                    ),
                  ),

                  _menuItem(
                    context,
                    icon: Icons.question_answer_outlined,
                    text: "FAQ",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FAQPage()),
                    ),
                  ),

                  const Spacer(),

                  // ---------- LOGOUT ----------
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkButton,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "KELUAR",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER BUTTON =================
  static Widget _headerButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }

  // ================= MENU ITEM =================
  static Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    VoidCallback? onTap,
    bool showDot = false,
    String? label,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          children: [
            _iconWithBadge(icon, showDot: showDot, label: label),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B3022),
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  // ================= ICON + BADGE =================
  static Widget _iconWithBadge(
    IconData icon, {
    bool showDot = false,
    String? label,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF6E9E4F).withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF385E39), size: 20),
        ),

        if (showDot)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),

        if (label != null)
          Positioned(
            top: -10,
            right: -12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
