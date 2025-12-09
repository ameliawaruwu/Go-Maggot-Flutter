import 'package:flutter/material.dart';
import 'main.dart'; 
import 'home_page.dart'; 

const String appName = 'GoMaggot';
const Color primaryDarkGreen = Color(0xFF385E39);
const Color accentLightGreen = Color(0xFF6E9E4F);


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDarkGreen,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Bagian logo
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Kaushan Script', 
                      color: accentLightGreen,
                    ),
                    children: <TextSpan>[
                      const TextSpan(text: 'Go'),
                      TextSpan(
                        text: 'Maggot',
                        style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Kaushan Script', 
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32.0),              
              const Text(
                'SELAMAT DATANG KEMBALI!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Masukkan email dan password yang telah kamu daftarkan sebelumnya',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40.0),

              _buildTextField(
                hintText: 'Email atau No. Ponsel',
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 16.0),

              _buildTextField(
                hintText: 'Password',
                prefixIcon: Icons.lock_outline,
                suffixIcon: Icons.visibility,
                isPassword: true,
              ),
              const SizedBox(height: 8.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        height: 24.0,
                        width: 24.0,
                        child: Checkbox(
                          value: false,
                          onChanged: (bool? newValue) {},
                          checkColor: primaryDarkGreen,
                          activeColor: Colors.white,
                          side: const BorderSide(color: Colors.white, width: 2),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      const Text(
                        'Remember',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Lupa Password?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              // Tombol MASUK 
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => const HomePage(), 
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentLightGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'MASUK',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              const Center(
                child: Text(
                  'Atau masuk dengan',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 16.0),

              // Tombol Google & Facebook 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Tombol Google (Ikon G)
                  _buildSocialButton(
                    icon: Icons.g_mobiledata, // Menggunakan ikon Material Google
                    color: Colors.black,
                  ),
                  
                  // Tombol Facebook (Ikon F)
                  _buildSocialButton(
                    icon: Icons.facebook, // Menggunakan ikon Material Facebook
                    color: Colors.blue[800]!, 
                  ),
                ],
              ),
              const SizedBox(height: 40.0),

              // Teks "Belum punya akun? Daftar di sini"
              Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    children: <TextSpan>[
                      const TextSpan(text: 'Belum punya akun? '),
                      TextSpan(
                        text: 'Daftar di sini',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: accentLightGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget pembantu untuk TextFormField (TETAP SAMA)
  Widget _buildTextField({
    required String hintText,
    required IconData prefixIcon,
    IconData? suffixIcon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        obscureText: isPassword,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
          
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 8.0),
            child: Icon(prefixIcon, color: Colors.grey),
          ),
          
          suffixIcon: suffixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(suffixIcon, color: primaryDarkGreen), 
                )
              : null,
        ),
      ),
    );
  }

  // Widget pembantu untuk tombol sosial 
  Widget _buildSocialButton({
      required IconData icon, 
      required Color color,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, 
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 3,
          ),
          child: Icon(
            icon,
            color: color,
            size: 32,
          ),
        ),
      ),
    );
  }
}