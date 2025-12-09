import 'package:flutter/material.dart';

class BantuanPage extends StatelessWidget {
  const BantuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi Warna sesuai Desain (Kira-kira dari gambar)
    final Color greenPrimary = const Color(0xFF6B7E66); // Hijau Olive
    final Color creamHeader = const Color(0xFFE4E8CC);  // Krem Atas
    final Color greyButton = const Color(0xFFD9D9D9);   // Abu-abu tombol
    
    return Scaffold(
      backgroundColor: greenPrimary, // Background utama hijau
      body: Column(
        children: [
          // 1. BAGIAN HEADER (Bentuk melengkung di bawah)
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: creamHeader,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context); // Kembali ke halaman sebelumnya
                  },
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                ),
                const Text(
                  "Pusat Bantuan",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // 2. BAGIAN ISI (Scrollable agar tidak overflow di HP kecil)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sapaan
                  const Text(
                    "Halo, Apa ada yang bisa dibantu?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Search Bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: "",
                      filled: true,
                      fillColor: greyButton,
                      prefixIcon: const Icon(Icons.search, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tombol Kotak-kotak (Track, Cancel, etc)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSquareButton("Track\nOrder", greyButton),
                      _buildSquareButton("Cancel\nOrder", greyButton),
                      _buildSquareButton("Return\nStatus", greyButton),
                      _buildSquareButton("Change\nNumber", greyButton),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Tombol Panjang (Apply for Return)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greyButton,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        "Apply for Return",
                        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // List Pertanyaan (FAQ)
                  _buildFaqItem("How can I submit a return request?"),
                  _buildFaqItem("How can I submit a return request?"),
                  _buildFaqItem("How can I submit a return request?"),
                  _buildFaqItem("How can I submit a return request?"),
                  
                  const SizedBox(height: 30),

                  // Contact Us Section
                  const Text(
                    "Contact Us",
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Chat Item
                  Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 30),
                      const SizedBox(width: 15),
                      const Text(
                        "Chat GoMaggot Now",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Call Item
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start, // Agar text rata atas
                    children: [
                      const Icon(Icons.phone_in_talk_outlined, color: Colors.white, size: 30),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Call Us",
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Operating Hours: 07:00 AM - 05.00 PM",
                            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30), // Spasi bawah agar tidak mentok
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET KUSTOM: Untuk membuat tombol kotak kecil agar kode tidak berulang
  Widget _buildSquareButton(String text, Color color) {
    return Container(
      width: 75, // Ukuran kotak
      height: 75,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  // WIDGET KUSTOM: Untuk list pertanyaan (garis bawah)
  Widget _buildFaqItem(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white54, width: 0.5), // Garis tipis di bawah
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          // Jika ingin icon panah kecil di kanan seperti menu
          // const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white),
        ],
      ),
    );
  }
}