import 'package:flutter/material.dart';
import 'forgot_password_screen.dart';
import 'main.dart' show RegisterRoute;
import 'main_screen.dart';
import 'services/auth_service.dart';
import 'utils/session_helper.dart';

const String appName = 'GoMaggot';
const Color primaryDarkGreen = Color(0xFF385E39);
const Color accentLightGreen = Color(0xFF6E9E4F);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool _isPasswordHidden = true;
  bool _isLoading = false;

  // =========================
  // LOGIN LOGIC (API CONNECT)
  // =========================
  Future<void> _attemptLogin(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan Password wajib diisi')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await AuthService.login(email, password);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result.success && result.user != null) {
      // SIMPAN SESSION
      await SessionHelper.saveUser(
        result.user!.username,
        result.user!.email,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else {
      // TAMPILKAN PESAN SPESIFIK DARI BACKEND
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
    }
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
              Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Kaushan Script',
                      color: accentLightGreen,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'Go'),
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

              const SizedBox(height: 32),

              const Text(
                'SELAMAT DATANG KEMBALI!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Masukkan email dan password yang telah kamu daftarkan sebelumnya',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),

              const SizedBox(height: 40),

              _buildTextField(
                controller: _emailController,
                hintText: 'Email',
                prefixIcon: Icons.email_outlined,
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _passwordController,
                hintText: 'Password',
                prefixIcon: Icons.lock_outline,
                isPassword: _isPasswordHidden,
                suffixIcon:
                    _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                onSuffixIconTap: () {
                  setState(() {
                    _isPasswordHidden = !_isPasswordHidden;
                  });
                },
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (bool? value) {
                          setState(() {
                            _rememberMe = value ?? false;
                          });
                        },
                        checkColor: primaryDarkGreen,
                        activeColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                      ),
                      const Text('Remember',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Lupa Password?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : () => _attemptLogin(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentLightGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'MASUK',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),

              const SizedBox(height: 32),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum punya akun? ',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RegisterRoute);
                      },
                      child: const Text(
                        'Daftar di sini',
                        style: TextStyle(
                          color: accentLightGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // COMPONENT (TIDAK DIUBAH)
  // =========================
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    IconData? suffixIcon,
    bool isPassword = false,
    VoidCallback? onSuffixIconTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          prefixIcon: Icon(prefixIcon, color: Colors.grey),
          suffixIcon: suffixIcon != null
              ? IconButton(
                  icon: Icon(suffixIcon, color: primaryDarkGreen),
                  onPressed: onSuffixIconTap,
                )
              : null,
        ),
      ),
    );
  }
}
