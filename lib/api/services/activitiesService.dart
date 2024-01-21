import 'dart:convert';
import 'package:ea_proyecto_flutter/api/models/activity.dart';
import 'package:http/http.dart' as http;
//import '../models/activities.dart'; // Encara no està implementat el model

class ActivitiesApiService {
  static const String _baseUrl = 'http://localhost:9191/activities';
  //static const String _baseUrl = 'http://147.83.7.155:9191/activities';
  //static const String _baseUrl = 'http://192.168.1.136:9191/activities';

  Future<List<ActivityModel>> getAllActivities() async {
    //String endpoint = '/activity/getAll';
    List<ActivityModel> activityList = [];

    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        activityList =
            responseData.map((data) => ActivityModel.fromJson(data)).toList();
        return activityList;
      } else {
        throw Exception('Error al obtener las actividades');
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor');
    }
  }
}
