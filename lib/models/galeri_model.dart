class GaleriModel {
  final String idGaleri;
  final String? gambar;
  final String? keterangan;
  final String? gambarUrl;

  GaleriModel({
    required this.idGaleri,
    this.gambar,
    this.keterangan,
    this.gambarUrl,
  });

  factory GaleriModel.fromJson(Map<String, dynamic> json) {
    return GaleriModel(
      idGaleri: json['id_galeri'],
      gambar: json['gambar'],
      keterangan: json['keterangan'],
      // Kita menggunakan gambar_url yang dibuat oleh controller Laravel
      gambarUrl: json['gambar_url'],
    );
  }
}