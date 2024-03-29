import 'package:ea_proyecto_flutter/api/services/userService.dart';
import 'package:ea_proyecto_flutter/widgets/button.dart';
import 'package:ea_proyecto_flutter/widgets/square_tile.dart';
import 'package:ea_proyecto_flutter/widgets/text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ea_proyecto_flutter/screens/news_screen.dart';
import 'package:ea_proyecto_flutter/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/services/auth_service.dart';
import 'package:universal_html/html.dart' as html;
//import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  Future<void> _loginGoogleUser(User user) async {
    if (user.email != null) {
      String nickname = user.email!.split('@')[0];
      String pass = user.uid;

      try {
        final responseData = await userApiService.loginUser(
          nickname,
          pass,
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
        int year = 2023;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (kIsWeb) {
          html.window.localStorage['token'] = token;
          html.window.localStorage['id'] = id;
          html.window.localStorage['name'] = name;
          html.window.localStorage['email'] = email;
          html.window.localStorage['password'] = password;
          html.window.localStorage['rol'] = rol;
          html.window.localStorage['adminMode'] = adminMode;
          html.window.localStorage['image'] = image;
          html.window.localStorage['year'] = year.toString();
        } else {
          prefs.setString('token', token);
          prefs.setString('id', id);
          prefs.setString('name', name);
          prefs.setString('email', email);
          prefs.setString('password', password);
          prefs.setString('rol', rol);
          prefs.setString('adminMode', adminMode);
          prefs.setString('image', image);
          prefs.setString('year', year.toString());
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NewsScreen(),
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
  }

  Future<void> _loginUser() async {
    if (usernameTextController.text.isEmpty ||
        passwordTextController.text.isEmpty) {
      // Muestra un mensaje de error si algún campo está vacío
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(AppLocalizations.of(context)!.complete),
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
      int year = 2023;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (kIsWeb) {
        html.window.localStorage['token'] = token;
        html.window.localStorage['id'] = id;
        html.window.localStorage['name'] = name;
        html.window.localStorage['email'] = email;
        html.window.localStorage['password'] = password;
        html.window.localStorage['rol'] = rol;
        html.window.localStorage['adminMode'] = adminMode;
        html.window.localStorage['image'] = image;
        html.window.localStorage['year'] = year.toString();
      } else {
        prefs.setString('token', token);
        prefs.setString('id', id);
        prefs.setString('name', name);
        prefs.setString('email', email);
        prefs.setString('password', password);
        prefs.setString('rol', rol);
        prefs.setString('adminMode', adminMode);
        prefs.setString('image', image);
        prefs.setString('year', year.toString());
      }
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
      body: SingleChildScrollView(
        child: SafeArea(
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
                    AppLocalizations.of(context)!.welcomeBackMessage,
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),

                  const SizedBox(height: 30),

                  //email textfield
                  MyTextField(
                      controller: usernameTextController,
                      hintText: AppLocalizations.of(context)!.usernameHint,
                      obscureText: false),

                  const SizedBox(height: 25),

                  //password textfield
                  MyTextField(
                      controller: passwordTextController,
                      hintText: AppLocalizations.of(context)!.passwordHint,
                      obscureText: true),

                  const SizedBox(height: 25),

                  //Sign in button
                  MyButton(
                    onTap: _loginUser,
                    text: AppLocalizations.of(context)!.signInButton,
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
                            AppLocalizations.of(context)!.continueWith,
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
                                await _loginGoogleUser(user);
                              }
                            } on FirebaseAuthException catch (e) {
                              print(e);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
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
                        AppLocalizations.of(context)!.noAccount,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        child: Text(
                          AppLocalizations.of(context)!.register,
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
      ),
    );
  }
}
