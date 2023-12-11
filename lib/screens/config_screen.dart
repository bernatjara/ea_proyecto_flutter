import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import '../auth/login_or_register.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App',
      theme: ThemeData.light(), // Establece el tema inicial
      darkTheme: ThemeData.dark(), // Establece el tema oscuro
      home: LoginOrRegister(),
    );
  }
}
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    adminMode = prefs.getString('adminMode');
    darkMode = prefs.getString('darkMode') ?? '0';
    rol = prefs.getString('rol');
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('darkMode', darkMode == '1' ? '0' : '1');
    setState(() {
      darkMode = prefs.getString('darkMode') ?? '0';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuració'),
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