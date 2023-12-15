import 'package:ea_proyecto_flutter/api/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:ea_proyecto_flutter/api/services/asignaturaService.dart';
import 'package:ea_proyecto_flutter/api/services/userService.dart';
import 'package:ea_proyecto_flutter/api/services/newsService.dart';
import '../widgets/navigation_drawer.dart';
//import 'package:graphic/graphic.dart';
//import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final AsignaturaApiService asignaturaApiService = AsignaturaApiService();
  late Future<List<NewItem>> futureAsignaturas;
  final UserApiService userApiService = UserApiService();
  late Future<List<UserModel>> futureUser;
  final NewsApiService newsApiService = NewsApiService();
  late Future<List<NewssItem2>> futureNews;
  DateTime now = DateTime.now();

  @override
  void initState() {
    futureAsignaturas = _getasignaturas();
    futureUser = _getUsers();
    futureNews = _getNews();
    super.initState();
  }

  Future<List<NewItem>> _getasignaturas() async {
    return await asignaturaApiService.GetAllAsignaturas();
  }

  Future<List<UserModel>> _getUsers() async {
    return await userApiService.getAllUsers();
  }

  Future<List<NewssItem2>> _getNews() async {
    return await newsApiService.getAllNews();
  }

  List<BarChartGroupData> getBarGroups(List<NewssItem2> Lista) {
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < 12; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i + 1,
          barRods: [
            BarChartRodData(
              y: newsInAMonth(i, Lista),
            ),
          ],
        ),
      );
    }

    return barGroups;
  }

  double newsInAMonth(int month, List<NewssItem2> Lista) {
    int i = 0;
    int counter = 0;
    int numNews = Lista.length;
    while (i < numNews) {
      if (Lista[i].month == now.month) {
        counter++;
      }
      i++;
    }
    return counter.toDouble();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text('Estadístiques'),
      ),
      body: FutureBuilder(
        future: Future.wait([futureAsignaturas, futureUser, futureNews]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the data to be fetched
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // If the data has been successfully fetched
            List<NewItem> asignaturesList = snapshot.data?[0] as List<NewItem>;
            List<UserModel> usersList = snapshot.data?[1] as List<UserModel>;
            List<NewssItem2> newsList = snapshot.data?[2] as List<NewssItem2>;

            int num = asignaturesList.length;
            int numUsers = usersList.length;
            int numNews = newsList.length;
            int i = 0;
            int counter = 0;
            while (i < numNews) {
              if (newsList[i].month == now.month) {
                counter++;
              }
              i++;
            }
            return Column(
              children: [
                Expanded(
                  child: Text('Número Asignatures: $num'),
                ),
                Expanded(
                  child: Text('Número Usuaris: $numUsers'),
                ),
                Expanded(
                  child: Text(
                      'Número Notícies: $numNews dels quals $counter es de aquest últim més'),
                ),
                Expanded(
                    child: BarChart(
                  BarChartData(
                    titlesData: FlTitlesData(
                      leftTitles: SideTitles(showTitles: true),
                      bottomTitles: SideTitles(showTitles: true),
                    ),
                    borderData: FlBorderData(
                      show: true,
                    ),
                    barGroups: getBarGroups(newsList),
                  ),
                ))
              ],
            );
          }
        },
      ),
    );
  }
}
