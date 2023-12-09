import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart'; // Encara no està implementat el model

class UserApiService {
  static const String _baseUrl = 'http://localhost:9090/users';
  //static const String _baseUrl = 'http://192.168.1.37:9090/users';

  Future<Map<String, dynamic>> loginUser(
      String username, String password) async {
    String endpoint = '/login';
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

  Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        body: {
          'name': username,
          'email': email,
          'password': password,
          'rol': 'client',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al registrar el usuario');
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor');
    }
  }

  Future<Map<String, dynamic>> updateUser({
    required String userId,
    required String username,
    required String email,
    required String password,
    required String newPassword,
    String endpoint = '/update',
  }) async {
    try {
      var data = {
        'name': username,
        'email': email,
        'password': password,
        'newPassword': newPassword,
      };
      final response =
          await http.put(Uri.parse('$_baseUrl/$endpoint/$userId'), body: data);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al actualizar el usuario');
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor');
    }
  }

  Future<Map<String, dynamic>> updateSubjects({
    required String userId,
    required String username,
    required String email,
    required String password,
    required String newPassword,
    List<String>? asignatura,
    String endpoint = '/editAsignaturas',
  }) async {
    print('1 $asignatura');
    try {
      print('2 $asignatura');
      var data = {
        'name': username,
        'email': email,
        'password': password,
        'newPassword': newPassword,
        'asignatura': asignatura,
      };
      print(data);
      Map<String, String> headerContentType = {
        'Content-Type': 'application/json'
      };
      final response = await http.put(Uri.parse('$_baseUrl/$endpoint/$userId'),
          headers: headerContentType, body: jsonEncode(data));
      print('3 $data');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al actualizar el usuario');
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor');
    }
  }
}
