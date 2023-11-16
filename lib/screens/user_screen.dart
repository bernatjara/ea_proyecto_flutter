import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  final String username;
  final String email;

  UserScreen({required this.username, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Perfil de Usuario')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Usuario: $username'),
            Text('Correo: $email'),
          ],
        ),
      ),
    );
  }
}
