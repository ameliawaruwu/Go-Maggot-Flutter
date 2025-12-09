import 'package:flutter/material.dart';
import 'product.dart';
import 'login.dart'; 
import 'keranjang.dart';
import 'pembayaran.dart';
import 'feedback.dart';
import 'home_page.dart';

const String LoginRoute = '/';
const String ProductRoute = '/product';
const String CartRoute = '/cart'; 
const String PaymentRoute = '/payment';
const String FeedbackRoute = '/feedback';
const String HomeRoute = '/home';

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
        CartRoute: (context) => const CartScreen(), 
        PaymentRoute: (context) => const PaymentPage(),
        FeedbackRoute: (context) => const FeedbackPage(),
        HomeRoute: (context) => const HomePage(),
      },
    );
  }
}