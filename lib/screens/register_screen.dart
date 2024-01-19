import 'package:ea_proyecto_flutter/api/services/auth_service.dart';
import 'package:ea_proyecto_flutter/api/services/userService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ea_proyecto_flutter/widgets/button.dart';
import 'package:ea_proyecto_flutter/widgets/text_field.dart';
import 'package:flutter_pw_validator/Resource/Strings.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../screens/login_screen.dart';
import 'package:ea_proyecto_flutter/widgets/square_tile.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  final Function()? onTap;
  const RegisterScreen({super.key, this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class CatalanStrings implements FlutterPwValidatorStrings {
  @override
  final String atLeast = '- Carácters com a mínim';
  @override
  final String uppercaseLetters = '- Lletres majuscules';
  @override
  final String numericCharacters = '- Números';
  @override
  final String lowercaseLetters = '- Lletres míniscules';
  @override
  final String normalLetters = '- Lletras normals';
  @override
  final String specialCharacters = '- Caracteres especiales';
}

class _RegisterScreenState extends State<RegisterScreen> {
  // api controller
  bool passwordValid = false;
  final UserApiService userApiService = UserApiService();
  final usernameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  final GlobalKey<FlutterPwValidatorState> pwValidatorKey =
      GlobalKey<FlutterPwValidatorState>();

  /* Future<void> _registerWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // El usuario cancela el registro con Google
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String email = googleUser.email;
      final String username = googleUser.displayName ?? email.split('@')[0]; // Si no me devuelve el nombre de usuario agarro hasta el @ del mail
      final String password = ''; // Google no devuelve un password
      await userApiService.registerWithGoogle( username: username,email:email,password:password);

      Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );

    } catch (e) {
      // Maneja errores
      print('Error al registrar amb Google: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error al registrar amb Google'),
        ),
      );
    }
  }
 */

  @override
  Widget build(BuildContext context) {
    // text editing controllers

    Future<void> _registerUser() async {
      if (usernameTextController.text.isEmpty ||
          emailTextController.text.isEmpty ||
          passwordTextController.text.isEmpty ||
          confirmPasswordTextController.text.isEmpty) {
        // Muestra un mensaje de error si algún campo está vacío
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Sisplau, completa tots els camps'),
          ),
        );
        return; // Sale de la función si algún campo está vacío
      } else {
        if (passwordTextController.text != confirmPasswordTextController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Les contrasenyes no coincideixen'),
            ),
          );
          return;
        }
        if (!passwordValid) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('La contraseña no cumple con los requisitos.'),
            ),
          );
          return;
        }

        try {
          userApiService.registerUser(
            username: usernameTextController.text,
            email: emailTextController.text,
            password: passwordTextController.text,
          );

          // Si la solicitud fue exitosa (código 200)
          // Registro exitoso, redirige a la pantalla de inicio de sesión
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        } catch (e) {
          // Maneja errores de conexión o cualquier otra excepción
          print('Error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(e.toString()),
            ),
          );
        }
      }
    }

    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: Container(
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
                      "Completa el següent formulari i disfruta de totes les funcions que tenim preparades per a tu.",
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),

                    const SizedBox(height: 30),

                    //username textfield
                    MyTextField(
                        controller: usernameTextController,
                        hintText: 'Nom de usuari',
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
                      obscureText: true,
                      hintText: 'Contrasenya',
                    ),

                    const SizedBox(height: 25),

                    //confirm password textfield
                    MyTextField(
                        controller: confirmPasswordTextController,
                        hintText: 'Confirmar contrasenya',
                        obscureText: true),
                    FlutterPwValidator(
                      key: pwValidatorKey,
                      controller: passwordTextController,
                      defaultColor: Colors.red,
                      successColor: Colors.green,
                      failureColor: Colors.red,
                      minLength: 8,
                      uppercaseCharCount: 1,
                      numericCharCount: 3,
                      lowercaseCharCount: 2,
                      width: 400,
                      height: 125,
                      strings: CatalanStrings(),
                      onSuccess: () {
                        setState(() {
                          passwordValid = true;
                        });
                      },
                      onFail: () {
                        setState(() {
                          passwordValid = false;
                        });
                      },
                    ),
                    const SizedBox(height: 25),
                    //Sign up button
                    MyButton(
                      onTap: _registerUser,
                      text: 'CREAR COMPTE',
                    ),

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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
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
                                final user =
                                    await AuthService.signInWithGoogle();
                                if (user != null && mounted) {
                                  try {
                                    await userApiService.registerGoogleUser(
                                        username: user.email!.split('@')[0],
                                        email: user.email!,
                                        password: user.uid,
                                        image: user.photoURL ??
                                            'https://sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png');
                                    // Si la solicitud fue exitosa (código 200)
                                    // Registro exitoso, redirige a la pantalla de inicio de sesión
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(e.toString()),
                                      ),
                                    );
                                  }
                                }
                              } on FirebaseAuthException catch (e) {
                                print(e);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                      e.message ?? 'Unknown error occurred'),
                                ));
                              } catch (e) {
                                print(e);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(e.toString())));
                              }
                            },
                            imagePath: 'assets/images/google.png'),
                      ],
                    ),

                    const SizedBox(height: 20),

                    //go to login page
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Ja tens compte?",
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          child: Text(
                            "Inicia sessió",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
