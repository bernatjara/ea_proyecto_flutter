import 'package:ea_proyecto_flutter/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ea_proyecto_flutter/screens/news_screen.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarScreenState createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBar> {
  String storedName = '';
  String storedEmail = '';
  String storedRol = '';

  @override
  void initState() {
    super.initState();
    _loadNavData();
  }

  Future<void> _loadNavData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Recupera los valores almacenados en SharedPreferences
    storedName = prefs.getString('name') ??
        ''; // Puedes establecer un valor predeterminado si es nulo
    storedEmail = prefs.getString('email') ?? '';

    // Notifica al framework que el estado ha cambiado, para que se actualice en la pantalla
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //String username = widget.username;
    return Drawer(
      child: ListView(
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
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Perfil'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserScreen()),
            ),
          ),
          ListTile(
            leading: Icon(Icons.newspaper),
            title: Text('Notícies'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewsScreen()),
            ),
          )
        ],
      ),
    );
  }
}
