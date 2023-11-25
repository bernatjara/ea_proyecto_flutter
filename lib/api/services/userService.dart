import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart'; // Encara no està implementat el model

class UserApiService {
  static const String _baseUrl = 'http://localhost:9090/users/';

  Future<Map<String, dynamic>> loginUser(
      String username, String password) async {
    String endpoint = 'login/login/login';
    try {
      final response = await http.post(
        Uri.parse(_baseUrl + endpoint),
        body: {
          'name': username,
          'password': password,
        },
      );

      // Verifica si la solicitud fue exitosa (código 201)
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
