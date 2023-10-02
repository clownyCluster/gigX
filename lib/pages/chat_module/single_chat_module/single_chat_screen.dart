import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:gigX/constant/constants.dart';
import 'package:intl/intl.dart';

class SingleChatScreen extends StatefulWidget {
  @override
  _SingleChatScreenState createState() => _SingleChatScreenState();
}

class _SingleChatScreenState extends State<SingleChatScreen> {
  final List<Message> _messages = [];

  TextEditingController _textController = TextEditingController();

  void _handleSubmitted(String text) {
    if (text.isNotEmpty) {
      _textController.clear();
      setState(() {
        _messages.add(Message(text: text, isMe: true));
        // Simulate a reply from the other user
        _messages.add(Message(text: 'We will reach out to you real quick.', isMe: false));
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('User Email'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return MessageBubble(
                  message: _messages[index],
                );
              },
            ),
          ),
          Divider(height: 1),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
      
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).hintColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextFormField(
                controller: _textController,
                // onSubmitted: _handleSubmitted,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  focusedBorder:

                      OutlineInputBorder(borderSide: BorderSide.none),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  isDense: true,
                  hintText: 'Send a message',
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
            IconButton(
              icon: Icon(Icons.image),
              onPressed: () {
                // TODO: Implement image sharing
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final bool isMe;
  final String timestamp;

  Message({required this.text, required this.isMe})
      : timestamp = DateTime.now().toString();

  String getFormattedTimestamp() {
    final formatter = DateFormat('HH:mm'); // Customize the format as needed
    return formatter.format(DateTime.now());
  }
}

// class MessageBubble extends StatelessWidget {
//   final Message message;

//   MessageBubble({required this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
//       alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Column(
//         crossAxisAlignment:
//             message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment:
//                 message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//             children: [
//               // if (!message.isMe)
//               //   CircleAvatar(
//               //     backgroundImage: AssetImage('assets/avatar.png'),
//               //   ),
//               maxWidthSpan(),
//               Expanded(
//                 child: Container(
//                   padding:
//                       EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
//                   decoration: BoxDecoration(
//                     color: message.isMe ? Colors.blue : Colors.grey[300],
//                     borderRadius: message.isMe
//                         ? BorderRadius.only(
//                             topLeft: Radius.circular(20),
//                             topRight: Radius.circular(20),
//                             bottomLeft: Radius.circular(20))
//                         : BorderRadius.only(
//                             topLeft: Radius.circular(20),
//                             topRight: Radius.circular(20),
//                             bottomRight: Radius.circular(20)),
//                   ),
//                   child: Text(
//                     message.text,
//                     style: TextStyle(fontSize: 16.0),
//                   ),
//                 ),
//               ),
//               maxWidthSpan(),
//               // if (message.isMe)
//               //   CircleAvatar(
//               //     backgroundImage: AssetImage('assets/avatar.png'),
//               //   ),
//             ],
//           ),
//           // Text(
//           //   message.getFormattedTimestamp(),
//           //   style: TextStyle(color: Colors.grey),
//           // ),
//         ],
//       ),
//     );
//   }
// }

class MessageBubble extends StatelessWidget {
  final Message message;

  MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final borderRadius = BorderRadius.circular(10.0);
    final bubbleColor = isMe ? Colors.blue : Colors.grey[300];
    final textColor = isMe ? Colors.white : Colors.black;

    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        ChatBubble(
          clipper: isMe ? ChatBubbleClipper1(type: BubbleType.sendBubble) : ChatBubbleClipper1(type: BubbleType.receiverBubble),
          alignment: isMe ? Alignment.topRight : Alignment.topLeft,
          
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          backGroundColor: bubbleColor,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: borderRadius,
            ),
            child: Text(
              message.text,
              style: TextStyle(color: textColor, fontSize: 16.0),
            ),
          ),
        )
      ],
    );
  }
}
