import 'package:ea_proyecto_flutter/customUI/own_message_card.dart';
import 'package:ea_proyecto_flutter/customUI/reply_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatScreen extends StatefulWidget {
  final String groupName;

  ChatScreen({required this.groupName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  late io.Socket socket;

  @override
  void initState() {
    super.initState();
    socket = io.io('http://localhost:3000');
    socket.on('chat message', (data) {
      setState(() {
        _messages.add(data);
      });
    });
  }

  void _sendMessage() {
    socket.emit('chat message', _controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 125, 204, 1.0),
        title: Text(widget.groupName),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 140,
              child: ListView(
                shrinkWrap: true,
                children: [
                  OwnMessageCard(),
                  ReplyCard(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 60,
                    child: Card(
                      margin: EdgeInsets.only(left: 2, right: 2, bottom: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Escriu un missatge...",
                          prefixIcon: IconButton(
                            icon: Icon(Icons.emoji_emotions),
                            onPressed: () {},
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.attach_file),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.camera_alt),
                                onPressed: () {},
                              )
                            ],
                          ),
                          contentPadding: EdgeInsets.all(5),
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
                      backgroundColor: Color.fromRGBO(0, 125, 204, 1.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () {},
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
