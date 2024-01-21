import 'dart:convert';
import 'package:http/http.dart' as http;
//import '../models/asignatura.dart'; // Encara no està implementat el model

class AsignaturaApiService {
  //static const String _baseUrl = 'http://localhost:9191/asignaturas';
  static const String _baseUrl = 'http://147.83.7.155:9191/asignaturas';
  

  Future<List<NewItem>> GetAsignaturasById(String id) async {
    String endpoint = '/user/$id';
    List<NewItem> newList = [];

    try {
      final response = await http.get(Uri.parse(_baseUrl + endpoint));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        newList = responseData.map((data) => NewItem.fromJson(data)).toList();
        return newList;
      } else {
        throw Exception('Usuario no encontrado');
      }
    } catch (e) {
      throw Exception('Error al conectar amb el servidor');
    }
  }

  Future<List<NewItem>> GetAllAsignaturas() async {
    List<NewItem> newList = [];

    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        newList = responseData.map((data) => NewItem.fromJson(data)).toList();
        return newList;
      } else {
        throw Exception('Usuario no encontrado');
      }
    } catch (e) {
      throw Exception('Error al conectar amb el servidor');
    }
  }

  Future<Map<String, dynamic>> getAsignatura(String id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$id'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al carregar la asignatura');
      }
    } catch (e) {
      throw Exception('Error al conectar amb el servidor');
    }
  }
}

class NewItem {
  final String id;
  final String name;

  NewItem({required this.id, required this.name});

  factory NewItem.fromJson(Map<String, dynamic> json) {
    return NewItem(
      id: json['_id'],
      name: json['name'],
    );
  }
}
