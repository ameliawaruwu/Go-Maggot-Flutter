class PesananModel {
  final String idPesanan;
  final String idPengguna;
  final String namaPenerima;
  final String alamatPengiriman;
  final String nomorTelepon;
  final String tanggalPesanan;
  final String metodePembayaran;
  final int totalHarga;
  final String statusNama; 

  PesananModel({
    required this.idPesanan,
    required this.idPengguna,
    required this.namaPenerima,
    required this.alamatPengiriman,
    required this.nomorTelepon,
    required this.tanggalPesanan,
    required this.metodePembayaran,
    required this.totalHarga,
    required this.statusNama,
  });

  // Fungsi untuk mengubah JSON dari Laravel menjadi Objek Dart
  factory PesananModel.fromJson(Map<String, dynamic> json) {
    return PesananModel(
      idPesanan: json['id_pesanan']?.toString() ?? '', // Sesuai primary key string
      idPengguna: json['id_pengguna']?.toString() ?? '',
      namaPenerima: json['nama_penerima'] ?? '',
      alamatPengiriman: json['alamat_pengiriman'] ?? '',
      nomorTelepon: json['nomor_telepon'] ?? '',
      tanggalPesanan: json['tanggal_pesanan'] ?? '',
      metodePembayaran: json['metode_pembayaran'] ?? '',
      totalHarga: int.tryParse(json['total_harga'].toString()) ?? 0,
      // Mengambil nama status dari relasi 'status' di Laravel
      statusNama: json['status'] != null 
          ? json['status']['nama_status'] 
          : 'Menunggu', 
    );
  }

  // Fungsi untuk mengubah Objek ke JSON (jika perlu untuk kirim data)
  Map<String, dynamic> toJson() {
    return {
      'id_pesanan': idPesanan,
      'id_pengguna': idPengguna,
      'nama_penerima': namaPenerima,
      'alamat_pengiriman': alamatPengiriman,
      'nomor_telepon': nomorTelepon,
      'tanggal_pesanan': tanggalPesanan,
      'metode_pembayaran': metodePembayaran,
      'total_harga': totalHarga,
    };
  }
}