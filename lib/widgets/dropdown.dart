import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Menú Desplegable Flutter'),
        ),
        body: Center(
          child: MyDropdownButton(),
        ),
      ),
    );
  }
}

class MyDropdownButton extends StatefulWidget {
  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

Future<void> Save(String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (kIsWeb) {
    html.window.localStorage['year'] = value.toString();
  } else {
    prefs.setString('year', value.toString());
  }
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  // Lista de elementos para el menú desplegable
  List<String> items = ['2023', '2024', '2025'];

  // Variable para almacenar la opción seleccionada
  String selectedItem = '2023';

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: selectedItem,
      onChanged: (value) {
        setState(() {
          selectedItem = value as String;
          Save(value);
        });
      },
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
    );
  }
}
