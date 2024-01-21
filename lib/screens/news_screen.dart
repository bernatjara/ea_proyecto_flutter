//import 'package:ea_proyecto_flutter/screens/news_details_screen.dart';
import 'package:ea_proyecto_flutter/api/services/newsService.dart';
import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';
import 'package:ea_proyecto_flutter/screens/news_create_screen.dart';
import '../widgets/news_item_card.dart';
import 'package:universal_html/html.dart' as html;
//import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsApiService newsApiService = NewsApiService();
  List<NewsItem> newsList = [];
  String? adminMode = '';
  String? rol = '';
  @override
  void initState() {
    super.initState();
    _loadNewsData();
  }

  Future<void> _loadNewsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (kIsWeb) {
      adminMode = html.window.localStorage['adminMode'];
      rol = html.window.localStorage['rol'];
      if (rol != 'admin') {
        html.window.localStorage.remove('adminMode');
        html.window.localStorage.remove('rol');
      }
    } else {
      adminMode = prefs.getString('adminMode');
      rol = prefs.getString('rol');
      String? token = prefs.getString('token');
      if (rol != 'admin') {
        prefs.remove('adminMode');
        prefs.remove('rol');
      }
    }
    try {
      final List<dynamic> response = await newsApiService.readNews();
      // Mapea la respuesta a objetos NewsItem
      newsList = response.map((data) => NewsItem.fromJson(data)).toList();
      // Notifica al framework que el estado ha cambiado
      setState(() {});
    } catch (e) {
      print('Error: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error al conectar amb el servidor'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.news),
        backgroundColor: Color.fromRGBO(0, 125, 204, 1.0),
        actions: [
          if (adminMode == '1')
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateNewsScreen(),
                  ),
                );
              },
            ),
        ],
      ),
      body: _buildNewsList(),
    );
  }

  Widget _buildNewsList() {
    return ListView.builder(
      itemCount: newsList.length,
      itemBuilder: (context, index) {
        return NewsItemCard(news: newsList[index]);
      },
    );
  }
}

class NewsItem {
  final String id;
  String title;
  final String imageUrl;
  final String content;
  List<Comment> comments;
  List<dynamic> ratings;

  NewsItem(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.content,
      required this.comments,
      required this.ratings});

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
        id: json['_id'],
        title: json['title'],
        imageUrl: json['imageUrl'],
        content: json['content'],
        ratings: json['ratings'],
        comments: (json['comments'] as List<dynamic>)
            .map((commentData) => Comment.fromJson(commentData))
            .toList());
  }
}

class Comment {
  final String? username;
  final String? text;
  final double? rating;

  Comment({
    required this.username,
    required this.text,
    required this.rating,
  });

  // Add a factory method to create a Comment from JSON data
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      username: json['username'],
      text: json['text'],
      rating: json['rating'].toDouble(),
    );
  }
}
