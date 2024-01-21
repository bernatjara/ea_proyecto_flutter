import 'package:ea_proyecto_flutter/api/services/asignaturaService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ea_proyecto_flutter/api/services/asignaturaService.dart';
import './chat_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:universal_html/html.dart' as html;
import '../api/services/chatService.dart';

class GroupsScreen extends StatefulWidget {
  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final AsignaturaApiService asignaturaApiService = AsignaturaApiService();
  final ChatService chatService = ChatService();
  late Future<List<NewItem>> groups;

  @override
  void initState() {
    super.initState();
    groups = _getAsignaturas();
  }

  Future<Map<String, dynamic>> _fetchAsignatura(String id) async {
    try {
      final responseData = await asignaturaApiService.getAsignatura(id);
      final hasChat = responseData['chat'] != null;
      return {
        'asignatura': responseData,
        'hasChat': hasChat,
      };
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString()),
        ),
      );
      throw Exception('Error al cargar la asignatura');
    }
  }

  Future<List<NewItem>> _getAsignaturas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedId;
    if (kIsWeb) {
      storedId = html.window.localStorage['id'] ?? '';
    } else {
      storedId = prefs.getString('id') ?? '';
    }
    return await asignaturaApiService.GetAsignaturasById(storedId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 125, 204, 1.0),
        title: const Text('Grups'),
      ),
      body: FutureBuilder(
        future: groups,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for the data to be fetched
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // If the data has been successfully fetched
            List<NewItem> newList = snapshot.data as List<NewItem>;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: newList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(newList[index].name),
                        onTap: () async {
                          Map<String, dynamic> result =
                              await _fetchAsignatura(newList[index].id);
                          bool hasChat = result['hasChat'];
                          if (hasChat) {
                            String chatId = result['asignatura']['chat'];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  groupName: newList[index].name,
                                  roomId: newList[index].id,
                                  chatId: chatId,
                                ),
                              ),
                            );
                          } else {
                            try {
                              String chatId = await chatService
                                  .createEmptyChat(newList[index].id);
                              print(newList[index].id);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    groupName: newList[index].name,
                                    roomId: newList[index].id,
                                    chatId: chatId,
                                  ),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(e.toString()),
                              ));
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
