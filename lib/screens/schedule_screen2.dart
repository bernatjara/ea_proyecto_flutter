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
      futureSchedules = _getSchedules(asignaturas[0].id);
    });
  }

  Future<List<NewItem>> _getasignaturas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedId = prefs.getString('id') ?? '';
    return await asignaturaApiService.GetAsignaturasById(storedId);
  }

  Future<List<NewSchedule>> _getSchedules(String asignaturaId) async {
    return await scheduleApiService.GetSchedulesById(asignaturaId);
  }

  List<LaneEvents> _buildLaneEvents(
      List<NewItem> newList, List<NewSchedule> newSchedule) {
    return [
      LaneEvents(
        lane: Lane(name: 'Lunes', laneIndex: 1),
        events: [
          TableEvent(
            title: newList[0].name,
            eventId: 11,
            startTime: TableEventTime(hour: newSchedule[0].start, minute: 0),
            endTime: TableEventTime(hour: newSchedule[0].finish, minute: 0),
            laneIndex: 1,
          ),
          TableEvent(
            eventId: 12,
            title: 'An event 2',
            laneIndex: 1,
            startTime: TableEventTime(hour: 12, minute: 0),
            endTime: TableEventTime(hour: 13, minute: 20),
          ),
        ],
      ),
      LaneEvents(
        lane: Lane(name: 'Martes', laneIndex: 2),
        events: [
          TableEvent(
            title: 'An event 3',
            laneIndex: 2,
            eventId: 21,
            startTime: TableEventTime(hour: 10, minute: 10),
            endTime: TableEventTime(hour: 11, minute: 45),
          ),
        ],
      ),
      LaneEvents(
        lane: Lane(name: 'Miercoles', laneIndex: 3),
        events: [
          TableEvent(
            title: 'An event 3',
            laneIndex: 2,
            eventId: 21,
            startTime: TableEventTime(hour: 10, minute: 10),
            endTime: TableEventTime(hour: 11, minute: 45),
          ),
        ],
      ),
      LaneEvents(
        lane: Lane(name: 'Jueves', laneIndex: 4),
        events: [
          TableEvent(
            title: 'An event 3',
            laneIndex: 2,
            eventId: 21,
            startTime: TableEventTime(hour: 10, minute: 10),
            endTime: TableEventTime(hour: 11, minute: 45),
          ),
        ],
      ),
      LaneEvents(
        lane: Lane(name: 'Viernes', laneIndex: 5),
        events: [
          TableEvent(
            title: 'An event 3',
            laneIndex: 2,
            eventId: 21,
            startTime: TableEventTime(hour: 10, minute: 10),
            endTime: TableEventTime(hour: 11, minute: 45),
          ),
        ],
      ),
    ];
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
                print('ayuda');
                // If the data has been successfully fetched
                List<NewItem> newList = snapshot.data?[0] as List<NewItem>;
                List<NewSchedule> newSchedule =
                    snapshot.data?[1] as List<NewSchedule>;
                print('ayuda2');
                return TimetableView(
                  laneEventsList: _buildLaneEvents(newList, newSchedule),
                  onEventTap: onEventTapCallBack,
                  timetableStyle: TimetableStyle(),
                  onEmptySlotTap: onTimeSlotTappedCallBack,
                );
              }
            }));
  }
}
