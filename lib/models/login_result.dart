import 'pengguna.dart';

class LoginResult {
  final bool success;
  final String message;
  final Pengguna? user;

  LoginResult({
    required this.success,
    required this.message,
    this.user,
  });
}
