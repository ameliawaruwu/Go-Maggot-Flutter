import 'package:flutter/material.dart';

class BantuanPage extends StatelessWidget {
  const BantuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color darkGreenBg = const Color(0xFF385E39);
    final Color whiteCard = const Color(0xFFFFFFFF);   
    final Color lightGreyBtn = const Color(0xFFF5F5F5); 

    return Scaffold(
      backgroundColor: darkGreenBg, 
      
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 24, right: 24, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      "Pusat Bantuan",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                
               
                const Text(
                  "Halo, Apa ada yang bisa dibantu?",
                  style: TextStyle(
                    fontSize: 22, 
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                
                TextField(
                  decoration: InputDecoration(
                    hintText: "Cari topik bantuan...",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    filled: true,
                    fillColor: Colors.white, 
                    prefixIcon: const Icon(Icons.search, color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ],
            ),
          ),

          
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 30, left: 24, right: 24),
              width: double.infinity,
              decoration: BoxDecoration(
                color: whiteCard,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 30), 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSquareButton("Lacak\nPesanan", lightGreyBtn),
                        _buildSquareButton("Batalkan\nPesanan", lightGreyBtn),
                        _buildSquareButton("Status\nPengembalian", lightGreyBtn),
                        _buildSquareButton("Ganti\nNomor", lightGreyBtn),
                      ],
                    ),
                    const SizedBox(height: 20),

                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: lightGreyBtn, 
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          "Ajukan Pengembalian Barang/Dana",
                          style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                   
                    const Text(
                      "Pertanyaan Populer",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 10),
                    _buildFaqItem("Bagaimana cara mengajukan pengembalian?"),
                    _buildFaqItem("Metode pembayaran apa saja yang tersedia?"),
                    _buildFaqItem("Berapa lama proses pengiriman?"),
                    _buildFaqItem("Bagaimana cara mengubah alamat?"),
                    
                    const SizedBox(height: 30),

                    // Contact Us Section
                    const Text(
                      "Hubungi Kami",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 15),

                    // Chat Item
                    _buildContactItem(Icons.chat_bubble_outline, "Chat GoMaggot Sekarang"),
                    const SizedBox(height: 15),
                    
                    // Call Item
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.phone_in_talk_outlined, color: Colors.black87, size: 28),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Telepon Kami",
                              style: TextStyle(color: Colors.black87, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Jam Operasional: 07:00 - 17.00 WIB",
                              style: TextStyle(color: Colors.black54, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET TOMBOL KOTAK
  Widget _buildSquareButton(String text, Color color) {
    return Container(
      width: 75, 
      height: 75,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // WIDGET ITEM FAQ (Garis Bawah)
  Widget _buildFaqItem(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black12, width: 1), // Garis tipis abu
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ),
          const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
        ],
      ),
    );
  }

  // WIDGET ITEM KONTAK
  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.black87, size: 28),
        const SizedBox(width: 15),
        Text(
          text,
          style: const TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ],
    );
  }
}