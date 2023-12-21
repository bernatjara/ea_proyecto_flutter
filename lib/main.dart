import 'package:ea_proyecto_flutter/auth/login_or_register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  static setTheme(BuildContext context, ThemeData theme) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setTheme(theme);
  }
}

class _MyAppState extends State<MyApp> {
  ThemeData _currentTheme = ThemeData.light();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EETAC App',
      theme: _currentTheme,
      home: LoginOrRegister(),
      debugShowCheckedModeBanner: false,
    );
  }

  void setTheme(ThemeData theme) {
    setState(() {
      _currentTheme = theme;
    });
  }
}
