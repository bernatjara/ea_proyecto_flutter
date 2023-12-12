import 'package:flutter/material.dart';
import './chat_screen.dart';

class GroupsScreen extends StatelessWidget {
  final List<String> groups = [
    'Grupo 1',
    'Grupo 2',
    'Grupo 3'
  ]; // Puedes cargar los grupos desde tu servidor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grupos'),
      ),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(groups[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(groupName: groups[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
