import 'package:flutter/material.dart';
import 'checkout_page.dart';

// Konstanta Warna
const Color primaryDarkGreen = Color(0xFF385E39);
const Color accentLightGreen = Color(0xFF6E9E4F);
const Color lightCardGreen = Color(0xFFE4EDE5);
const Color primaryTextColor = Color.fromARGB(255, 252, 247, 247);

// --- MODEL DATA UNTUK KERANJANG ---
class CartItem {
  final String title;
  final int unitPrice;
  int quantity;
  final Widget imagePlaceholder;

  CartItem({
    required this.title,
    required this.unitPrice,
    required this.quantity,
    required this.imagePlaceholder,
  });

  int get subtotal => unitPrice * quantity;
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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

  int get _totalPrice => _cartItems.fold(0, (sum, item) => sum + item.subtotal);

  String _formatPrice(int price) {
    final priceStr = price.toString();
    String result = '';
    int count = 0;
    for (int i = priceStr.length - 1; i >= 0; i--) {
      result = priceStr[i] + result;
      count++;
      if (count % 3 == 0 && i != 0) result = '.$result';
    }
    return 'Rp.$result';
  }

  void _updateQuantity(CartItem item, int change) {
    setState(() {
      item.quantity += change;
      if (item.quantity <= 0) _cartItems.remove(item);
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
          onPressed: () => Navigator.pop(context),
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

      // BODY (tanpa footer di dalam Column lagi)
      body: Container(
        color: const Color(0xFFE0E0E0),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          children: [
            // daftar produk
            ..._cartItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Padding(
                padding: index == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 16.0),
                child: _buildCartItemCard(item),
              );
            }),

            const SizedBox(height: 14),

            // voucher
            _buildVoucherSection(),

            const SizedBox(height: 90), // kasih ruang biar ga ketutup footer
          ],
        ),
      ),

      // FOOTER checkout dipindah ke sini -> tombol jadi pasti bisa ditekan
      bottomNavigationBar: _buildCheckoutFooter(context),
    );
  }

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
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: item.imagePlaceholder,
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.title,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        _formatPrice(item.unitPrice),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    _buildQuantityButton(
                      Icons.remove,
                      onPressed: () => _updateQuantity(item, -1),
                      isInactive: item.quantity <= 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
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

  Widget _buildQuantityButton(
    IconData icon, {
    required VoidCallback onPressed,
    bool isInactive = false,
  }) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: isInactive ? Colors.grey[400] : accentLightGreen,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 18,
        icon: Icon(icon, color: isInactive ? Colors.grey[600] : Colors.white),
        onPressed: isInactive ? null : onPressed,
      ),
    );
  }

  Widget _buildVoucherSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: lightCardGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
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
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutFooter(BuildContext context) {
    return Container(
      height: 74,
      decoration: BoxDecoration(
        color: primaryDarkGreen,
        border: Border(top: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SafeArea(
        top: false,
        child: Row(
          children: <Widget>[
            Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: true,
                    onChanged: (bool? value) {},
                    fillColor: WidgetStateProperty.all(primaryDarkGreen),
                    side: const BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                const SizedBox(width: 8.0),
                const Text('Semua', style: TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(width: 16.0),
                const Text('Total', style: TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(width: 6.0),
                Text(
                  _formatPrice(_totalPrice),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CheckoutPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentLightGreen,
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
