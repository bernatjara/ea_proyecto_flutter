import 'package:ea_proyecto_flutter/screens/user_screen.dart';
import 'package:flutter/material.dart';
import '../screens/register_screen.dart';

class NavBar extends StatelessWidget {
  late String username;
  NavBar(username, {super.key});

  @override
  Widget build(BuildContext context) {
    //String username = widget.username;
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('username'),
            accountEmail: const Text('Email'),
            /*currentAccountPicture: CircleAvatar(
              child: ClipOval(child: Image.asset('images/paine.png')),
            ),*/
            decoration: const BoxDecoration(
              color: Colors.pinkAccent,
            ),
          ),
          ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Perfil'),
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  )),
        ],
      ),
    );
  }
}
