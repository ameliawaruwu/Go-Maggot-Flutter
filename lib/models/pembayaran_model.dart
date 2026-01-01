class PembayaranModel {
  final String idPembayaran;
  final String idPengguna;
  final String idPesanan;
  final DateTime? tanggalBayar;
  final String? buktiBayar;

  PembayaranModel({
    required this.idPembayaran,
    required this.idPengguna,
    required this.idPesanan,
    this.tanggalBayar,
    this.buktiBayar,
  });

  factory PembayaranModel.fromJson(Map<String, dynamic> json) {
    return PembayaranModel(
      idPembayaran: json['id_pembayaran'],
      idPengguna: json['id_pengguna'],
      idPesanan: json['id_pesanan'],
      tanggalBayar: json['tanggal_bayar'] != null 
          ? DateTime.parse(json['tanggal_bayar']) 
          : null,
      buktiBayar: json['bukti_bayar'],
    );
  }
}