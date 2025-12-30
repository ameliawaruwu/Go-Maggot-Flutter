// 1. Import helper yang baru dibuat
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
    return ProdukModel(
      idProduk: json['id_produk']?.toString() ?? '',
      namaProduk: json['nama_produk'] ?? 'Tanpa Nama',
      deskripsiProduk: json['deskripsi_produk'] ?? '',
      kategori: json['kategori'] ?? '',
      merk: json['merk'] ?? '',
      masaPenyimpanan: json['masa_penyimpanan'] ?? '',
      pengiriman: json['pengiriman'] ?? '',
      berat: json['berat']?.toString() ?? '',
      harga: int.tryParse(json['harga']?.toString() ?? '0') ?? 0,
      stok: int.tryParse(json['stok']?.toString() ?? '0') ?? 0,
      
    
      gambar: ImageHelper.fixUrl(json['gambar']?.toString()),
      gambarUrl: ImageHelper.fixUrl(json['gambar_url']?.toString()), 
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id_produk': idProduk,
      'nama_produk': namaProduk,
      // ... field lainnya ...
      'gambar': gambar,
      'gambar_url': gambarUrl,
    };
  }
  
  // (Fungsi copyWith biarkan saja, tidak perlu diubah)
}