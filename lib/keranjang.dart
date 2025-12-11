import 'package:flutter/material.dart';
import 'main.dart'; // Import ini tetap dipertahankan

// Asumsi 'PaymentRoute' didefinisikan di main.dart, jika tidak, tambahkan di sini
const String PaymentRoute = '/payment';

// Konstanta Warna
const Color primaryDarkGreen = Color(0xFF385E39);
const Color accentLightGreen = Color(0xFF6E9E4F);
const Color lightCardGreen = Color(0xFFE4EDE5); 
const Color primaryTextColor = Color.fromARGB(255, 252, 247, 247); 

// --- MODEL DATA UNTUK KERANJANG ---
class CartItem {
  final String title;
  final int unitPrice; // Harga dalam integer untuk perhitungan mudah
  int quantity; // Quantity harus mutable
  final Widget imagePlaceholder;

  CartItem({
    required this.title,
    required this.unitPrice,
    required this.quantity,
    required this.imagePlaceholder,
  });

  // Getter untuk total harga per item
  int get subtotal => unitPrice * quantity;
}


// --- UBAH DARI StatelessWidget KE StatefulWidget ---
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  
  // Data Keranjang Sementara (Dapat dipindahkan ke State Management di aplikasi nyata)
  final List<CartItem> _cartItems = [
    CartItem(
      title: 'Maggot Siap Pakai',
      unitPrice: 70000,
      quantity: 3,
      imagePlaceholder: Image.asset(
        'assets/maggot_removebg.png', 
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
    ),
    CartItem(
      title: 'Paket Bundling Maggot',
      unitPrice: 170000,
      quantity: 1, 
      imagePlaceholder: Image.asset(
        'assets/Bundling_Maggot.png',
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
    ),
  ];
  
  // --- FUNGSI LOGIKA PERHITUNGAN TOTAL ---
  int get _totalPrice {
    return _cartItems.fold(0, (sum, item) => sum + item.subtotal);
  }

  String _formatPrice(int price) {
    // Fungsi sederhana untuk memformat harga menjadi Rp.X.XXX
    // Untuk formatting yang lebih canggih, gunakan paket intl.
    String priceStr = price.toString();
    String result = '';
    int count = 0;
    for (int i = priceStr.length - 1; i >= 0; i--) {
      result = priceStr[i] + result;
      count++;
      if (count % 3 == 0 && i != 0) {
        result = '.' + result;
      }
    }
    return 'Rp.$result';
  }

  // --- LOGIKA UBAH KUANTITAS ---
  void _updateQuantity(CartItem item, int change) {
    setState(() {
      item.quantity += change;
      if (item.quantity <= 0) {
        // Hapus item jika kuantitasnya 0 atau kurang (opsional)
        _cartItems.remove(item);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APP BAR
      appBar: AppBar(
        backgroundColor: primaryDarkGreen,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: primaryTextColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Keranjang Saya',
          style: TextStyle(color: primaryTextColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Pilih',
              style: TextStyle(color: primaryTextColor, fontSize: 16),
            ),
          ),
        ],
      ),
      
      body: Container(
        color: const Color(0xFFE0E0E0), 
        child: Column(
          children: <Widget>[
            // DAFTAR PRODUK
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                itemCount: _cartItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: index == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 16.0),
                    child: _buildCartItemCard(_cartItems[index]),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // VOUCHER 
            _buildVoucherSection(),
            
            // FOOTER CHECKOUT
            _buildCheckoutFooter(context),
          ],
        ),
      ),
    );
  }

  // Widget untuk setiap item di keranjang (Menerima objek CartItem)
  Widget _buildCartItemCard(CartItem item) {
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
                  child: item.imagePlaceholder,
                ),
                const SizedBox(width: 12.0),
                
                // Deskripsi & Harga
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        _formatPrice(item.unitPrice), // Tampilkan harga satuan
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                
                // Tombol +/- dan Jumlah (INTERAKTIF)
                Row(
                  children: [
                    // Tombol Kurang (-)
                    _buildQuantityButton(
                      Icons.remove, 
                      onPressed: () => _updateQuantity(item, -1),
                      isInactive: item.quantity <= 1, // Nonaktif jika kuantitas 1
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '${item.quantity}', // Menggunakan kuantitas dari state
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    // Tombol Tambah (+)
                    _buildQuantityButton(
                      Icons.add, 
                      onPressed: () => _updateQuantity(item, 1),
                    ),
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
  Widget _buildQuantityButton(IconData icon, {required VoidCallback onPressed, bool isInactive = false}) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        // Warna abu-abu lebih gelap jika tidak aktif
        color: isInactive ? Colors.grey[400] : accentLightGreen, 
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 18,
        icon: Icon(icon, color: isInactive ? Colors.grey[600] : Colors.white),
        // onPressed hanya dipanggil jika tidak inactive
        onPressed: isInactive ? null : onPressed, 
      ),
    );
  }

  // Widget untuk bagian Voucher (Tidak berubah)
  Widget _buildVoucherSection() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 0.0), 
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: lightCardGreen, 
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

  // Widget untuk footer Checkout (Menampilkan Total Harga)
  Widget _buildCheckoutFooter(BuildContext context) {
    return Container(
      height: 70, 
      decoration: BoxDecoration(
        color: primaryDarkGreen, 
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
                  value: true, // Diubah menjadi true untuk contoh
                  onChanged: (bool? value) {},
                  fillColor: WidgetStateProperty.all(primaryDarkGreen),
                  side: const BorderSide(color: Colors.white, width: 2), // Tambah border putih
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
              // MENAMPILKAN TOTAL HARGA DARI STATE
              Text(
                _formatPrice(_totalPrice), 
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          
          const Spacer(), 

          // Tombol Checkout
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, PaymentRoute);
            },
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