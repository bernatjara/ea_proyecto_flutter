import 'dart:convert';
import 'package:http/http.dart' as http;

//import '../models/news.dart'; // Encara no està implementat el model

class EstadisticaApiService {
  //static const String _baseUrl = 'http://147.83.7.155:9191/news';
  static const String _baseUrl = 'http://localhost:9191/news';

  Future<List<dynamic>> dameNews() async {
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

  Future<List<dynamic>> dameUsers() async {
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

  Future<List<dynamic>> dameAsignaturas() async {
    try {
      const String _baseUrl = 'http://localhost:9191/asignaturas';
      //const String _baseUrl = 'http://147.83.7.155:9191/asignaturas';
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
}
