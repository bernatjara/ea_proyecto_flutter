import 'package:ea_proyecto_flutter/auth/login_or_register.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/news_screen.dart';
import 'dart:html' as html;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
  _loadInitData();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  static setTheme(BuildContext context, ThemeData theme) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setTheme(theme);
  }
}

String? token;
String? darkMode;
ThemeData? _currentTheme;
Future<void> _loadInitData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (kIsWeb) {
    token = html.window.localStorage['token'];
    darkMode = html.window.localStorage['darkMode'];
  } else {
    token = prefs.getString('token');
    darkMode = prefs.getString('darkMode');
  }
  if (darkMode == '1') {
    _currentTheme = ThemeData.dark();
  } else {
    _currentTheme = ThemeData.light();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    if (token != null) {
      return MaterialApp(
        title: 'EETAC App',
        theme: _currentTheme,
        home: NewsScreen(),
        debugShowCheckedModeBanner: false,
      );
    } else {
      return MaterialApp(
        title: 'EETAC App',
        theme: _currentTheme,
        home: LoginOrRegister(),
        debugShowCheckedModeBanner: false,
      );
    }
  }

  void setTheme(ThemeData theme) {
    setState(() {
      _currentTheme = theme;
    });
  }
}
