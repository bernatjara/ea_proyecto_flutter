import 'dart:io';
import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> uploadImage(String imagePath) async {
  // Reemplaza con tus propias credenciales
  final cloudName = dotenv.env['CLOUD_NAME'];
  final apiKey = dotenv.env['API_KEY'];
  final apiSecret = dotenv.env['API_SECRET'];

  final url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

  // Cargar la imagen como bytes
  List<int> imageBytes = await File(imagePath).readAsBytes();
  String base64Image = base64Encode(imageBytes);

  // Crear la solicitud HTTP
  final response = await http.post(
    Uri.parse(url),
    body: {
      'file': 'data:image/jpeg;base64,$base64Image',
      'upload_preset': 'UPLOAD_PRESET', // Reemplaza con tu propio preset
      'api_key': apiKey,
    },
  );

  // Manejar la respuesta
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final imageUrl = data['secure_url'];
    print('Imagen subida exitosamente: $imageUrl');
  } else {
    print('Error al subir la imagen: ${response.statusCode}');
  }
}
