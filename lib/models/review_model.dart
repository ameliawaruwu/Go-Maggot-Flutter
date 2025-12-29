import '../utils/image_helper.dart'; 

class ReviewModel {
  final String? idReview;      
  final String idProduk;       
  final String? namaUser;      
  final String? fotoUser;      
  final int ratingSeller;      
  final String komentar;       
  final String? fotoReview;    
  final String tanggal;        
  final String kualitas;       
  final int tampilkanUsername; 

  ReviewModel({
    this.idReview,
    required this.idProduk,
    this.namaUser,
    this.fotoUser,
    required this.ratingSeller,
    required this.komentar,
    this.fotoReview,
    this.tanggal = '',
    // --- TAMBAHKAN DUA BARIS INI ---
    required this.kualitas,
    required this.tampilkanUsername,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      idReview: json['id_review']?.toString(),
      idProduk: json['id_produk']?.toString() ?? '',
      namaUser: json['pengguna']?['nama'] ?? 'Anonim',
      fotoUser: ImageHelper.fixUrl(json['pengguna']?['foto']), 
      ratingSeller: int.tryParse(json['rating_seller'].toString()) ?? 0,
      komentar: json['komentar'] ?? '',
      fotoReview: ImageHelper.fixUrl(json['foto']),
      tanggal: json['tanggal_review'] ?? json['created_at'] ?? '',
      // Tambahkan ini agar tidak error saat baca data
      kualitas: json['kualitas'] ?? '',
      tampilkanUsername: json['tampilkan_username'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_produk': idProduk,
      'rating_seller': ratingSeller,
      'komentar': komentar,
      'kualitas': kualitas, // Sekarang diambil dari variabel
      'kegunaan': 'Sangat Bermanfaat',
      'tampilkan_username': tampilkanUsername, // Sekarang diambil dari variabel
    };
  }
}