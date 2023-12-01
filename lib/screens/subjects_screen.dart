import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ea_proyecto_flutter/api/services/asignaturaService.dart';

class SubjectsScreen extends StatefulWidget {
  @override
  _SubjectsScreenState createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  final List<NewItem> newList = [];
  final AsignaturaApiService asignaturaApiService = AsignaturaApiService();
  Future<void> _getasignaturas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedId = prefs.getString('id') ?? '';
    final newList = await asignaturaApiService.GetAsignaturasById(storedId);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text('Asignatures'),
        backgroundColor: Color.fromRGBO(0, 125, 204, 1.0),
      ),
      body: ListView.builder(
        itemCount: newList.length,
        itemBuilder: (context, index){
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      newList[index].name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
        }
          ));
        },
      ),
    );
  }
}
