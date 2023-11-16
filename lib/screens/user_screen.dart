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
    );
  }
}
