import 'package:flutter/material.dart';

import 'package:gomaggot_flutter/bantuan.dart'; 
import 'package:gomaggot_flutter/edukasi.dart'; 
import 'package:gomaggot_flutter/profil.dart'; 

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
     home: const ProfilePage(),
    );
  }
}