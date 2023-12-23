import 'package:ea_proyecto_flutter/api/services/userService.dart';
import 'package:ea_proyecto_flutter/widgets/button.dart';
import 'package:ea_proyecto_flutter/widgets/square_tile.dart';
import 'package:ea_proyecto_flutter/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ea_proyecto_flutter/screens/news_screen.dart';
import 'package:ea_proyecto_flutter/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({super.key, this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // api controller
  final UserApiService userApiService = UserApiService();

  // text editing controllers
  final usernameTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  /* Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = userCredential.user;

      final bool isResgisterd = await userApiService.loginUserGoogle();
      if (isResgisterd) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NewsScreen(),
          ),
        );
      }

      return userCredential;
    } catch (e) {
      print('Login amb Google ha fallat: $e');
      return null;
    }
  } */

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
      final responseData = await userApiService.loginUser(
        usernameTextController.text,
        passwordTextController.text,
      );

      // Si la solicitud fue exitosa (código 200)
      final String token = responseData['token'];
      final Map<String, dynamic> userData = responseData['user'];
      final String name = userData['name'];
      final String password = userData['password'];
      final String email = userData['email'];
      final String rol = userData['rol'];
      final String id = userData['_id'];
      final String image = userData['image'];
      //String image = '';
      String adminMode = '';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      prefs.setString('id', id);
      prefs.setString('name', name);
      prefs.setString('email', email);
      prefs.setString('password', password);
      prefs.setString('rol', rol);
      prefs.setString('adminMode', adminMode);
      prefs.setString('image', image);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NewsScreen(),
        ),
      );
    } catch (e) {
      // Maneja errores de conexión o cualquier otra excepción
      // ignore: avoid_print
      print('Error: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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

                const SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'O contiunua amb',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                //google button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    SquareTile(
                        onTap: () async {
                          try {
                            final user = await AuthService.signInWithGoogle();
                            if (user != null && mounted) {
                              /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewsScreen()),
                              ); */
                              print('User: $user');
                              print('User UID: $user.uid');
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Vamos bien')));
                            }
                          } on FirebaseAuthException catch (e) {
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text(e.message ?? 'Unknown error occurred'),
                            ));
                          } catch (e) {
                            print(e);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())));
                          }
                        },
                        imagePath: 'assets/images/google.png'),
                  ],
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
                      child: Text(
                        "Registra't",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()),
                      ),
                    )
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
