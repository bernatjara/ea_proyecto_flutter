import 'package:ea_proyecto_flutter/auth/login_or_register.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/news_screen.dart';
import 'package:universal_html/html.dart' as html;
import 'api/services/userService.dart';
//import 'dart:html' as html;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

String token = '';
String? darkMode;
String id = '';
ThemeData _currentTheme = ThemeData.light();
final UserApiService userApiService = UserApiService();

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoggedInStatus();
  }

  Future<void> _checkLoggedInStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (kIsWeb) {
        token = await html.window.localStorage['token'] ?? '';
        darkMode = await html.window.localStorage['darkMode'];
        isLoggedIn = await html.window.localStorage.containsKey('token');
        id = html.window.localStorage['id'] ?? '';
      } else {
        token = await prefs.getString('token') ?? '';
        darkMode = await prefs.getString('darkMode');
        isLoggedIn = await prefs.containsKey('token');
        id = prefs.getString('id') ?? '';
      }
      if ((id != null) && (id != '')) {
        final responseData = await userApiService.validateToken(
          token,
          id,
        );
      }
      if (darkMode == '1') {
        _currentTheme = await ThemeData.dark();
      } else {
        _currentTheme = await ThemeData.light();
      }
      setTheme(_currentTheme);
      setState(() {});
    } catch (e) {
      isLoggedIn = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EETAC App',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // Inglés
        const Locale('es', 'ES'), // Español
        const Locale('ca', 'ES'), // Catalán
      ],
      theme: _currentTheme,
      home: isLoggedIn ? NewsScreen() : LoginOrRegister(),
      debugShowCheckedModeBanner: false,
    );
  }

  void setTheme(ThemeData theme) {
    setState(() {
      _currentTheme = theme;
    });
  }
}
