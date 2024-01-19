import 'package:ea_proyecto_flutter/screens/schedule_screen.dart';
import 'package:ea_proyecto_flutter/api/models/activity.dart';
import 'package:ea_proyecto_flutter/api/services/activitiesService.dart';
import 'package:ea_proyecto_flutter/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ea_proyecto_flutter/screens/news_screen.dart';
import 'package:ea_proyecto_flutter/screens/subjects_screen.dart';
import 'package:ea_proyecto_flutter/screens/activities_screen.dart';
import 'package:ea_proyecto_flutter/screens/group_screen.dart';
import 'package:universal_html/html.dart' as html;
//import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../screens/estadistica_screen.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarScreenState createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBar> {
  String storedName = '';
  String storedEmail = '';
  //String storedRol = '';
  String adminMode = '';

  @override
  void initState() {
    super.initState();
    _loadNavData();
  }

  Future<void> _loadNavData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (kIsWeb) {
      storedEmail = html.window.localStorage['email'] ?? '';
      storedName = html.window.localStorage['name'] ?? '';
      adminMode = html.window.localStorage['adminMode'] ?? '';
    } else {
      // Recupera los valores almacenados en SharedPreferences
      storedName = prefs.getString('name') ??
          ''; // Puedes establecer un valor predeterminado si es nulo
      storedEmail = prefs.getString('email') ?? '';
      //storedRol = prefs.getString('rol') ?? '';
      adminMode = prefs.getString('adminMode') ?? '';
      // Notifica al framework que el estado ha cambiado, para que se actualice en la pantalla
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //String username = widget.username;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('$storedName'),
            accountEmail: Text('$storedEmail'),
            /*currentAccountPicture: CircleAvatar(
              child: ClipOval(child: Image.asset('images/paine.png')),
            ),*/
            decoration: const BoxDecoration(
              color: Color.fromRGBO(0, 125, 204, 1.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Perfil'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserScreen()),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              leading: Icon(Icons.newspaper),
              title: Text('Notícies'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewsScreen()),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              leading: Icon(Icons.list_alt),
              title: Text('Assignatures'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SubjectsScreen()),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              leading: Icon(Icons.chat),
              title: Text('Xat'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GroupsScreen()),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              leading: Icon(Icons.list_alt),
              title: Text('Activitats'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FutureBuilder<List<ActivityModel>>(
                    future: ActivitiesApiService().getAllActivities(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return MapScreen(activityList: snapshot.data!);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              leading: Icon(Icons.access_time),
              title: Text('Horari'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScheduleScreen2()),
              ),
            ),
          ),
          if (adminMode == '1')
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTile(
                leading: Icon(Icons.list_alt),
                title: Text('Estadistica'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EstadisticaScreen()),
                ),
              ),
            ),
          /*
          if (storedRol == 'admin')
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: ListTile(
                  leading: Icon(Icons.admin_panel_settings),
                  title: Text('Modo admin'),
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('adminMode', adminMode == '1' ? '0' : '1');
                    // Actualiza el estado con el nuevo valor
                    setState(() {
                      adminMode = prefs.getString('adminMode') ?? '0';
                    });
                  }),
            ),*/
        ],
      ),
    );
  }
}
