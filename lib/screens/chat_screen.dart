import 'package:ea_proyecto_flutter/api/models/message.dart';
import 'package:ea_proyecto_flutter/api/services/chatService.dart';
import 'package:ea_proyecto_flutter/customUI/own_message_card.dart';
import 'package:ea_proyecto_flutter/customUI/reply_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

class ChatScreen extends StatefulWidget {
  final String groupName;
  final String roomId;

  ChatScreen({required this.groupName, required this.roomId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ChatService _chatService = ChatService();
  String userId = "";
  String senderName = "";
  late IO.Socket socket;
  List <MsgModel>listMsgs = []; // Lista de mensajes

  @override
  void initState() {
    super.initState();
    _loadData();
    socket = IO.io('http://localhost:9191', <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.onConnect((_) {
      print('Conectado al servidor SocketIO');

      //Enviar evento 'join-room' al servidor
      socket.emit('join-room', widget.roomId);
    });
    socket.on('connected-users', (data) {
      print('Número de usuarios conectados: $data');
    });
    socket.on('message', (data) {
      print('Mensaje recibido: $data');
      if(data['userId'] != userId && data['message'] != listMsgs.last.message){
        setState(() {
          MsgModel msg = MsgModel(idUser: data['userId'] ?? '', senderName: data['senderName'] ?? '', message: data['message'] ?? '');
          listMsgs.add(msg);
        }); 
      }
    });
  }

  void sendMessage(String message){
    MsgModel ownMsg = MsgModel(idUser: userId, senderName: senderName, message: message);
    setState(() {
      listMsgs.add(ownMsg);
    });
    final data = {
      'room': widget.roomId,
      'userId': userId,
      'senderName': senderName,
      'message': message,
    };
    socket.emit('message', data);
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (kIsWeb) {
      userId = html.window.localStorage['id'] ?? '';
      senderName = html.window.localStorage['name'] ?? '';
    } else {
      userId = prefs.getString('id') ?? '';
      senderName = prefs.getString('name') ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 125, 204, 1.0),
        title: Text(widget.groupName),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 140,
              child: ListView.builder(shrinkWrap: true, itemCount: listMsgs.length,itemBuilder: (context, index) {
                if(listMsgs[index].idUser == userId){
                  return OwnMessageCard(msg: listMsgs[index].message);
                }else{
                  return ReplyCard(msg: listMsgs[index].message, sender: listMsgs[index].senderName);
                }
              })
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 60,
                    child: Card(
                      margin: const EdgeInsets.only(left: 2, right: 2, bottom: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: TextFormField(
                        controller: _msgController,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Escriu un missatge...",
                          prefixIcon: IconButton(
                            icon: const Icon(Icons.emoji_emotions),
                            onPressed: () {},
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.attach_file),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.camera_alt),
                                onPressed: () {},
                              )
                            ],
                          ),
                          contentPadding: const EdgeInsets.all(5),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                      right: 5,
                      left: 2,
                    ),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: const Color.fromRGBO(0, 125, 204, 1.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (_msgController.text.isNotEmpty) {
                            sendMessage(_msgController.text);
                            _msgController.clear();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
