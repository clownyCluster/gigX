import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigX/appRoute/routeName.dart';
import 'package:gigX/colors.dart';
import 'package:gigX/constant/constants.dart';
import 'package:gigX/pages/chat_module/chat_screen_state.dart';
import 'package:gigX/pages/chat_module/chat_users_module/chat_users_screen.dart';
import 'package:provider/provider.dart';

import '../../service/local_storage_service.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ChatScreenState>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsTheme.btnColor,
        onPressed: () {
          Get.to(ChatUsersScreen());
        },
        child: Icon(Icons.chat),
      ),
      body: Container(
        padding: kStandardPadding(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Chats',
                  style: kkBoldTextStyle()
                      .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Icon(Icons.search)
              ],
            ),
            LSizedBox(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  StatusTile(
                    state: state,
                    title: 'Chats',
                    onPressed: () {
                      state.onSelectedStatusChanged('Chats');
                    },
                  ),
                  largeWidthSpan(),
                  StatusTile(
                    state: state,
                    title: 'Calls',
                    onPressed: () {
                      state.onSelectedStatusChanged('Calls');
                    },
                  ),
                  largeWidthSpan(),
                  StatusTile(
                    state: state,
                    title: 'Contacts',
                    onPressed: () {
                      state.onSelectedStatusChanged('Chats');
                    },
                  ),
                ],
              ),
            ),
            kSizedBox(),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        Get.toNamed(RouteName.singleChatScreen);
                      },
                      child: ChatTile());
                },
              ),
              // child: _buildMessageList(),
            ),
          ],
        ),
      ),
    );
  }

    Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chat_rooms').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error occured fetching the chat_rooms');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading');
        }
        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((e) => _buildMessageListItem(e))
              .toList(),
        );
      },
    );
  }

    Widget _buildMessageListItem(DocumentSnapshot document) {
    String? currentUser = LocalStorageService().read(LocalStorageKeys.email);
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    if (data != null && data.containsKey('email')) {
      String email = data['email'] as String;

      if (currentUser != email) {
        print(email);
        return ListTile(
          leading: Icon(Icons.person),
          title: Text(email),
          onTap: () {
            print(data['email']);
            print(data['uid']);
            print(data['uid'].runtimeType);           
            // Get.toNamed(RouteName.singleChatScreen);
          },
        );
      }
    }

    // Return an empty Container if conditions are not met.
    return Container();
  }
}

class StatusTile extends StatelessWidget {
  String? title;
  final void Function()? onPressed;
  StatusTile({super.key, required this.state, this.onPressed, this.title});

  final ChatScreenState state;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        state.onSelectedStatusChanged(title);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: state.selectedStatus == title
                ? ColorsTheme.btnColor
                : Colors.grey[200]),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Text(
          title!,
          style: kWhiteBoldTextStyle().copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color:
                  state.selectedStatus == title ? Colors.white : Colors.grey),
        ),
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        // margin: EdgeInsets.only(bottom: 10),
        color: Colors.white,
        padding: kPadding(),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage('assets/person.png'),
            ),
            maxWidthSpan(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Leonardo de La Vega',
                    style: kBoldTextStyle(),
                  ),
                  // sSizedBox(),
                  Text(
                    'How are you today?',
                    style: kTextStyle(),
                  )
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  '2 min',
                  style: sTextStyle(),
                ),
                sSizedBox(),
                CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.redAccent[400],
                  child: Text(
                    '3',
                    style: sWhiteTextStyle(),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
