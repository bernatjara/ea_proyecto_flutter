import 'dart:convert';
import 'package:ea_proyecto_flutter/api/services/asignaturaService.dart';
import 'package:http/http.dart' as http;

//import '../models/news.dart'; // Encara no està implementat el model

class NewsApiService {
  static const String _baseUrl = 'http://localhost:9191/news';
  //static const String _baseUrl = 'http://192.168.1.140:9191/news';

  Future<void> createNews(
      String title, String imageUrl, String content, String token) async {
    try {
      DateTime now = DateTime.now();
      var data = {
        'title': title,
        'imageUrl': imageUrl,
        'content': content,
        'year': now.year,
        'month': now.month,
        'day': now.day
      };
      Map<String, String> headerContentType = {
        'Content-Type': 'application/json',
        'Authorization': token,
      };
      final response = await http.post(Uri.parse(_baseUrl),
          headers: headerContentType, body: jsonEncode(data));

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

  Future<String> deleteNews(String id, String token) async {
    try {
      Map<String, String> headerContentType = {
        'Content-Type': 'application/json',
        'Authorization': token,
      };
      String endpoint = '/$id';
      final response = await http.delete(
        Uri.parse(_baseUrl + endpoint),
        headers: headerContentType,
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

  Future<Map<String, dynamic>> updateNews({
    required String newsId,
    required String newTitle,
    required String title,
    required String imageUrl,
    required String content,
    required String token,
  }) async {
    try {
      var data = {
        'newTitle': newTitle,
        'title': title,
        'imageUrl': imageUrl,
        'content': content,
      };
      Map<String, String> headerContentType = {
        'Content-Type': 'application/json',
        'Authorization': token,
      };
      final response = await http.put(Uri.parse('$_baseUrl/$newsId'),
          headers: headerContentType, body: jsonEncode(data));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al actualizar la notícia');
      }
    } catch (e) {
      throw Exception('Error al conectar amb el servidor');
    }
  }

  Future<void> addCommentAndRating(String newsId, String text, double rating,
      String? username, String token) async {
    try {
      var data = {
        'username': username,
        'text': text,
        'rating': rating,
      };
      Map<String, String> headerContentType = {
        'Content-Type': 'application/json',
        'Authorization': token,
      };
      final response = await http.post(Uri.parse('$_baseUrl/$newsId'),
          headers: headerContentType, body: jsonEncode(data));

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

  Future<List<NewssItem2>> getAllNews() async {
    List<NewssItem2> newList = [];

    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        newList =
            responseData.map((data) => NewssItem2.fromJson(data)).toList();
        print('test en news $newList');
        return newList;
      } else {
        throw Exception('Usuario no encontrado');
      }
    } catch (e) {
      throw Exception('Error al conectar amb el servidor3');
    }
  }
}

class NewssItem {
  final String id;
  String title;
  final String imageUrl;
  final String content;
  List<Comments> comments;
  List<dynamic> ratings;

  NewssItem(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.content,
      required this.comments,
      required this.ratings});

  factory NewssItem.fromJson(Map<String, dynamic> json) {
    return NewssItem(
        id: json['_id'],
        title: json['title'],
        imageUrl: json['imageUrl'],
        content: json['content'],
        ratings: json['ratings'],
        comments: (json['comments'] as List<dynamic>)
            .map((commentData) => Comments.fromJson(commentData))
            .toList());
  }
}

class Comments {
  final String? username;
  final String? text;
  final double? rating;

  Comments({
    required this.username,
    required this.text,
    required this.rating,
  });

  // Add a factory method to create a Comment from JSON data
  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      username: json['username'],
      text: json['text'],
      rating: json['rating'].toDouble(),
    );
  }
}

class NewssItem2 {
  final String id;
  String title;
  final String imageUrl;
  final String content;
  List<Comments> comments;
  List<dynamic> ratings;
  int year;
  int month;
  int day;

  NewssItem2(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.content,
      required this.comments,
      required this.ratings,
      int? year,
      int? month,
      int? day})
      : year = year ?? 0,
        month = month ?? 0,
        day = day ?? 0;

  factory NewssItem2.fromJson(Map<String, dynamic> json) {
    return NewssItem2(
        id: json['_id'],
        title: json['title'],
        imageUrl: json['imageUrl'],
        content: json['content'],
        ratings: json['ratings'],
        year: json['year'] ?? 0,
        month: json['month'] ?? 0,
        day: json['day'] ?? 0,
        comments: (json['comments'] as List<dynamic>)
            .map((commentData) => Comments.fromJson(commentData))
            .toList());
  }
}
