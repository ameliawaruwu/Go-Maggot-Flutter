class ArtikelModel {
  final String idArtikel;
  final String judul;
  final String penulis;
  final String tanggal;
  final String gambar;
  final String gambarUrl; // Tambahkan ini
  final String konten;
  final String hakCipta;

  ArtikelModel({
    required this.idArtikel,
    required this.judul,
    required this.penulis,
    required this.tanggal,
    required this.gambar,
    required this.gambarUrl, // Tambahkan ini
    required this.konten,
    required this.hakCipta,
  });

  factory ArtikelModel.fromJson(Map<String, dynamic> json) {
    return ArtikelModel(
      idArtikel: json['id_artikel']?.toString() ?? '',
      judul: json['judul'] ?? '',
      penulis: json['penulis'] ?? '',
      tanggal: json['tanggal'] ?? '',
      gambar: json['gambar'] ?? '',
      gambarUrl: json['gambar_url'] ?? '', // Ambil URL lengkap dari API
      konten: json['konten'] ?? '',
      hakCipta: json['hak_cipta'] ?? '',
    );
  }
}