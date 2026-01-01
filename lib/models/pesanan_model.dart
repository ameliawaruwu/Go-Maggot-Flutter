class Pesanan {
  final String idPesanan;
  final String idPengguna;
  final String namaPenerima;
  final String alamatPengiriman;
  final String nomorTelepon;
  final DateTime tanggalPesanan;
  final String metodePembayaran;
  final double totalHarga;
  final String idStatusPesanan;

  Pesanan({
    required this.idPesanan,
    required this.idPengguna,
    required this.namaPenerima,
    required this.alamatPengiriman,
    required this.nomorTelepon,
    required this.tanggalPesanan,
    required this.metodePembayaran,
    required this.totalHarga,
    required this.idStatusPesanan,
  });

  factory Pesanan.fromJson(Map<String, dynamic> json) {
    return Pesanan(
      idPesanan: json['id_pesanan'] as String,
      idPengguna: json['id_pengguna'] as String,
      namaPenerima: json['nama_penerima'] as String,
      alamatPengiriman: json['alamat_pengiriman'] as String,
      nomorTelepon: json['nomor_telepon'] as String,
      tanggalPesanan: DateTime.parse(json['tanggal_pesanan'] as String),
      metodePembayaran: json['metode_pembayaran'] as String,
      totalHarga: (json['total_harga'] as num).toDouble(),
      idStatusPesanan: json['id_status_pesanan'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_pesanan': idPesanan,
      'id_pengguna': idPengguna,
      'nama_penerima': namaPenerima,
      'alamat_pengiriman': alamatPengiriman,
      'nomor_telepon': nomorTelepon,
      'tanggal_pesanan': tanggalPesanan.toIso8601String(),
      'metode_pembayaran': metodePembayaran,
      'total_harga': totalHarga,
      'id_status_pesanan': idStatusPesanan,
    };
  }
}
