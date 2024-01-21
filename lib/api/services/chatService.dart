import 'dart:convert';
import 'package:ea_proyecto_flutter/api/models/message.dart';
import 'package:http/http.dart' as http;

class ChatService {
  static const String _baseUrl = 'http://localhost:9191/chats';

  Future<String> createEmptyChat(String roomId) async {
    final url = Uri.parse(_baseUrl);
    final chatData = jsonEncode({
      'roomId': roomId,
      'conversation': [],
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: chatData,
      );

      if (response.statusCode == 200) {
        final chat = jsonDecode(response.body);
        final chatId = chat['_id'];
        return chatId; // Devuelve el ID del chat vacío creado
      } else {
        print('Error al crear el chat vacío: ${response.statusCode}');
        throw Exception('Error al crear el chat vacío');
      }
    } catch (error) {
      print('Error al crear el chat vacío: $error');
      throw Exception('Error al crear el chat vacío');
    }
  }

  Future<Map<String, dynamic>> sendMessage(String chatId, String roomId,
      String userId, String senderName, String message) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$chatId'),
        body: {
          'roomId': roomId,
          'idUser': userId,
          'senderName': senderName,
          'message': message
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al enviar el missatge');
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor');
    }
  }

  Future<List<MsgModel>> getChatMessages(String chatId) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$chatId'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> conversation = responseData['conversation'];
        List<MsgModel> messages = conversation.map((msgData) {
          return MsgModel(
            idUser: msgData['idUser'],
            senderName: msgData['senderName'],
            message: msgData['message'],
          );
        }).toList();
        return messages;
      } else {
        throw Exception('Error al carregar els missatges');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
