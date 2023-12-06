import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/asignatura.dart'; // Encara no està implementat el model

class AsignaturaApiService {
  static const String _baseUrl = 'http://localhost:9090/asignaturas';

  Future<List<NewItem>> GetAsignaturasById(String id) async {
    String endpoint = '/user/$id';
    List<NewItem> newList = [];

    //try {
    final response = await http.get(Uri.parse(_baseUrl + endpoint));
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      //newList = json.decode(response.body);
      final List<dynamic> responseData = json.decode(response.body);
      newList = responseData.map((data) => NewItem.fromJson(data)).toList();
      return newList;
    } else {
      throw Exception('Usuario no encontrado');
    }
  } /*catch (e) {
      throw Exception('Error al conectar amb el servidor');
    }
  }*/
}

class NewItem {
  final String name;

  NewItem({required this.name});

  factory NewItem.fromJson(Map<String, dynamic> json) {
    return NewItem(
      name: json['name'],
    );
  }
}
