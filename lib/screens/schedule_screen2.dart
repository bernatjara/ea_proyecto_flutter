import 'package:ea_proyecto_flutter/api/models/schedule.dart';
import 'package:flutter/material.dart';
import 'package:timetable_view/timetable_view.dart';
import 'package:ea_proyecto_flutter/api/services/asignaturaService.dart';
import 'package:ea_proyecto_flutter/api/services/scheduleService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleScreen2 extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen2> {
  final AsignaturaApiService asignaturaApiService = AsignaturaApiService();
  late Future<List<NewItem>> futureAsignaturas;
  late Future<List<NewSchedule>> futureSchedules = Future.value([]);
  final ScheduleApiService scheduleApiService = ScheduleApiService();

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  Future<void> _initializeData() async {
    futureAsignaturas = _getasignaturas();
    List<NewItem> asignaturas = await futureAsignaturas;
    setState(() {
      futureSchedules = _getSchedules();
    });
  }

  Future<List<NewItem>> _getasignaturas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedId = prefs.getString('id') ?? '';
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
                return TimetableView(
                  laneEventsList: _buildLaneEvents(newList, newSchedule),
                  onEventTap: onEventTapCallBack,
                  timetableStyle: TimetableStyle(),
                  onEmptySlotTap: onTimeSlotTappedCallBack,
                );
              }
            }));
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

    List<LaneEvents> laneEventsList = [];
    eventsMap.forEach((day, events) {
      laneEventsList.add(
        LaneEvents(
          lane: Lane(name: day, laneIndex: laneEventsList.length + 1),
          events: events,
        ),
      );
    });

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
