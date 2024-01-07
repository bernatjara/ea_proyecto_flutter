import 'dart:convert';
import 'package:http/http.dart' as http;


class ChatService {
  static const String _baseUrl = 'http://localhost:9191';

  

  Future<Map<String, dynamic>> sendMessage(
    String roomId, String userId, String senderName, String message) async {

    String endpoint = '/message';
    try {
      final response = await http.post(
        Uri.parse(_baseUrl + endpoint),
        body: {
          'room': roomId,
          'userId': userId,
          'senderName': senderName,
          'message': message
        },
      );

      if (response.statusCode==200){
        return json.decode(response.body);
      } else {
        throw Exception('Error al enviar el missatge');
      }
        
    }catch (e) {
      throw Exception('Error al conectar con el servidor');
    }
  }
}
