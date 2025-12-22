import 'package:flutter/material.dart';

// Halaman–halaman (Pastikan file-file ini ada)
import 'bantuan.dart';
import 'edukasi.dart';
import 'profil.dart';
import 'product.dart';
import 'login.dart';
import 'register.dart';
import 'keranjang.dart';
import 'pembayaran.dart';
import 'feedback.dart';
import 'home_page.dart';
import 'splash_screen.dart';
import 'landing_page.dart';
import 'forum_chat.dart';
import 'faq_page.dart'; 
import 'galeri.dart';
import 'notifikasi.dart';
import 'status_pesanan.dart';
import 'chat_produk.dart';
import 'artikel_detail.dart';


const String SplashRoute   = '/';
const String LandingRoute  = '/landing';

// auth
const String LoginRoute    = '/login';
const String RegisterRoute = '/register';

// main pages
const String HomeRoute     = '/home';
const String ProductRoute  = '/product';
const String CartRoute     = '/cart';
const String ForumRoute    = '/forum-chat';
const String EdukasiRoute  = '/edukasi';
const String ProfileRoute  = '/profil';

// lainnya
const String PaymentRoute  = '/payment';
const String FeedbackRoute = '/feedback';
const String FaqRoute      = '/faq';
const String StatusRoute   = '/status'; // Tambahan untuk status pesanan

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

      initialRoute: SplashRoute,

      routes: {
        // alur awal
        SplashRoute:   (context) => const SplashScreen(),
        LandingRoute:  (context) => const LandingPage(),

        // auth
        LoginRoute:    (context) => const LoginScreen(),
        RegisterRoute: (context) => const RegisterScreen(),

        // main pages
        HomeRoute:     (context) => const HomePage(),
        ProductRoute:  (context) => const ProductPage(),
        CartRoute:     (context) => const CartScreen(),
        ForumRoute:    (context) => const ForumChatPage(),
        EdukasiRoute:  (context) => const EdukasiPage(),
        ProfileRoute:  (context) => const ProfilePage(),

        // lainnya
        PaymentRoute:  (context) => const PaymentPage(),
        FeedbackRoute: (context) => const FeedbackPage(),
        FaqRoute:      (context) => const FAQPage(),
        StatusRoute:   (context) => const StatusPesananPage(),
      },
    );
  }
}