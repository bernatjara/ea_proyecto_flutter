import 'package:ea_proyecto_flutter/screens/subjects_screen.dart';
import 'package:ea_proyecto_flutter/widgets/button.dart';
import 'package:ea_proyecto_flutter/widgets/dropdown.dart';
import 'package:flutter/material.dart';
//import '../widgets/navigation_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ea_proyecto_flutter/api/services/asignaturaService.dart';
import 'package:ea_proyecto_flutter/api/services/userService.dart';
import 'package:universal_html/html.dart' as html;
//import '../api/models/user.dart';
//import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditSubjectsScreen extends StatefulWidget {
  @override
  _EditSubjectsScreenState createState() => _EditSubjectsScreenState();
}

class _EditSubjectsScreenState extends State<EditSubjectsScreen> {
  final AsignaturaApiService asignaturaApiService = AsignaturaApiService();
  final UserApiService userApiService = UserApiService();
  late Future<List<NewItem>> futureAsignaturas;
  late Future<List<NewItem>> futureAsignaturasUser;
  late List<NewItem> newList = [];
  late List<NewItem> alreadyList = [];
  late List<bool> isCheckedList = [];
  late bool firstime = true;

  @override
  void initState() {
    futureAsignaturas = _getallasignaturas();
    futureAsignaturasUser = _getallasginaturasuser();
    super.initState();
  }

  Future<List<NewItem>> _getallasignaturas() async {
    return await asignaturaApiService.GetAllAsignaturas();
  }

  Future<List<NewItem>> _getallasginaturasuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedId;
    if (kIsWeb) {
      storedId = html.window.localStorage['id'] ?? '';
    } else {
      storedId = prefs.getString('id') ?? '';
    }
    return await asignaturaApiService.GetAsignaturasById(storedId);
  }

  Future<void> _done() async {
    int i = 0;
    List<String> asignaturas = [];
    while (i < newList.length) {
      if (isCheckedList[i] == true) {
        asignaturas.add(newList[i].id);
      }
      i++;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (kIsWeb) {
      await userApiService.updateSubjects(
          userId: html.window.localStorage['id'] ?? '',
          username: html.window.localStorage['name'] ?? '',
          email: html.window.localStorage['email'] ?? '',
          password: html.window.localStorage['password'] ?? '',
          token: html.window.localStorage['token'] ?? '',
          asignatura: asignaturas);
    } else {
      await userApiService.updateSubjects(
          userId: prefs.getString('id') ?? '',
          username: prefs.getString('name') ?? '',
          email: prefs.getString('email') ?? '',
          password: prefs.getString('password') ?? '',
          token: prefs.getString('token') ?? '',
          asignatura: asignaturas);
    }
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubjectsScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editSubjects),
      ),
      body: FutureBuilder(
        future: Future.wait([futureAsignaturas, futureAsignaturasUser]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the data to be fetched
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            // If the data has been successfully fetched
            if (firstime == true) {
              newList = snapshot.data?[0] as List<NewItem>;
              alreadyList = snapshot.data?[1] as List<NewItem>;
              isCheckedList = List.generate(newList.length, (index) => false);
              int i = 0;
              int j = 0;
              while (i < alreadyList.length) {
                ;
                while (j < newList.length) {
                  if (alreadyList[i].name == newList[j].name) {
                    isCheckedList[j] = true;
                  }
                  j++;
                }
                i++;
                j = 0;
              }
              firstime = false;
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: newList.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(newList[index].name),
                        value: isCheckedList[index],
                        onChanged: (value) {
                          setState(() {
                            isCheckedList[index] = value!;
                          });
                        },
                      );
                    },
                  ),
                ),
                MyDropdownButton(),
                MyButton(
                  onTap: _done,
                  text: AppLocalizations.of(context)!.edit,
                ),
              ],
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
