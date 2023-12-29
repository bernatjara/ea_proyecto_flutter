import 'package:ea_proyecto_flutter/screens/login_screen.dart';
import 'package:ea_proyecto_flutter/screens/register_screen.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  //initially, show the login screen
  bool showLoginScreen = true;
  String? darkMode;

  //toggle between login and register
  void toggleScreens() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }
  void _updateTheme() async{
    String? darkModeValue;

    if (kIsWeb) {
      // Almacenamiento local para la web
      darkModeValue = html.window.localStorage['darkMode'];
    } 
    else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      darkModeValue = prefs.getString('darkMode') ?? '0';
    }
    darkMode = darkModeValue;
    setState(() {});
    bool isDarkModeEnabled = darkMode == '1';
    if (isDarkModeEnabled) {
      // Si darkMode está activado, establecer el tema oscuro
      MyApp.setTheme(context, ThemeData.dark());
    } else {
      // Si darkMode está desactivado, establecer el tema claro
      MyApp.setTheme(context, ThemeData.light());
    }
  }
  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return LoginScreen(onTap: toggleScreens);
    } else {
      return RegisterScreen(onTap: toggleScreens);
    }
  }
}
