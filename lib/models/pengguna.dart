class Pengguna {
  final String idPengguna;
  final String username;
  final String email;
  final String role;

  Pengguna({
    required this.idPengguna,
    required this.username,
    required this.email,
    required this.role,
  });

  factory Pengguna.fromJson(Map<String, dynamic> json) {
    return Pengguna(
      idPengguna: json['id_pengguna'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
    );
  }
}
