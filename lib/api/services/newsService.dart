import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news.dart'; // Encara no està implementat el model

class NewsApiService {
  static const String _baseUrl = 'http://localhost:9090/news';

  Future<void> createNews(String title, String imageUrl, String content) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {
          'title': title,
          'imageUrl': imageUrl,
          'content': content,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Credencials incorrectes');
      }
    } catch (e) {
      throw Exception('Error al conectar amb el servidor');
    }
  }

  Future<List<dynamic>> readNews() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Credencials incorrectes');
      }
    } catch (e) {
      throw Exception('Error al conectar amb el servidor');
    }
  }

  Future<String> deleteNews(String id) async {
    try {
      String endpoint = '/$id';
      final response = await http.delete(
        Uri.parse(_baseUrl + endpoint),
      );

      if (response.statusCode == 200) {
        return '1';
      } else {
        throw Exception('Credencials incorrectes');
      }
    } catch (e) {
      throw Exception('Error al conectar amb el servidor');
    }
  }
}
