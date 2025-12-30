import 'package:flutter/material.dart';
import 'checkout_page.dart';
import 'models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Konstanta Warna
const Color primaryDarkGreen = Color(0xFF385E39);
const Color accentLightGreen = Color(0xFF6E9E4F);
const Color lightCardGreen = Color(0xFFE4EDE5);
const Color primaryTextColor = Color.fromARGB(255, 252, 247, 247);

class CartItem {
  final ProdukModel product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  // Pastikan perhitungan menggunakan double untuk keamanan kalkulasi
  double get subtotal => (product.harga * quantity).toDouble();

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: ProdukModel.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString('cart');
    if (cartData != null) {
      List<dynamic> decoded = json.decode(cartData);
      setState(() {
        _cartItems = decoded.map((item) => CartItem.fromJson(item)).toList();
      });
    }
  }

  Future<void> _saveCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encoded = json.encode(_cartItems.map((item) => item.toJson()).toList());
    await prefs.setString('cart', encoded);
  }

  double get _totalPrice => _cartItems.fold(0.0, (sum, item) => sum + item.subtotal);

  // Fungsi format harga yang lebih tahan error
  String _formatPrice(num price) {
    try {
      int intPrice = price.round();
      final priceStr = intPrice.toString();
      String result = '';
      int count = 0;
      for (int i = priceStr.length - 1; i >= 0; i--) {
        result = priceStr[i] + result;
        count++;
        if (count % 3 == 0 && i != 0) result = '.$result';
      }
      return 'Rp.$result';
    } catch (e) {
      return 'Rp.0';
    }
  }

  void _updateQuantity(CartItem item, int change) {
    setState(() {
      item.quantity += change;
      if (item.quantity <= 0) {
        _cartItems.remove(item);
      }
    });
    _saveCart();
  }

  void _removeItem(CartItem item) {
    setState(() {
      _cartItems.remove(item);
    });
    _saveCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          if (_cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.white70),
              onPressed: () {
                setState(() => _cartItems.clear());
                _saveCart();
              },
            ),
        ],
      ),
      body: Container(
        color: const Color(0xFFE0E0E0),
        child: _cartItems.isEmpty
            ? _buildEmptyState()
            : ListView(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                children: [
                  ..._cartItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Padding(
                      padding: index == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 16.0),
                      child: _buildCartItemCard(item),
                    );
                  }),
                  const SizedBox(height: 14),
                  _buildVoucherSection(),
                  const SizedBox(height: 90),
                ],
              ),
      ),
      bottomNavigationBar: _cartItems.isEmpty ? null : _buildCheckoutFooter(context),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "Keranjangmu kosong",
            style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: primaryDarkGreen),
            child: const Text("Mulai Belanja", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'GoMaggot',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryDarkGreen),
                ),
                GestureDetector(
                  onTap: () => _removeItem(item),
                  child: const Icon(Icons.close, size: 20, color: Colors.redAccent),
                )
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: item.product.gambarUrl != null && item.product.gambarUrl!.isNotEmpty
                      ? Image.network(
                          item.product.gambarUrl!,
                          width: 80, height: 80, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                            const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                        )
                      : Container(
                          width: 80, height: 80, color: Colors.grey[300],
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.product.namaProduk,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        _formatPrice(item.product.harga),
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

  Widget _buildQuantityButton(IconData icon, {required VoidCallback onPressed}) {
    return Container(
      width: 30, height: 30,
      decoration: BoxDecoration(color: accentLightGreen, borderRadius: BorderRadius.circular(8)),
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 18,
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildVoucherSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(color: lightCardGreen, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: <Widget>[
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.confirmation_number_outlined, color: Colors.black87),
            label: const Text(
              'Gunakan Voucher Maggot',
              style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Pembayaran', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text(
                    _formatPrice(_totalPrice),
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ElevatedButton(
  onPressed: () {
    if (_cartItems.isEmpty) return; // Tambahkan safety check
    
    Navigator.push(
      context,
      MaterialPageRoute(
        // Pastikan variabel _cartItems dikirim dengan benar
        builder: (_) => CheckoutPage(cartItems: List.from(_cartItems)), 
      ),
    );
  },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentLightGreen,
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
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