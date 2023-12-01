import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/asignatura.dart'; // Encara no està implementat el model

class AsignaturaApiService {
  static const String _baseUrl = 'http://localhost:9090/asignatura';

  Future<Map<List, dynamic>> GetAsignaturasById(String id) async {
    String endpoint = '/user/:id';
    try {
      final response = await http.get(
        Uri.parse(_baseUrl + endpoint),
      );

      // Verifica si la solicitud fue exitosa (código 201)
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        // Mapea la respuesta a objetos NewsItem
        List<NewItem> newList = [];
        newList = responseData.map((data) => NewItem.fromJson(data)).toList();
        return json.decode(newList);
      } else {
        throw Exception('Credencials incorrectes');
      }
    } catch (e) {
      throw Exception('Error al conectar amb el servidor');
    }
  }
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
