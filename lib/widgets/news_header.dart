import 'package:flutter/material.dart';
import '../screens/news_screen.dart';

class NewsHeader extends StatelessWidget {
  final NewsItem news;

  NewsHeader({required this.news});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(news.imageUrl, height: 200, fit: BoxFit.cover),
        SizedBox(height: 16),
        Text(
          news.title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Container(
          height: 200, // Ajusta según sea necesario
          child: SingleChildScrollView(
            child: Text(
              news.content,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}