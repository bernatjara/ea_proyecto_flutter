import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import '../main.dart';
/*import 'package:shared_preferences_web/shared_preferences_web.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;*/

class ConfigurationScreen extends StatefulWidget {
  @override
  _ConfigurationScreenState createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  String? adminMode;
  String? darkMode;
  String? rol = '';

  @override
  void initState() {
    super.initState();
    _loadConfigurationData();
  }

  Future<void> _loadConfigurationData() async {
    String? adminModeValue;
    String? darkModeValue;

    /*if (kIsWeb) {
      // Almacenamiento local para la web
      adminModeValue = html.window.localStorage['adminMode'];
      darkModeValue = html.window.localStorage['darkMode'];
    } else {*/
    SharedPreferences prefs = await SharedPreferences.getInstance();
    adminModeValue = prefs.getString('adminMode');
    darkModeValue = prefs.getString('darkMode') ?? '0';
    rol = prefs.getString('rol');
    //}
    darkMode = darkModeValue;
    adminMode = adminModeValue;
    setState(() {});    
  }

  Future<void> _toggleAdminMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('adminMode', adminMode == '1' ? '0' : '1');
    setState(() {
      adminMode = prefs.getString('adminMode') ?? '0';
    });
  }

  Future<void> _toggleDarkMode() async {
    /*if (kIsWeb) {
      // Almacenamiento local para la web
      html.window.localStorage['darkMode'] = darkMode == '1' ? '0' : '1';
    } else {*/
      // Almacenamiento local para dispositivos móviles
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('darkMode', darkMode == '1' ? '0' : '1');
    //}    
    /*if (kIsWeb) {
      darkMode = html.window.localStorage['darkMode'] ?? '0';
    } else {*/
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      darkMode = prefs.getString('darkMode') ?? '0';
    //}
    setState(() {
    _updateTheme();
    });
  }
  void _updateTheme() {
    bool isDarkModeEnabled = darkMode == '1';
    if (isDarkModeEnabled) {
      // Si darkMode está activado, establecer el tema oscuro
      MyApp.setTheme(context, ThemeData.dark());
    } else {
      // Si darkMode está desactivado, establecer el tema claro
      MyApp.setTheme(context, ThemeData.light());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuració'),
        backgroundColor: const Color.fromRGBO(0, 125, 204, 1.0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous screen
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if(rol == "admin")
            ListTile(
              title: Text('Mode Admin'),
              trailing: CupertinoSwitch(
                value: adminMode == '1',
                onChanged: (bool value){
                  _toggleAdminMode();
                },
              ),
            ),
            SizedBox(height: 16.0),
           ListTile(
              title: Text('Mode Fosc'),
              trailing: CupertinoSwitch(
                value: darkMode == '1',
                onChanged: (bool value){
                  _toggleDarkMode();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}