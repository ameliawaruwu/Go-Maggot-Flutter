import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import 'keranjang.dart'; // Sesuaikan path ke model CartItem Anda

class CartHelper {
  static const String _key = 'cart';

  // Fungsi menambah produk ke keranjang
  static Future<void> addToCart(ProdukModel product) async {
    final prefs = await SharedPreferences.getInstance();
    List<CartItem> cartItems = [];

    // 1. Ambil data lama
    String? cartData = prefs.getString(_key);
    if (cartData != null) {
      List<dynamic> decoded = json.decode(cartData);
      cartItems = decoded.map((item) => CartItem.fromJson(item)).toList();
    }

    // 2. Cek apakah produk sudah ada di keranjang?
    int index = cartItems.indexWhere((item) => item.product.idProduk == product.idProduk);

    if (index != -1) {
      // Jika ada, tambah jumlahnya saja
      cartItems[index].quantity += 1;
    } else {
      // Jika belum ada, tambah item baru
      cartItems.add(CartItem(product: product, quantity: 1));
    }

    // 3. Simpan kembali
    String encoded = json.encode(cartItems.map((item) => item.toJson()).toList());
    await prefs.setString(_key, encoded);
  }
}