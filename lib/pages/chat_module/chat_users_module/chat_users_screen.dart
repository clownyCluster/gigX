import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigX/appRoute/routeName.dart';
import 'package:gigX/pages/chat_module/individual_chat_page/individual_chat_page.dart';
import 'package:gigX/pages/chat_module/individual_chat_page/test_chat_page.dart';
import 'package:gigX/service/local_storage_service.dart';
import 'package:intl/intl.dart';

class ChatUsersScreen extends StatefulWidget {
  const ChatUsersScreen({super.key});

  @override
  State<ChatUsersScreen> createState() => _ChatUsersScreenState();
}

class _ChatUsersScreenState extends State<ChatUsersScreen> {
  Future<String?> getLatestMessage(String chatRoomId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timeStamp', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String formattedDate = DateFormat('MMM:dd')
          .format(querySnapshot.docs.first['timeStamp'].toDate());

      return '${querySnapshot.docs.first['message']}, $formattedDate'
          as String?;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: _buildUserList(),
    );
  }

  // Build a list of users.
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error occured fetching the users');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No users',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }
        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((e) => _buildUserListItem(e))
              .toList(),
        );
      },
    );
  }

  // build Individual user item list
  Widget _buildUserListItem(DocumentSnapshot document) {
    String? currentUser = LocalStorageService().read(LocalStorageKeys.email);
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    if (data != null && data.containsKey('email')) {
      String email = data['email'] as String;

      if (currentUser != email) {
        // String chatRoomId = '${LocalStorageService().readInt(LocalStorageKeys.userId)}${data['uid']}';
        List<String> ids = [
          '${LocalStorageService().readInt(LocalStorageKeys.userId)}',
          data['uid'].toString()
        ];
        ids.sort();
        String chatRoomId = ids.join('_');
        return FutureBuilder<String?>(
          future: getLatestMessage(
              chatRoomId), // Replace with the actual chat room ID
          builder: (context, snapshot) {
            String latestMessage = snapshot.data ?? '';
            List splittedMessage = [];
            if (latestMessage.isNotEmpty) {
              splittedMessage = latestMessage.split(',');
            }
            return ListTile(
              // leading: Container(
              //     decoration: BoxDecoration(
              //         // color: Colors.pink,
              //         shape: BoxShape.circle,
              //         image: DecorationImage(
              //           image: NetworkImage(
              //             data['profilePic'],
              //           ),
              //         )),
              //     child: data['profilePic'] != null
              //         ? Image.network(
              //             data['profilePic'],
              //             fit: BoxFit.cover,
              //           )
              //         : Icon(Icons.person)),
              leading: data['profilePic'] != null ||
                      data['profilePic'].toString().isNotEmpty
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(
                        data['profilePic'],
                      ),
                      radius: 24,
                    )
                  : CircleAvatar(
                      child: Icon(Icons.person),
                      radius: 24,
                    ),
              title: Text(
                data['name'],
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: latestMessage.isEmpty
                  ? Text(
                      'Start a chat',
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  : Row(
                      children: [
                        Expanded(
                            child: Text(
                          splittedMessage[0],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )),
                        Text(
                          '${splittedMessage[1]}',
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      ],
                    ), // Display the latest message
              onTap: () {
                print('Here');
                Get.to(IndividualChatPage(
                  receiverEmail: data['email'],
                  receiverId: data['uid'].toString(),
                  receiverName: data['name'].toString(),
                ));
              },
            );
          },
        );
      }
    }

    // Return an empty Container if conditions are not met.
    return Container();
  }
}
