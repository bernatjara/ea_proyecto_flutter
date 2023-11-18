import 'package:flutter/material.dart';
import 'package:ea_proyecto_flutter/widgets/button.dart';
import 'package:ea_proyecto_flutter/widgets/text_field.dart';
import 'package:http/http.dart' as http;
import '../screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  final Function()? onTap;
  const RegisterScreen({super.key, this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    // text editing controllers
    final usernameTextController = TextEditingController();
    final emailTextController = TextEditingController();
    final passwordTextController = TextEditingController();
    final confirmPasswordTextController = TextEditingController();

    const String apiUrl = 'http://localhost:9090/users';

    Future<void> _registerUser() async {
      if (usernameTextController.text.isEmpty ||
          emailTextController.text.isEmpty ||
          passwordTextController.text.isEmpty ||
          confirmPasswordTextController.text.isEmpty) {
        // Muestra un mensaje de error si algún campo está vacío
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Por favor, completa todos los campos'),
          ),
        );
        return; // Sale de la función si algún campo está vacío
      } else {
        if (passwordTextController.text != confirmPasswordTextController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Las contraseñas no coinciden'),
            ),
          );
          return;
        }
        try {
          final response = await http.post(
            Uri.parse(apiUrl),
            body: {
              'name': usernameTextController.text,
              'email': emailTextController.text,
              'password': passwordTextController.text,
              'rol': 'cliente',
            },
          );

          // Verifica si la solicitud fue exitosa (código 200)
          if (response.statusCode == 201) {
            // Registro exitoso, redirige a la pantalla de inicio de sesión
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          } else {
            // Muestra un mensaje de error si la solicitud no fue exitosa
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text('Error al registrar al usuario'),
              ),
            );
          }
        } catch (e) {
          // Maneja errores de conexión o cualquier otra excepción
          print('Error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Error al conectar con el servidor'),
            ),
          );
        }
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
                  Icons.app_registration_outlined,
                  color: Color.fromRGBO(0, 125, 204, 1.0),
                  size: 100,
                ),

                const SizedBox(height: 35),

                //welcome back message
                Text(
                  "Completa el siguiente formulario y disfruta de todas las funciones que tenemos preparadas para ti.",
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),

                const SizedBox(height: 30),

                //username textfield
                MyTextField(
                    controller: usernameTextController,
                    hintText: 'Nombre de usuario',
                    obscureText: false),

                const SizedBox(height: 25),

                //email textfield
                MyTextField(
                    controller: emailTextController,
                    hintText: 'E-mail',
                    obscureText: false),

                const SizedBox(height: 25),

                //password textfield
                MyTextField(
                    controller: passwordTextController,
                    hintText: 'Contraseña',
                    obscureText: true),

                const SizedBox(height: 25),

                //confirm password textfield
                MyTextField(
                    controller: confirmPasswordTextController,
                    hintText: 'Confirmar contraseña',
                    obscureText: true),

                const SizedBox(height: 25),

                //Sign up button
                MyButton(
                  onTap: _registerUser,
                  text: 'CREAR CUENTA',
                ),

                const SizedBox(height: 20),

                //go to login page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "¿Ya tienes cuenta?",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Inicia sesión",
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
