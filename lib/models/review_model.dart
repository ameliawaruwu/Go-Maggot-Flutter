import '../utils/image_helper.dart'; 

class ReviewModel {
  final String? idReview;      // ID Review dari Laravel (String)
  final String idProduk;       
  final String? namaUser;      // Dari relasi 'pengguna'
  final String? fotoUser;      
  final int ratingSeller;      
  final String komentar;       
  final String? fotoReview;    
  final String? videoReview;   // Sesuai model PHP
  final String tanggal;        
  final String kualitas;       
  final String? kegunaan;      // Sesuai fillable PHP
  final int tampilkanUsername; // 1 atau 0

  ReviewModel({
    this.idReview,
    required this.idProduk,
    this.namaUser,
    this.fotoUser,
    required this.ratingSeller,
    required this.komentar,
    this.fotoReview,
    this.videoReview,
    this.tanggal = '',
    required this.kualitas,
    this.kegunaan,
    required this.tampilkanUsername,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      idReview: json['id_review']?.toString(),
      idProduk: json['id_produk']?.toString() ?? '',
      // Mengambil nama dari relasi pengguna di Laravel
      namaUser: json['pengguna'] != null ? json['pengguna']['nama_pengguna'] : 'Anonim',
      fotoUser: ImageHelper.fixUrl(json['pengguna']?['foto_profil']), 
      ratingSeller: int.tryParse(json['rating_seller'].toString()) ?? 0,
      komentar: json['komentar'] ?? '',
      fotoReview: ImageHelper.fixUrl(json['foto']),
      videoReview: json['video'],
      tanggal: json['tanggal_review'] ?? json['created_at'] ?? '',
      kualitas: json['kualitas'] ?? '',
      kegunaan: json['kegunaan'] ?? '',
      tampilkanUsername: int.tryParse(json['tampilkan_username'].toString()) ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_produk': idProduk,
      'rating_seller': ratingSeller,
      'komentar': komentar,
      'kualitas': kualitas, 
      'kegunaan': kegunaan ?? 'Sangat Bermanfaat',
      'tampilkan_username': tampilkanUsername, 
      'status': '1', // Default status untuk Laravel
    };
  }
}