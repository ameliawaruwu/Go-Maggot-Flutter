import 'package:flutter/material.dart';
import 'main.dart'; 
import 'home_page.dart'; 

const String appName = 'GoMaggot';
const Color primaryDarkGreen = Color(0xFF385E39);
const Color accentLightGreen = Color(0xFF6E9E4F);


// --- PERUBAHAN UTAMA: UBAH DARI StatelessWidget KE StatefulWidget ---
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // State untuk 1. Input Validation
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // State untuk 2. Remember Me
  bool _rememberMe = false; 

  // State untuk 3. Toggle Lihat Password
  bool _isPasswordHidden = true;

  // --- FUNGSI VALIDASI LOGIN ---
  void _attemptLogin(BuildContext context) {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // 1. Pengguna wajib login (muncul notif harus login)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email dan Password wajib diisi.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // --- ASUMSI LOGIN BERHASIL (GANTI DENGAN LOGIKA OTENTIKASI NYATA) ---
    // Jika validasi sukses, navigasi ke HomePage
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) => const HomePage(), 
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


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

              // TEXT FIELD EMAIL
              _buildTextField(
                controller: _emailController, // Tambahkan controller
                hintText: 'Email atau No. Ponsel',
                prefixIcon: Icons.email_outlined,
                isPassword: false, // Pastikan isPassword false untuk email
              ),
              const SizedBox(height: 16.0),

              // TEXT FIELD PASSWORD (Diperbarui)
              _buildTextField(
                controller: _passwordController, // Tambahkan controller
                hintText: 'Password',
                prefixIcon: Icons.lock_outline,
                isPassword: _isPasswordHidden, // Menggunakan state
                suffixIcon: _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                onSuffixIconTap: () {
                  setState(() {
                    _isPasswordHidden = !_isPasswordHidden; // Toggle state
                  });
                }
              ),
              const SizedBox(height: 8.0),

              // CHECKBOX DAN LUPA PASSWORD (Diperbarui)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      // CHECKBOX REMEMBER ME (Diperbarui)
                      SizedBox(
                        height: 24.0,
                        width: 24.0,
                        child: Checkbox(
                          value: _rememberMe, // Menggunakan state
                          onChanged: (bool? newValue) { // 2. Kotak remember bisa di klik
                            setState(() {
                              _rememberMe = newValue ?? false;
                            });
                          },
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

              // Tombol MASUK (Diperbarui)
              ElevatedButton(
                onPressed: () => _attemptLogin(context), // Panggil fungsi validasi
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
                  _buildSocialButton(
                    icon: Icons.g_mobiledata,
                    color: Colors.black,
                  ),
                  
                  _buildSocialButton(
                    icon: Icons.facebook,
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

  // Widget pembantu untuk TextFormField (Disesuaikan untuk menerima controller & onTap)
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    IconData? suffixIcon,
    bool isPassword = false,
    VoidCallback? onSuffixIconTap, // Tambahkan onTap untuk ikon suffix
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        controller: controller, // Menggunakan controller
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
          
          // Ikon Suffix dengan onTap
          suffixIcon: suffixIcon != null
              ? GestureDetector( // Menggunakan GestureDetector agar ikon bisa diklik
                  onTap: onSuffixIconTap,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Icon(suffixIcon, color: primaryDarkGreen), 
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon, 
    required Color color,
  }) {
    // KODE INI TETAP SAMA
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