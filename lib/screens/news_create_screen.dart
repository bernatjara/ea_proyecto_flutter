import 'package:ea_proyecto_flutter/screens/news_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateNewsScreen extends StatefulWidget {
  @override
  _CreateNewsScreenState createState() => _CreateNewsScreenState();
}

class _CreateNewsScreenState extends State<CreateNewsScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  Future<void> createNews() async {
    final String url = 'http://localhost:9090/news';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'title': titleController.text,
          'imageUrl': imageUrlController.text,
          'content': contentController.text,
        },
      );

      if (response.statusCode == 200) {
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
      } else {
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
    } catch (e) {
      // Maneja cualquier error de red u otros errores durante la solicitud
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
