import 'package:flutter/material.dart';
import 'package:gomaggot_flutter/bantuan.dart';
import 'package:gomaggot_flutter/edukasi.dart';
import 'package:gomaggot_flutter/profil.dart'; // Pastikan file profil.dart berisi class ProfilePage
import 'product.dart';
import 'login.dart';
import 'keranjang.dart';
import 'pembayaran.dart';
import 'feedback.dart';
import 'home_page.dart';

// Definisi Konstanta Rute
const String LoginRoute = '/';
const String ProductRoute = '/product';
const String CartRoute = '/cart';
const String ProfileRoute = '/profil'; 
const String PaymentRoute = '/payment';
const String FeedbackRoute = '/feedback';
const String HomeRoute = '/home';
const String EdukasiRoute = '/edukasi';

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
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green, 
        ),
        useMaterial3: true,
      ),
      
     

      initialRoute: LoginRoute,
      routes: {
        LoginRoute: (context) => const LoginScreen(),
        ProductRoute: (context) => const ProductPage(),
        CartRoute: (context) => const CartScreen(),
        ProfileRoute: (context) => const ProfilePage(), 
        ProductRoute: (context) => const ProductPage(), 
        CartRoute: (context) => const CartScreen(), 
        PaymentRoute: (context) => const PaymentPage(),
        FeedbackRoute: (context) => const FeedbackPage(),
        HomeRoute: (context) => const HomePage(),
        EdukasiRoute: (context) => const EdukasiPage(),
      },
    );
  }
}