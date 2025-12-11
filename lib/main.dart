import 'package:flutter/material.dart';
import 'package:gomaggot_flutter/bantuan.dart';
import 'package:gomaggot_flutter/edukasi.dart';
import 'package:gomaggot_flutter/profil.dart';

import 'product.dart';
import 'login.dart';
import 'keranjang.dart';
import 'pembayaran.dart';
import 'feedback.dart';
import 'home_page.dart';
import 'splash_screen.dart';
import 'landing_page.dart';
import 'register.dart';

// ROUTE NAMES
const String SplashRoute   = '/';          // pertama kali dibuka
const String LandingRoute  = '/landing';
const String LoginRoute    = '/login';
const String RegisterRoute = '/register';

const String ProductRoute  = '/product';
const String CartRoute     = '/cart';
const String ProfileRoute  = '/profil';
const String PaymentRoute  = '/payment';
const String FeedbackRoute = '/feedback';
const String HomeRoute     = '/home';
const String EdukasiRoute  = '/edukasi';

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

      // PERTAMA KALI MUNCUL: SPLASH
      initialRoute: SplashRoute,

      routes: {
        // Flow awal
        SplashRoute:   (context) => const SplashScreen(),
        LandingRoute:  (context) => const LandingPage(),
        LoginRoute:    (context) => const LoginScreen(),
        RegisterRoute: (context) => const RegisterScreen(),

        // App utama
        ProductRoute:  (context) => const ProductPage(),
        CartRoute:     (context) => const CartScreen(),
        ProfileRoute:  (context) => const ProfilePage(),
        PaymentRoute:  (context) => const PaymentPage(),
        FeedbackRoute: (context) => const FeedbackPage(),
        HomeRoute:     (context) => const HomePage(),
        EdukasiRoute:  (context) => const EdukasiPage(),
      },
    );
  }
}
