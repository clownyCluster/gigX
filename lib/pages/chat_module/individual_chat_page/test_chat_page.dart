import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TestChatPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Messages'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('chat_rooms')
            .doc('260000_455946')
            .collection('messages')
            .orderBy('timeStamp', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No messages available.'));
          }
          snapshot.data!.docs.forEach((messageDoc) {
            Map<String, dynamic> messageData =
                messageDoc.data() as Map<String, dynamic>;
            print(
                'Message: ${messageData['message']}, Sender: ${messageData['senderEmail']}, Time: ${messageData['timeStamp']}');
          });

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot messageDoc = snapshot.data!.docs[index];
              Map<String, dynamic> messageData =
                  messageDoc.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(messageData['message']),
                subtitle: Text(messageData['senderEmail']),
                trailing: Text(
                  DateFormat('hh:mm a')
                      .format(messageData['timeStamp'].toDate()),
                  style: TextStyle(fontSize: 12.0),
                ),
              );
            },
          );

          // return ListView.builder(
          //   itemCount: snapshot.data!.docs.length,
          //   itemBuilder: (context, index) {
          //     DocumentSnapshot messageDoc = snapshot.data!.docs[index];
          //     Map<String, dynamic> messageData = messageDoc.data() as Map<String, dynamic>;

          //     return ListTile(
          //       title: Text(messageData['message']),
          //       subtitle: Text(messageData['senderEmail']),
          //       trailing: Text(
          //         DateFormat('hh:mm a').format(messageData['timeStamp'].toDate()),
          //         style: TextStyle(fontSize: 12.0),
          //       ),
          //     );
          //   },
          // );
        },
      ),
    );
  }
}
