import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ea_proyecto_flutter/api/services/asignaturaService.dart';

class SubjectsScreen extends StatefulWidget {
  @override
  _SubjectsScreenState createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  final AsignaturaApiService asignaturaApiService = AsignaturaApiService();
  Future<void> _getasignaturas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedId = prefs.getString('rol') ?? '';
    final responseData =
        await asignaturaApiService.GetAsignaturasById(storedId);
  }

  @override
  void initState() {
    super.initState();
    _getasignaturas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text('Notícies'),
        backgroundColor: Color.fromRGBO(0, 125, 204, 1.0),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navega a la pantalla de creación de noticias cuando se hace clic en el botón
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
      body: ListView.builder(
        itemCount: newsList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navega a la pantalla de detalles cuando se hace clic en una noticia
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailScreen(news: newsList[index]),
                ),
              );
            },
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(newsList[index].imageUrl,
                      height: 200, fit: BoxFit.cover),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      newsList[index].title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
