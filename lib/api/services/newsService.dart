import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news.dart'; // Encara no està implementat el model

class NewsApiService {
  static const String _baseUrl = 'http://localhost:9191/news';
  //static const String _baseUrl = 'http://192.168.1.140:9090/news';

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

  Future<Map<String, dynamic>> updateNews(
      {required String newsId,
      required String newTitle,
      required String title,
      required String imageUrl,
      required String content}) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$newsId'),
        body: {
          'newTitle': newTitle,
          'title': title,
          'imageUrl': imageUrl,
          'content': content,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al actualizar la notícia');
      }
    } catch (e) {
      throw Exception('Error al conectar amb el servidor');
    }
  }

  Future<void> addCommentAndRating(
      String newsId, String text, double rating, String? username) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$newsId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'username': username,
          'text': text,
          'rating': rating,
        }),
      );

      if (response.statusCode == 200) {
        // Comment and rating added successfully
      } else {
        // Handle the error case
        print('Error adding comment and rating: ${response.body}');
      }
    } catch (e) {
      // Handle any network or other errors
      print('Error: $e');
    }
  }
}
