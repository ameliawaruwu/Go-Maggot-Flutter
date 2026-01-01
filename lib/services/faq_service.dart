import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/faq_model.dart';
import '../config/api_config.dart';

class FaqService {
  Future<List<FaqModel>> fetchFaqs() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/faq'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data'];
      return data.map((item) => FaqModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data FAQ');
    }
  }
}