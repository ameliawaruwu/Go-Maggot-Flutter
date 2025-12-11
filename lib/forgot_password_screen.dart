import 'package:flutter/material.dart';

// Konstanta Warna (Ambil dari file login Anda)
const Color primaryDarkGreen = Color(0xFF385E39);
const Color accentLightGreen = Color(0xFF6E9E4F);

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Fungsi yang dipanggil saat tombol "Kirim" ditekan
  void _submitForgotPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Simulasi pengiriman permintaan reset password
      String email = _emailController.text.trim();
      
      // Biasanya, di sini Anda akan memanggil API untuk mengirim email reset
      
      // Tampilkan notifikasi sukses ke pengguna
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Link reset password telah dikirim ke $email. Silakan cek email Anda.'),
          backgroundColor: accentLightGreen,
          duration: const Duration(seconds: 4),
        ),
      );

      // Kembali ke halaman login setelah beberapa saat (opsional)
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context); 
      });
    }
  }

  // Widget pembantu untuk TextFormField
  Widget _buildEmailTextField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(color: Colors.black),
        decoration: const InputDecoration(
          hintText: 'Masukkan Email Anda',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16.0),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 16.0, right: 8.0),
            child: Icon(Icons.email_outlined, color: Colors.grey),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email wajib diisi.';
          }
          // Anda dapat menambahkan validasi format email di sini jika perlu
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryDarkGreen,
      appBar: AppBar(
        backgroundColor: primaryDarkGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Lupa Password',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'RESET PASSWORD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12.0),
                const Text(
                  'Masukkan alamat email Anda, dan kami akan mengirimkan link untuk mereset kata sandi Anda.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 40.0),

                _buildEmailTextField(),

                const SizedBox(height: 24.0),

                // Tombol KIRIM RESET LINK
                ElevatedButton(
                  onPressed: () => _submitForgotPassword(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentLightGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'KIRIM LINK RESET',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}