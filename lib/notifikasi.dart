import 'package:flutter/material.dart';

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    // --- PALET WARNA ---
    const Color primaryDarkGreen = Color(0xFF385E39); // Hijau Tua
    const Color lightCardGreen = Color(0xFFE4EDE5);   // Hijau Pucat (Background)
    
    return Scaffold(
      backgroundColor: lightCardGreen,
      
      // --- HEADER ---
      appBar: AppBar(
        backgroundColor: primaryDarkGreen,
        elevation: 0,
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Notifikasi",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // Lengkungan bawah header agar senada dengan halaman lain
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        actions: [
          // Tombol "Tandai sudah dibaca" (Visual saja)
          TextButton(
            onPressed: () {},
            child: const Text(
              "Tandai Dibaca",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          )
        ],
      ),

      // --- BODY ---
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Label "Hari Ini"
          const Padding(
            padding: EdgeInsets.only(left: 10, bottom: 10),
            child: Text(
              "Hari Ini",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
            ),
          ),
          
          // Item Notifikasi 1 (Pesanan)
          _buildNotifItem(
            icon: Icons.local_shipping_outlined,
            iconColor: Colors.blue,
            title: "Paket Sedang Dikirim",
            message: "Pesanan #33 kamu sedang dalam perjalanan menuju alamat tujuan.",
            time: "14:30",
            isUnread: true,
          ),

          // Item Notifikasi 2 (Promo)
          _buildNotifItem(
            icon: Icons.discount_outlined,
            iconColor: Colors.orange,
            title: "Diskon Spesial 20%!",
            message: "Dapatkan potongan harga untuk pembelian Bibit Maggot hari ini.",
            time: "09:00",
            isUnread: true,
          ),

          const SizedBox(height: 20),

          // Label "Kemarin"
          const Padding(
            padding: EdgeInsets.only(left: 10, bottom: 10),
            child: Text(
              "Kemarin",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
            ),
          ),

          // Item Notifikasi 3 (Sukses)
          _buildNotifItem(
            icon: Icons.check_circle_outline,
            iconColor: primaryDarkGreen,
            title: "Pembayaran Berhasil",
            message: "Pembayaran untuk pesanan #32 telah terverifikasi.",
            time: "Kemarin",
            isUnread: false,
          ),
          
          // Item Notifikasi 4 (Info)
          _buildNotifItem(
            icon: Icons.info_outline,
            iconColor: Colors.grey,
            title: "Update Stok Produk",
            message: "Produk Kandang Maggot kini tersedia kembali.",
            time: "Kemarin",
            isUnread: false,
          ),
        ],
      ),
    );
  }

  // WIDGET CARD NOTIFIKASI
  Widget _buildNotifItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required String time,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isUnread ? Colors.white : Colors.white.withOpacity(0.7), // Kalau sudah baca agak transparan
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: isUnread ? Border.all(color: const Color(0xFF385E39).withOpacity(0.3)) : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Bulat
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 15),
          
          // Teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isUnread ? Colors.black : Colors.black54,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 12,
                    color: isUnread ? Colors.black87 : Colors.black45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}