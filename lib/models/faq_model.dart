class FaqModel {
  final String idFaq;
  final String pertanyaan;
  final String jawaban;

  FaqModel({required this.idFaq, required this.pertanyaan, required this.jawaban});

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      idFaq: json['id_faq'] ?? '', // Harus sama dengan protected $fillable di Laravel
      pertanyaan: json['pertanyaan'] ?? '',
      jawaban: json['jawaban'] ?? '',
    );
  }
}