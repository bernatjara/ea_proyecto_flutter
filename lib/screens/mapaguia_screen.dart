import 'package:flutter/material.dart';
import 'package:ea_proyecto_flutter/api/models/schedule.dart'; // Importa el modelo de schedule
import 'package:ea_proyecto_flutter/api/services/asignaturaService.dart'; // Importa el servicio de asignaturas
import 'package:ea_proyecto_flutter/api/services/scheduleService.dart'; // Importa el servicio de horarios
import 'package:ea_proyecto_flutter/api/services/userService.dart'; // Importa el servicio de horarios

class GuiaScreen extends StatefulWidget {
  @override
  _GuiaScreenState createState() => _GuiaScreenState();
}

class _GuiaScreenState extends State<GuiaScreen> {
  // Variables para almacenar información
  String dayOfWeek = '';
  String currentTime = '';
  List<NewItem> asignaturas = [];
  List<NewSchedule> horarios = [];
  String nextAsignatura = '';
  String nextHorario = '';

  // Servicios para obtener datos
  final AsignaturaApiService asignaturaApiService = AsignaturaApiService();
  final ScheduleApiService scheduleApiService = ScheduleApiService();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Obtener el día de la semana y la hora actual
    DateTime now = DateTime.now();
    dayOfWeek = _getDayOfWeek(now.weekday);
    currentTime = '${now.hour}:${now.minute}:${now.second}';

    // Obtener asignaturas del usuario
    asignaturas = await asignaturaApiService.GetAsignaturasById('user.id'); 

    // Obtener horarios de cada asignatura
    for (NewItem asignatura in asignaturas) {
      List<NewSchedule> horariosAsignatura = await scheduleApiService.GetSchedulesById(asignatura.id);
      horarios.addAll(horariosAsignatura);
    }

    // Filtrar asignaturas y horarios para obtener solo los futuros
    List<NewSchedule> futureHorarios = horarios.where((horario) {
      return _isFutureHorario(horario, now);
    }).toList();

    // Ordenar la lista de futuros horarios por tiempo
    futureHorarios.sort((a, b) => a.start.compareTo(b.start));

    // Obtener la próxima asignatura y su horario
    if (futureHorarios.isNotEmpty) {
      nextAsignatura = asignaturas.firstWhere((asignatura) => asignatura.id == futureHorarios.first.id).name;
      nextHorario = '${futureHorarios.first.day} ${futureHorarios.first.start}-${futureHorarios.first.finish}';
    }

    // Actualizar el estado para que se vuelva a construir con la nueva información
    setState(() {});
  }

  bool _isFutureHorario(NewSchedule horario, DateTime now) {
    // Comprobar si el horario es en el futuro
    DateTime horarioDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      horario.start ~/ 100, // Obtener la parte entera de la hora (ejemplo: 930 -> 9)
      horario.start % 100, // Obtener los minutos (ejemplo: 930 -> 30)
    );
    return horarioDateTime.isAfter(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Próxima Asignatura'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current Day of Week:',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '$dayOfWeek',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Current Time:',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '$currentTime',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Next Asignatura:',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              nextAsignatura,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Next Horario:',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              nextHorario,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  String _getDayOfWeek(int dayIndex) {
    // Convertir el número del día de la semana a su nombre correspondiente
    switch (dayIndex) {
      case 1:
        return 'Lunes';
      case 2:
        return 'Martes';
      case 3:
        return 'Miércoles';
      case 4:
        return 'Jueves';
      case 5:
        return 'Viernes';
      case 6:
        return 'Sábado';
      case 7:
        return 'Domingo';
      default:
        return '';
    }
  }
}



