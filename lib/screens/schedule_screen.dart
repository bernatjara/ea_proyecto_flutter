import 'package:ea_proyecto_flutter/api/models/schedule.dart';
import 'package:flutter/material.dart';
import 'package:timetable_view/timetable_view.dart';
import 'package:ea_proyecto_flutter/api/services/asignaturaService.dart';
import 'package:ea_proyecto_flutter/api/services/scheduleService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;
//import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:table_calendar/table_calendar.dart';

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

  @override
  void initState() {
    _initializeData();
    super.initState();
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
    return await scheduleApiService.GetAllSchedules();
  }

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

  void onEventTapCallBack(TableEvent event) {
    print(
        "Event Clicked!! LaneIndex ${event.laneIndex} Title: ${event.title} StartHour: ${event.startTime.hour} EndHour: ${event.endTime.hour}");
  }

  void onTimeSlotTappedCallBack(
      int laneIndex, TableEventTime start, TableEventTime end) {
    print(
        "Empty Slot Clicked !! LaneIndex: $laneIndex StartHour: ${start.hour} EndHour: ${end.hour}");
  }
}
