import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';
//import '../api/services/estadisticaService.dart';
import 'package:fl_chart/fl_chart.dart';
import '../api/services/asignaturaService.dart';
import '../api/services/newsService.dart';
import '../api/services/userService.dart';

class EstadisticaScreen extends StatefulWidget {
  @override
  _EstadisticaScreenState createState() => _EstadisticaScreenState();
}

class _EstadisticaScreenState extends State<EstadisticaScreen> {
  //final EstadisticaApiService estadisticaApiService = EstadisticaApiService();
  final AsignaturaApiService asignaturaApiService = AsignaturaApiService();
  final UserApiService userApiService = UserApiService();
  final NewsApiService newsApiService = NewsApiService();
  List<dynamic> newsList = [];
  List<dynamic> userList = [];
  List<dynamic> asignaturaList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _loadEstadisticaData();
    });
  }

  Future<void> _loadEstadisticaData() async {
    try {
      newsList = await newsApiService.readNews();
      userList = await userApiService.readUser();
      asignaturaList = await asignaturaApiService.GetAllAsignaturas();
      // Mapea la respuesta a objetos NewsItem
      // Notifica al framework que el estado ha cambiado
      setState(() {});
    } catch (e) {
      print('Error: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error al conectar amb el servidor'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text('Estadísticas'),
        backgroundColor: Color.fromRGBO(0, 125, 204, 1.0),
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text('Número de Usuarios: ${userList.length}'),
            //Text('Número de Noticias: ${newsList.length}'),
            //Text('Número de Asignaturas: ${asignaturaList.length}'),
            SizedBox(height: 20),
            Text('Gráfico de Usuarios, Noticias y Asignaturas',
                style: TextStyle(fontSize: 24.0)),
            _buildCombinedChart(),
            SizedBox(height: 20),
            Text('Gráfico de Noticias por Mes',
                style: TextStyle(fontSize: 24.0)),
            _buildMonthlyChart(),
            SizedBox(height: 20),
            //Text('Gráfico de Comentarios por Día de la Semana'),
            //_buildDailyCommentsChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildCombinedChart() {
    return Container(
      width: 600, // Ajusta el ancho según tus necesidades
      height: 300, // Ajusta la altura según tus necesidades
      child: BarChart(
        BarChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: SideTitles(showTitles: false),
            topTitles: SideTitles(showTitles: false),
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value, _) => const TextStyle(color: Colors.black),
              margin: 16,
              getTitles: (double value) {
                // Retorna la leyenda para cada barra
                switch (value.toInt()) {
                  case 0:
                    return 'Usuarios';
                  case 1:
                    return 'Noticias';
                  case 2:
                    return 'Asignaturas';
                  default:
                    return '';
                }
              },
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1),
          ),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  y: userList.length.toDouble(),
                  colors: [Colors.blue],
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  y: newsList.length.toDouble(),
                  colors: [Colors.green],
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  y: asignaturaList.length.toDouble(),
                  colors: [Colors.orange],
                ),
              ],
            ),
          ],
          groupsSpace: 4,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyChart() {
    // Crear un mapa para contar noticias por mes
    Map<String, int> monthlyCounts = {};

    // Contar noticias por mes
    for (var news in newsList) {
      String month = news['mes']; // Ajusta según la estructura de tus datos
      monthlyCounts[month] = (monthlyCounts[month] ?? 0) + 1;
    }

    List<String> months = monthlyCounts.keys.toList();
    List<int> counts = monthlyCounts.values.toList();

    return Container(
      width: 600, // Ajusta el ancho según tus necesidades
      height: 300, // Ajusta la altura según tus necesidades
      child: BarChart(
        BarChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: SideTitles(showTitles: false),
            rightTitles: SideTitles(showTitles: false),
            topTitles: SideTitles(showTitles: false),
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value, _) => const TextStyle(color: Colors.black),
              margin: 16,
              getTitles: (double value) {
                // Retorna la leyenda para cada barra
                return months[value.toInt()];
              },
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xff37434d), width: 1),
          ),
          barGroups: List.generate(
            months.length,
            (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  y: counts[index].toDouble(),
                  colors: [Colors.blue],
                ),
              ],
            ),
          ),
          groupsSpace: 4,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ),
      ),
    );
  }
/*Widget _buildDailyCommentsChart() {
  // Crear un mapa para contar comentarios por día de la semana
  Map<String, int> dailyCommentCounts = {
    'Monday': 0,
    'Tuesday': 0,
    'Wednesday': 0,
    'Thursday': 0,
    'Friday': 0,
    'Saturday': 0,
    'Sunday': 0,
  };

  // Contar comentarios por día de la semana
  for (var news in newsList) {
    for (var comment in news['comments']) {
      String dayOfWeek = comment['diaSemana']; // Ajusta según tu estructura de comentarios
      dailyCommentCounts[dayOfWeek] = (dailyCommentCounts[dayOfWeek] ?? 0) + 1;
    }
  }

  List<String> daysOfWeek = dailyCommentCounts.keys.toList();
  List<int> counts = dailyCommentCounts.values.toList();

  return BarChart(
    BarChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1),
      ),
      barGroups: List.generate(
        daysOfWeek.length,
        (index) => BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              y: counts[index].toDouble(),
              colors: [Colors.green],
            ),
          ],
        ),
      ),
      groupsSpace: 4,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.greenAccent,
        ),
      ),
    ),
  );
}*/
}
