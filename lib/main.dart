import 'package:flutter/material.dart';
import 'package:gomaggot_flutter/bantuan.dart';
import 'package:gomaggot_flutter/edukasi.dart';
import 'package:gomaggot_flutter/profil.dart'; // Pastikan file profil.dart berisi class ProfilePage
import 'product.dart';
import 'login.dart';
import 'keranjang.dart';

// Definisi Konstanta Rute
const String LoginRoute = '/';
const String ProductRoute = '/product';
const String CartRoute = '/cart';
const String ProfileRoute = '/profil'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoMaggot App',
      
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B7E66)),
      ),

      initialRoute: LoginRoute,
      routes: {
        LoginRoute: (context) => const LoginScreen(),
        ProductRoute: (context) => const ProductPage(),
        CartRoute: (context) => const CartScreen(),
        ProfileRoute: (context) => const ProfilePage(), // <--- 2. DAFTARKAN DI SINI
      },
    );
  }
}