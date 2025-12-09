import 'package:flutter/material.dart';
import 'product.dart';
import 'login.dart'; 
import 'keranjang.dart';
const String LoginRoute = '/';
const String ProductRoute = '/product';
const String CartRoute = '/cart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go-Maggot',
      theme: ThemeData(
        // Sesuaikan warna tema utama (misalnya hijau, jika ingin)
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green, 
        ),
        useMaterial3: true,
      ),
      
      // Atur rute awal (menampilkan LoginScreen)
      initialRoute: LoginRoute, 

      routes: {
        LoginRoute: (context) => const LoginScreen(),
        ProductRoute: (context) => const ProductPage(), 
        CartRoute: (context) => const CartScreen(), // <-- Daftarkan CartScreen di sini
      },
    );
  }
}