import 'package:flutter/material.dart';

import '../CustomUI/CustomCard.dart';
import '../chatModel.dart';
import 'SelectContact.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key, this.chatmodels, this.sourchat}) : super(key: key);
  List<ChatModel>? chatmodels;
  final ChatModel? sourchat;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    widget.chatmodels = [
      ChatModel(
        name: "Dev Stack",
        isGroup: false,
        currentMessage: "Hi Everyone",
        time: "4:00",
        icon: "person.svg",
        id: 1,
      ),
      ChatModel(
        name: "Kishor",
        isGroup: false,
        currentMessage: "Hi Kishor",
        time: "13:00",
        icon: "person.svg",
        id: 2,
      ),
      ChatModel(
        name: "Collins",
        isGroup: false,
        currentMessage: "Hi Dev Stack",
        time: "8:00",
        icon: "person.svg",
        id: 3,
      ),
      ChatModel(
        name: "Balram Rathore",
        isGroup: false,
        currentMessage: "Hi Dev Stack",
        time: "2:00",
        icon: "person.svg",
        id: 4,
      ),
    ];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (builder) => SelectContact()));
        },
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
      ),
      // body: widget.chatmodels == null
      //     ? Center(child: Text('No chat found'))
      // :
      body: ListView.builder(
        itemCount: widget.chatmodels!.length,
        itemBuilder: (contex, index) => CustomCard(
          chatModel: widget.chatmodels![index],
          sourchat: widget.sourchat,
        ),
      ),
    );
  }
}
