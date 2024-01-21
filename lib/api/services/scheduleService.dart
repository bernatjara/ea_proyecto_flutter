import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/schedule.dart'; // Encara no està implementat el model

class ScheduleApiService {
  static const String _baseUrl = 'http://localhost:9191/schedules';
  //static const String _baseUrl = 'http://147.83.7.155:9191/schedules';
  //static const String _baseUrl = 'http://192.168.1.136:9191/schedules';

  Future<List<NewSchedule>> GetSchedulesById(String id) async {
    String endpoint = '/asignatura/$id';
    List<NewSchedule> newList;

    try {
      final response = await http.get(Uri.parse(_baseUrl + endpoint));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        newList =
            responseData.map((data) => NewSchedule.fromJson(data)).toList();
        return newList;
      } else {
        throw Exception('Asignatura no encontrado');
      }
    } catch (e) {
      throw Exception('Error al conectar amb el servidor');
    }
  }

  Future<List<NewSchedule>> GetAllSchedules(String year) async {
    List<NewSchedule> newList = [];

    try {
      String endpoint = '/$year';
      final response = await http.get(Uri.parse(_baseUrl + endpoint));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        newList =
            responseData.map((data) => NewSchedule.fromJson(data)).toList();
        return newList;
      } else {
        throw Exception('Usuario no encontrado');
      }
    } catch (e) {
      throw Exception('Error al conectar amb el servidor');
    }
  }
}

class NewSchedule {
  final String id;
  final String name;
  final int start;
  final int finish;
  final String day;
  final String clase;

  NewSchedule(
      {required this.id,
      required this.name,
      required this.start,
      required this.finish,
      required this.day,
      required this.clase});

  factory NewSchedule.fromJson(Map<String, dynamic> json) {
    return NewSchedule(
      id: json['_id'],
      name: json['name'],
      start: json['start'],
      finish: json['finish'],
      day: json['day'],
      clase: json['clase'],
    );
  }
}
