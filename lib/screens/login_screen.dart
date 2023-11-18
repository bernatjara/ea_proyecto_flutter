import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'user_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // La URL de tu backend
  final String apiUrl = 'http://localhost:9090/users/login/login/login';

  get reponse => null;

  // Método para realizar la solicitud de inicio de sesión al backend
  Future<void> _loginUser() async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'name': _usernameController.text,
          'password': _passwordController.text,
        },
      );

      // Verifica si la solicitud fue exitosa (código 201)
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String token = responseData['token'];
        final Map<String, dynamic> userData = responseData['user'];
        final String name = userData['name'];
        final String password = userData['password'];
        final String email = userData['email'];
        final String rol = userData['rol'];
        final String id = userData['_id'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);
        prefs.setString('id', id);
        prefs.setString('name', name);
        prefs.setString('email', email);
        prefs.setString('password', password);
        prefs.setString('rol', rol);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserScreen()),
        );
      } else {
        // Muestra un mensaje de error si las credenciales son incorrectas o la solicitud no fue exitosa
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario o contraseña incorrectos'),
          ),
        );
      }
    } catch (e) {
      // Maneja errores de conexión o cualquier otra excepción
      // ignore: avoid_print
      print('Error: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al conectar con el servidor'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginUser,
              child: const Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
