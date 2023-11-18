import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  final String username;

  UserScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil de Usuario')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Usuario: $username'),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 700.0, right: 30.0),
        child: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 47, 40, 109),
          child: const Icon(Icons.add, color: Color(0xFFFFFCEA)),
          onPressed: () {
            //Navigator.pushNamed(context, '/create_user');
          },
          shape: CircleBorder(),
        ),
      ),
    );
  }
}
