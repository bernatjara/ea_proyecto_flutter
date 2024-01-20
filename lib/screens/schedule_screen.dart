import 'dart:io';

import 'package:ea_proyecto_flutter/api/models/schedule.dart';
import 'package:flutter/material.dart';
import 'package:timetable_view/timetable_view.dart';
import 'package:ea_proyecto_flutter/api/services/asignaturaService.dart';
import 'package:ea_proyecto_flutter/api/services/scheduleService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;
//import 'dart:html' as html;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:cloudinary/cloudinary.dart';
import 'package:image_picker/image_picker.dart';

class ScheduleScreen2 extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class DayText extends StatelessWidget {
  final String day;
  final Color color;

  DayText({required this.day, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      day,
      style: TextStyle(
        color: color,
        fontSize: 18.0,
      ),
    );
  }
}

class _ScheduleScreenState extends State<ScheduleScreen2> {
  final AsignaturaApiService asignaturaApiService = AsignaturaApiService();
  late Future<List<NewItem>> futureAsignaturas;
  late Future<List<NewSchedule>> futureSchedules = Future.value([]);
  final ScheduleApiService scheduleApiService = ScheduleApiService();
  String? darkMode;
  Cloudinary? cloudinary;
  File? _imageFile;
  Uint8List webImage = Uint8List(8);
  String? _imageUrl;

  @override
  void initState() {
    _initializeData();
    super.initState();
    cloudinary = Cloudinary.signedConfig(
      apiKey: '248635653313453',
      apiSecret: 'mATgE6us-MJeNRGD29Y-dkR9tE0',
      cloudName: 'db2guqknt',
    );
  }

  Future<void> _initializeData() async {
    futureAsignaturas = _getasignaturas();
    List<NewItem> asignaturas = await futureAsignaturas;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (kIsWeb) {
      darkMode = html.window.localStorage['darkMode'];
    } else {
      darkMode = prefs.getString('darkMode');
    }
    setState(() {
      futureSchedules = _getSchedules();
    });
  }

  Future<List<NewItem>> _getasignaturas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedId;
    if (kIsWeb) {
      storedId = html.window.localStorage['id'] ?? '';
    } else {
      storedId = prefs.getString('id') ?? '';
    }
    return await asignaturaApiService.GetAsignaturasById(storedId);
  }

  Future<List<NewSchedule>> _getSchedules() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedYear;
    if (kIsWeb) {
      storedYear = html.window.localStorage['year'] ?? '2023';
    } else {
      storedYear = prefs.getString('year') ?? '2023';
    }
    return await scheduleApiService.GetAllSchedules(storedYear);
  }

  bool showProfileImage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horari'),
      ),
      body: FutureBuilder(
        future: Future.wait([futureAsignaturas, futureSchedules]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the data to be fetched
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // If the data has been successfully fetched
            List<NewItem> newList = snapshot.data?[0] as List<NewItem>;
            List<NewSchedule> newSchedule =
                snapshot.data?[1] as List<NewSchedule>;
            if (darkMode == '1') {
              return TimetableView(
                laneEventsList: _buildLaneEvents(newList, newSchedule),
                onEventTap: onEventTapCallBack,
                timetableStyle: const TimetableStyle(
                  startHour: 8,
                  endHour: 21,
                  mainBackgroundColor: Color.fromARGB(255, 65, 63, 63),
                  laneColor: Color.fromARGB(255, 65, 63, 63),
                  timelineColor: Color.fromARGB(255, 65, 63, 63),
                  timelineItemColor: Color.fromARGB(255, 65, 63, 63),
                  decorationLineBorderColor: Color.fromARGB(255, 65, 63, 63),
                  timelineBorderColor: Colors.black,
                  timeItemTextColor: Colors.blue,
                  cornerColor: Colors.black,
                ),
                onEmptySlotTap: onTimeSlotTappedCallBack,
              );
            } else {
              return TimetableView(
                laneEventsList: _buildLaneEvents(newList, newSchedule),
                onEventTap: onEventTapCallBack,
                timetableStyle: const TimetableStyle(
                  startHour: 8,
                  endHour: 21,
                ),
                onEmptySlotTap: onTimeSlotTappedCallBack,
              );
            }
          }
        },
      ),
    );
  }

  List<LaneEvents> _buildLaneEvents(
      List<NewItem> asignaturas, List<NewSchedule> schedules) {
    Map<String, List<TableEvent>> eventsMap = {};
    for (int i = 0; i < asignaturas.length; i++) {
      NewItem asignatura = asignaturas[i];
      for (int j = 0; j < schedules.length; j++) {
        NewSchedule schedule = schedules[j];
        if (schedule.name == asignatura.name) {
          String day = schedule.day;

          if (!eventsMap.containsKey(day)) {
            eventsMap["Dilluns"] = [];
            eventsMap["Dimarts"] = [];
            eventsMap["Dimecres"] = [];
            eventsMap["Dijous"] = [];
            eventsMap["Divendres"] = [];
          }
          if (darkMode == '1') {
            eventsMap[day]!.add(
              TableEvent(
                title: asignatura.name,
                backgroundColor: Color.fromARGB(255, 11, 10, 65),
                eventId: i,
                startTime: TableEventTime(hour: schedule.start, minute: 0),
                endTime: TableEventTime(hour: schedule.finish, minute: 0),
                laneIndex: i + 1,
              ),
            );
          } else {
            eventsMap[day]!.add(
              TableEvent(
                title: asignatura.name,
                eventId: i,
                startTime: TableEventTime(hour: schedule.start, minute: 0),
                endTime: TableEventTime(hour: schedule.finish, minute: 0),
                laneIndex: i + 1,
              ),
            );
          }
        }
      }
    }

    List<LaneEvents> laneEventsList = [];
    if (darkMode == '1') {
      eventsMap.forEach((day, events) {
        laneEventsList.add(
          LaneEvents(
            lane: Lane(
              name: day,
              laneIndex: laneEventsList.length + 1,
              backgroundColor: Color.fromARGB(255, 65, 63, 63),
              textStyle: const TextStyle(color: Colors.white),
            ),
            events: events,
          ),
        );
      });
    } else {
      eventsMap.forEach((day, events) {
        laneEventsList.add(
          LaneEvents(
            lane: Lane(name: day, laneIndex: laneEventsList.length + 1),
            events: events,
          ),
        );
      });
    }
    return laneEventsList;
  }

  void onTimeSlotTappedCallBack(
      int laneIndex, TableEventTime start, TableEventTime end) {
    print(
        "Empty Slot Clicked !! LaneIndex: $laneIndex StartHour: ${start.hour} EndHour: ${end.hour}");
  }

  void onEventTapCallBack(TableEvent event) async {
    List<NewItem> asignaturas = await futureAsignaturas;
    List<NewSchedule> schedules = await futureSchedules;

    if (event.eventId >= 0 && event.eventId < asignaturas.length) {
      NewItem asignatura = asignaturas[event.eventId];

      NewSchedule schedule = schedules.firstWhere(
        (s) => s.name == asignatura.name,
        orElse: () => NewSchedule(
            id: '', name: '', start: 0, finish: 0, day: '', clase: ''),
      );

      String className = schedule.clase;
      String imageName = showProfileImage
          ? className.substring(0, 3) +
              className.substring(3).toLowerCase() +
              '-perfil.png'
          : className.substring(0, 3) +
              className.substring(3).toLowerCase() +
              '.png';

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(asignatura.name),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(
                      'https://res.cloudinary.com/db2guqknt/image/upload/v1705746536/clase/$imageName'),
                  ElevatedButton(
                    onPressed: () {
                      // Cambiar entre la imagen original y la de perfil
                      setState(() {
                        showProfileImage = !showProfileImage;
                      });
                      Navigator.of(context).pop();

                      // Volver a abrir el diálogo con la nueva imagen
                      onEventTapCallBack(event);
                    },
                    child: Text('Canviar imatge'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
