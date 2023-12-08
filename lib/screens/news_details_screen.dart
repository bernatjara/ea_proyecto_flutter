import 'package:ea_proyecto_flutter/screens/news_screen.dart';
import 'package:ea_proyecto_flutter/screens/news_update_screen.dart';
import 'package:ea_proyecto_flutter/api/services/newsService.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsDetailScreen extends StatefulWidget {
  final NewsItem news;
  NewsDetailScreen({required this.news});
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final NewsApiService newsApiService = NewsApiService();
  TextEditingController commentController = TextEditingController();
  double userRating = 0.0;
  String? adminMode = '';
  @override
  void initState() {
    _loadNewsData();
    super.initState();
  }

  Future<void> _loadNewsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    adminMode = prefs.getString('adminMode');

    setState(() {});
  }

  Future<void> _deleteNewsData() async {
    String id = widget.news.id;
    try {
      await newsApiService.deleteNews(id);
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

  Future<void> _addCommentAndRating() async {
    String comment = commentController.text;
    double rating = userRating;
    await newsApiService.addCommentAndRating(widget.news.id, comment, rating);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isNewsDetailScreen = true;
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text('Notícies'),
        backgroundColor: Color.fromRGBO(0, 125, 204, 1.0),
        leading: isNewsDetailScreen
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
        actions: [
          if (adminMode == '1')
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            "Borrar Notícia",
                            style: TextStyle(fontSize: 20),
                          ),
                          content: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Text(
                                "¿Estàs segur que vols borrar la notícia?"),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                await _deleteNewsData();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewsScreen()),
                                    (route) => false);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                side: BorderSide.none,
                              ),
                              child: const Text("Sí"),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Cierra el diálogo
                              },
                              child: const Text("No"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.mode),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NewsUpdateScreen(news: widget.news)),
                    );
                  },
                ),
              ],
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.news.imageUrl, height: 200, fit: BoxFit.cover),
            SizedBox(height: 16),
            Text(
              widget.news.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              widget.news.content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: commentController,
                    decoration:
                        InputDecoration(labelText: 'Afegeix un comentari'),
                  ),
                  RatingBar.builder(
                    initialRating: userRating,
                    minRating: 0,
                    maxRating: 5,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (value) {
                      setState(() {
                        userRating = value;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _addCommentAndRating();
                    },
                    child: Text('Afegeix el comentari'),
                  ),
                ],
              ),
            ),
            if (widget.news.comments.isNotEmpty) ...[
              Text('Comentaris:'),
              for (Comment comment in widget.news.comments)
                Text('${comment.username}: ${comment.text}'),
            ],
            Text('Rating midjana: ${widget.news.averageRating}'),
          ],
        ),
      ),
    );
  }
}
