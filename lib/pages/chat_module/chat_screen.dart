import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gigX/colors.dart';
import 'package:gigX/constant/constants.dart';
import 'package:gigX/pages/chat_module/chat_screen_state.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ChatScreenState>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsTheme.btnColor,
        onPressed: (){},
      child: Icon(Icons.chat),
      ),
      body: Container(
        padding: kStandardPadding(),
        child: Column(
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
            Row(
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
            kSizedBox(),
            ChatTile(),
            ChatTile(),
            ChatTile(),
            ChatTile(),
            ChatTile(),
            ChatTile()
          ],
        ),
      ),
    );
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
        padding: kStandardPadding(),
        child: Text(
          title!,
          style: kWhiteBoldTextStyle().copyWith(
            fontSize: 18,
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
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      color: Colors.white,
      padding: kPadding(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage('assets/person.png'),
          ),
          largeWidthSpan(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Leonardo de La Vega',
                  style: kBoldTextStyle(),
                ),
                sSizedBox(),
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
                radius: 13,
                backgroundColor: Colors.redAccent[400],
                child: Text(
                  '3',
                  style: kWhiteBoldTextStyle(),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
