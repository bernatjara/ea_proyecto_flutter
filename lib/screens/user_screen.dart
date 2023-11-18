import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String storedName = '';
  String storedEmail = '';
  String storedRol = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Recupera los valores almacenados en SharedPreferences
    storedName = prefs.getString('name') ??
        ''; // Puedes establecer un valor predeterminado si es nulo
    storedEmail = prefs.getString('email') ?? '';
    storedRol = prefs.getString('rol') ?? '';

    // Notifica al framework que el estado ha cambiado, para que se actualice en la pantalla
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(storedName),
      appBar: AppBar(
        title: Text('Perfil de Usuario'),
        backgroundColor: Color.fromRGBO(0, 125, 204, 1.0),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            // Muestra los valores recuperados de SharedPreferences
            Text('Nombre: $storedName'),
            Text('Correo: $storedEmail'),
            Text('Rol: $storedRol'),
          ],
        ),
      ),
    );
  }
}
