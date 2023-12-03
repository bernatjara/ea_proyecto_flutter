import 'package:ea_proyecto_flutter/screens/news_screen.dart';
import 'package:ea_proyecto_flutter/api/services/newsService.dart';
import 'package:flutter/material.dart';

class CreateNewsScreen extends StatefulWidget {
  @override
  _CreateNewsScreenState createState() => _CreateNewsScreenState();
}

class _CreateNewsScreenState extends State<CreateNewsScreen> {
  final NewsApiService newsApiService = NewsApiService();
  TextEditingController titleController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  Future<void> createNews() async {
    if (titleController.text.isEmpty ||
        imageUrlController.text.isEmpty ||
        contentController.text.isEmpty) {
      // Muestra un mensaje de error si algún campo está vacío
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Sisplau, completa tots els camps'),
        ),
      );
      return;
    }

    try {
      await newsApiService.createNews(
        titleController.text,
        imageUrlController.text,
        contentController.text,
      );
      // La noticia se creó correctamente, puedes mostrar un mensaje y luego navegar de regreso a NewsScreen
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Noticia Creada'),
          content: Text('La noticia se creó correctamente.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsScreen(),
                  ),
                );
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Maneja el error si la creación de la noticia no fue exitosa
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(
              'Hubo un error al crear la noticia. Por favor, inténtalo de nuevo.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Noticia'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: imageUrlController,
              decoration: InputDecoration(labelText: 'URL de la Imagen'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Contenido'),
              maxLines: 4,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: createNews,
              child: Text('Crear Noticia'),
            ),
          ],
        ),
      ),
    );
  }
}
