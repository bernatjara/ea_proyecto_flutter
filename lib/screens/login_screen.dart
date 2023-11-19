import 'package:ea_proyecto_flutter/widgets/button.dart';
import 'package:ea_proyecto_flutter/widgets/text_field.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'user_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ea_proyecto_flutter/screens/news_screen.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({super.key, this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    // text editing controllers
    final usernameTextController = TextEditingController();
    final passwordTextController = TextEditingController();

    const String apiUrl = 'http://localhost:9090/users/login/login/login';

    Future<void> _loginUser() async {
      if (usernameTextController.text.isEmpty ||
          passwordTextController.text.isEmpty) {
        // Muestra un mensaje de error si algún campo está vacío
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Sisplau, completa tots els camps'),
          ),
        );
        return; // Sale de la función si algún campo está vacío
      }

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          body: {
            'name': usernameTextController.text,
            'password': passwordTextController.text,
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
            MaterialPageRoute(
              builder: (context) => NewsScreen(),
            ),
          );
        } else {
          // Muestra un mensaje de error si las credenciales son incorrectas o la solicitud no fue exitosa
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Usuari o contrasenya incorrectes'),
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
            backgroundColor: Colors.red,
            content: Text('Error al conectar amb el servidor'),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                const Icon(
                  Icons.lock_person_rounded,
                  color: Color.fromRGBO(0, 125, 204, 1.0),
                  size: 100,
                ),

                const SizedBox(height: 35),

                //welcome back message
                Text(
                  "Hola de nou! Estem feliços de veure't",
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),

                const SizedBox(height: 30),

                //email textfield
                MyTextField(
                    controller: usernameTextController,
                    hintText: 'Nom de usuari',
                    obscureText: false),

                const SizedBox(height: 25),

                //password textfield
                MyTextField(
                    controller: passwordTextController,
                    hintText: 'Contrasenya',
                    obscureText: true),

                const SizedBox(height: 25),

                //Sign in button
                MyButton(
                  onTap: _loginUser,
                  text: 'INICIAR SESSIÓ',
                ),

                const SizedBox(height: 20),

                //go to register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "¿No tens compte?",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Registra't",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
