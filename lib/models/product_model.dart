import '../utils/image_helper.dart'; 

class ProdukModel {
  final String idProduk;
  final String namaProduk;
  final String deskripsiProduk;
  final String kategori;
  final String merk;
  final String masaPenyimpanan;
  final String pengiriman;
  final String berat;
  final int harga;
  final int stok;
  final String? gambar;
  final String? gambarUrl;

  ProdukModel({
    required this.idProduk,
    required this.namaProduk,
    required this.deskripsiProduk,
    required this.kategori,
    required this.merk,
    required this.masaPenyimpanan,
    required this.pengiriman,
    required this.berat,
    required this.harga,
    required this.stok,
    this.gambar,
    this.gambarUrl,
  });

  factory ProdukModel.fromJson(Map<String, dynamic> json) {
    // Memastikan harga dan stok dikonversi ke int dengan aman
    int parsedHarga = 0;
    if (json['harga'] is int) {
      parsedHarga = json['harga'];
    } else if (json['harga'] != null) {
      parsedHarga = int.tryParse(json['harga'].toString()) ?? 0;
    }

    int parsedStok = 0;
    if (json['stok'] is int) {
      parsedStok = json['stok'];
    } else if (json['stok'] != null) {
      parsedStok = int.tryParse(json['stok'].toString()) ?? 0;
    }

    return ProdukModel(
      // Menggunakan key sesuai JSON Laravel (id_produk, nama_produk, dsb)
      idProduk: json['id_produk']?.toString() ?? '',
      namaProduk: json['nama_produk']?.toString() ?? 'Tanpa Nama',
      deskripsiProduk: json['deskripsi_produk']?.toString() ?? '',
      kategori: json['kategori']?.toString() ?? '',
      merk: json['merk']?.toString() ?? '',
      masaPenyimpanan: json['masa_penyimpanan']?.toString() ?? '',
      pengiriman: json['pengiriman']?.toString() ?? '',
      berat: json['berat']?.toString() ?? '',
      harga: parsedHarga,
      stok: parsedStok,
      
      // PERBAIKAN: 
      // json['gambar'] hanya berisi nama file (contoh: 'bibit.png'), tidak perlu fixUrl
      // json['gambar_url'] berisi URL lengkap, ini yang butuh fixUrl agar IP-nya dinamis
      gambar: json['gambar']?.toString(), 
      gambarUrl: ImageHelper.fixUrl(json['gambar_url']?.toString()), 
    );
  }
  
  // PERBAIKAN DI SINI: Semua field wajib masuk agar data tidak hilang saat reload keranjang
  Map<String, dynamic> toJson() {
    return {
      'id_produk': idProduk,
      'nama_produk': namaProduk,
      'deskripsi_produk': deskripsiProduk,
      'kategori': kategori,
      'merk': merk,
      'masa_penyimpanan': masaPenyimpanan,
      'pengiriman': pengiriman,
      'berat': berat,
      'harga': harga,
      'stok': stok,
      'gambar': gambar,
      'gambar_url': gambarUrl,
    };
  }
}