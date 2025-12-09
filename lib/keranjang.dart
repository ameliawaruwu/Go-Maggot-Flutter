import 'package:flutter/material.dart';

// --- KONSTANTA WARNA ---
// Warna Hijau Gelap utama (dari latar belakang login)
const Color primaryDarkGreen = Color(0xFF385E39);
// Warna Hijau Terang aksen (dari tombol/logo)
const Color accentLightGreen = Color(0xFF6E9E4F);
// Warna background kartu produk (Hijau Muda/Putih pudar)
const Color lightCardGreen = Color(0xFFE4EDE5); 
// -----------------------

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Keranjang Saya',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Pilih',
              style: TextStyle(color: accentLightGreen, fontSize: 16),
            ),
          ),
        ],
      ),
      
      body: Builder(
        builder: (context) {
          return Container(
            color: const Color(0xFFE0E0E0), 
            child: Column(
              children: <Widget>[
                // DAFTAR PRODUK
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    children: <Widget>[
                      _buildCartItemCard(
                        'Maggot Siap Pakai',
                        'Rp.70.000',
                        3,
                        Image.asset(
                          'assets/maggot_removebg.png', 
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ), 
                      ),
                      const SizedBox(height: 16.0),
                      _buildCartItemCard(
                        'Paket Bundling Maggot',
                        'Rp.170.000',
                        1, 
                        Image.asset(
                          'assets/Bundling_Maggot.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ), 
                      ),
                      const SizedBox(height: 100), 
                    ],
                  ),
                ),

                // VOUCHER 
                _buildVoucherSection(),
                
                // FOOTER CHECKOUT
                _buildCheckoutFooter(context),
              ],
            ),
          );
        }
      ),
    );
  }

  // Widget untuk setiap item di keranjang
  Widget _buildCartItemCard(
      String title, String price, int quantity, Widget imagePlaceholder) {
    return Card(
      color: lightCardGreen,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama Toko (GoMaggot)
            const Text(
              'GoMaggot',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: primaryDarkGreen,
              ),
            ),
            const SizedBox(height: 8.0),
            
            // Detail Produk
            Row(
              children: <Widget>[
                // Gambar Produk
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: imagePlaceholder,
                ),
                const SizedBox(width: 12.0),
                
                // Deskripsi & Harga
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        price,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                
                // Tombol +/- dan Jumlah
                Row(
                  children: [
                    _buildQuantityButton(Icons.remove, onPressed: () {}),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '$quantity',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    _buildQuantityButton(Icons.add, onPressed: () {}),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk tombol tambah/kurang jumlah
  Widget _buildQuantityButton(IconData icon, {required VoidCallback onPressed}) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 18,
        icon: Icon(icon, color: Colors.black),
        onPressed: onPressed,
      ),
    );
  }

  // Widget untuk bagian Voucher
  Widget _buildVoucherSection() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 0.0), // Padding di atas footer utama
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: lightCardGreen, // Warna latar belakang kartu voucher
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.confirmation_number_outlined, color: Colors.black87),
            label: const Text(
              'Voucher',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk footer Checkout
  Widget _buildCheckoutFooter(BuildContext context) {
    return Container(
      height: 70, // Tinggi yang cukup untuk footer
      decoration: BoxDecoration(
        color: primaryDarkGreen, // Warna hijau gelap
        border: Border(
          top: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: <Widget>[
          // Checkbox Semua & Teks Total
          Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: false,
                  onChanged: (bool? value) {},
                  fillColor: WidgetStateProperty.all(Colors.grey[400]),
                  side: BorderSide.none,
                ),
              ),
              const SizedBox(width: 8.0),
              const Text(
                'Semua',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(width: 20.0),
              const Text(
                'Total',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(width: 4.0),
              const Text(
                'Rp.0', 
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          
          const Spacer(), 

          // Tombol Checkout
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: accentLightGreen, // Warna Hijau Terang
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'Checkout',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}