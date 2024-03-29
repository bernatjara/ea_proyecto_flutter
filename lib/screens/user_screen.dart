import 'package:ea_proyecto_flutter/screens/update_profile_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/navigation_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/profile_menu_widget.dart';
import 'package:ea_proyecto_flutter/screens/login_screen.dart';
import '../screens/config_screen.dart';
import 'package:universal_html/html.dart' as html;
//import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String storedName = '';
  String storedEmail = '';
  String storedRol = '';
  String storedImage = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (kIsWeb) {
      storedName = html.window.localStorage['name'] ?? '';
      storedEmail = html.window.localStorage['email'] ?? '';
      storedRol = html.window.localStorage['rol'] ?? '';
      storedImage = html.window.localStorage['image'] ?? '';
    } else {
      // Recupera los valores almacenados en SharedPreferences
      storedName = prefs.getString('name') ??
          ''; // Puedes establecer un valor predeterminado si es nulo
      storedEmail = prefs.getString('email') ?? '';
      storedRol = prefs.getString('rol') ?? '';
      storedImage = prefs.getString('image') ?? '';
    }
    if (storedRol == '') {
      storedRol = 'cliente';
    }
    // Notifica al framework que el estado ha cambiado, para que se actualice en la pantalla
    setState(() {});
  }

  Future<void> logout() async {
    if (kIsWeb) {
      html.window.localStorage.clear();
      MyApp.setTheme(context, ThemeData.light());
    } else {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      //preferences.remove('token');
      preferences.clear();
      MyApp.setTheme(context, ThemeData.light());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
        backgroundColor: const Color.fromRGBO(0, 125, 204, 1.0),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              //IAMGE
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: storedImage == ''
                          ? const Image(
                              image: NetworkImage(
                                  'https://sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png'),
                            )
                          : Image.network(
                              storedImage,
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: const Color.fromRGBO(0, 125, 204, 1.0)),
                      child: const Icon(
                        Icons.edit,
                        color: Color.fromARGB(255, 255, 255, 255),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(storedName,
                  style: Theme.of(context).textTheme.headlineMedium),
              Text(storedEmail, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),

              //BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UpdateProfileScreen(),
                      ),
                    );
                    if (result != null && result) {
                      // Refresh user data if the result is not null and true
                      _loadUserData();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(0, 125, 204, 1.0),
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: Text(AppLocalizations.of(context)!.editProfile,
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              //MENU
              ProfileMenuWidget(
                title: AppLocalizations.of(context)!.config,
                icon: Icons.settings,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConfigurationScreen()),
                  );
                },
              ),

              const Divider(), // Linea separatopria
              const SizedBox(height: 10),

              ProfileMenuWidget(
                title: AppLocalizations.of(context)!.information,
                icon: Icons.info_rounded,
                onPress: () {},
              ),

              ProfileMenuWidget(
                title: AppLocalizations.of(context)!.logOut,
                icon: Icons.logout,
                textColor: Colors.red,
                endIcon: false,
                onPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          AppLocalizations.of(context)!.logOut,
                          style: TextStyle(fontSize: 20),
                        ),
                        content: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(AppLocalizations.of(context)!.sureLogOut),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              await logout();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                  (route) => false);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              side: BorderSide.none,
                            ),
                            child: Text(AppLocalizations.of(context)!.yes),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Cierra el diálogo
                            },
                            child: Text(AppLocalizations.of(context)!.no),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
