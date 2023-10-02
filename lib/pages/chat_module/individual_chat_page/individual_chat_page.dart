import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:get/get.dart';
import 'package:gigX/constant/constants.dart';
import 'package:gigX/modules/image_view/imageViewew.dart';
import 'package:gigX/pages/chat_module/chatService/chatService.dart';
import 'package:gigX/service/local_storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class IndividualChatPage extends StatefulWidget {
  final String? receiverId;
  final String? receiverEmail;
  final String? receiverName;
  const IndividualChatPage(
      {super.key, this.receiverEmail, this.receiverId, this.receiverName});

  @override
  State<IndividualChatPage> createState() => _IndividualChatPageState();
}

class _IndividualChatPageState extends State<IndividualChatPage> {
  final ChatService chatService = ChatService();
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(); // Add this line
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onBackspacePressed() {
    messageController
      ..text = messageController.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length));
  }

  Future pickImage(ImageSource source) async {
    try {
      final image =
          await ImagePicker().pickImage(source: source, imageQuality: 20);
      if (image == null) return null;
      imagePath = image.path;
      print('ImagePath : $imagePath');
      messageController.text = imagePath!;
      setState(() {});
    } on PlatformException catch (e) {
      print('yo yeta ko error ho');
      print(e.message);
    }
  }

  bool emojiShowing = false;
  String? imagePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverName!),
      ),
      body: Column(
        children: [
          // This is gonna be the list of messages.
          Expanded(child: _buildMessageList()),
          // // This is the message text field for sending message.
          // _newBottomWidget()
          _buildBottomMessageField()
        ],
      ),
    );
  }

  void sendMessage(messageText) async {
    print('send function chaliraxa');
    if (messageText != null) {
      await chatService.sendMessage(widget.receiverId, messageText);
      messageController.clear();
    }
  }

  Widget _buildBottomMessageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (
        //   messageController.text.isNotEmpty &&
        //   messageController.text.contains('.png') ||
        //     messageController.text.contains('.jpg') ||
        //     messageController.text.contains('.jpeg') ||
        //     messageController.text.contains('.webp'))
        //   Container(
        //     padding: const EdgeInsets.symmetric(horizontal: 20),
        //     child: Row(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Image.file(
        //           File(messageController.text),
        //           height: 70,
        //           width: 80,
        //         ),
        //         minWidthSpan(),
        //         InkWell(
        //           onTap: () {
        //             messageController.clear();
        //           },
        //           child: Icon(Icons.close),
        //         )
        //       ],
        //     ),
        //   ),
        Container(
          // color: const Color.fromARGB(255, 42, 42, 42),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Expanded(
                  child: TextFormField(
                maxLines: 3,
                minLines: 1,
                controller: messageController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  prefixIcon: Container(
                    width: 70,
                    child: Row(
                      children: [
                        maxWidthSpan(),
                        InkWell(
                            onTap: () {
                              setState(() {
                                emojiShowing = !emojiShowing;
                              });
                            },
                            child: Icon(Icons.emoji_emotions_outlined)),
                        maxWidthSpan(),
                        InkWell(
                            onTap: () async {
                              try {
                                final image = await ImagePicker().pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 20);
                                if (image == null) return null;
                                imagePath = image.path;
                                sendMessage(imagePath);
                              } on PlatformException catch (e) {
                                print('yo yeta ko error ho');
                                print(e.message);
                              }
                              // pickImage(ImageSource.gallery);
                            },
                            child: Icon(Icons.image)),
                      ],
                    ),
                  ),
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  // border: OutlineInputBorder(borderSide: BorderSide.none),
                  // focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: 'Enter your message',
                  suffixIcon: InkWell(
                      onTap: () {
                        sendMessage(messageController.text);
                      },
                      child: Icon(Icons.send)),
                ),
              )),
              maxWidthSpan(),
            ],
          ),
        ),
        Offstage(
          offstage: !emojiShowing,
          child: SizedBox(
              height: 250,
              child: EmojiPicker(
                textEditingController: messageController,
                onBackspacePressed: _onBackspacePressed,
                config: Config(
                  columns: 9,
                  // Issue: https://github.com/flutter/flutter/issues/28894
                  emojiSizeMax: 32 * (Platform.isIOS ? 1.0 : 0.9),
                  verticalSpacing: 0,
                  horizontalSpacing: 0,
                  gridPadding: EdgeInsets.zero,
                  initCategory: Category.RECENT,
                  // bgColor: const Color(0xFFF2F2F2),
                  bgColor:
                      Get.isDarkMode ? Colors.grey[900]! : Color(0xffffffff),
                  // indicatorColor: Theme.of(context),
                  iconColor: Colors.grey,

                  // skinToneDialogBgColor: Colors.white,
                  skinToneIndicatorColor: Colors.grey,
                  enableSkinTones: true,
                  recentTabBehavior: RecentTabBehavior.RECENT,
                  recentsLimit: 28,
                  replaceEmojiOnLimitExceed: false,
                  noRecents: const Text(
                    'No Recents',
                    style: TextStyle(fontSize: 20, color: Colors.black26),
                    textAlign: TextAlign.center,
                  ),
                  loadingIndicator: const SizedBox.shrink(),
                  tabIndicatorAnimDuration: kTabScrollDuration,
                  categoryIcons: const CategoryIcons(),
                  buttonMode: ButtonMode.MATERIAL,
                  checkPlatformCompatibility: true,
                ),
              )),
        ),
      ],
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    // Extract the data map from the DocumentSnapshot
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    print('sender Id ra save gareko id');
    print(data['senderEmail']);
    print(data['senderEmail'] ==
        LocalStorageService().read(LocalStorageKeys.email));
    print(LocalStorageService().read(LocalStorageKeys.email));

    // Determine the alignment of the message based on the senderId
    var alignment = (data['senderEmail'] ==
            LocalStorageService().read(LocalStorageKeys.email))
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.end;

    Color color = data['senderEmail'] ==
            LocalStorageService().read(LocalStorageKeys.email)
        ? Theme.of(context).primaryColor
        : Color.fromARGB(255, 190, 189, 189);

    // Construct the individual message item

    return Column(
      crossAxisAlignment: alignment,
      children: [
        data['message'].contains('.png') ||
                data['message'].contains('.jpg') ||
                data['message'].contains('.jpeg') ||
                data['message'].contains('.webp')
            ? InkWell(
                onTap: () {
                  Get.to(ImageViewer(
                    imagePath: data['message'],
                  ));
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  alignment: data['senderEmail'] ==
                          LocalStorageService().read(LocalStorageKeys.email)
                      ? Alignment.topRight
                      : Alignment.topLeft,
                  child: Image.file(
                    File(data['message']),
                    height: 150,
                    width: 240,
                  ),
                ),
              )
            : ChatBubble(
                clipper: data['senderEmail'] ==
                        LocalStorageService().read(LocalStorageKeys.email)
                    ? ChatBubbleClipper1(type: BubbleType.sendBubble)
                    : ChatBubbleClipper1(type: BubbleType.receiverBubble),
                alignment: data['senderEmail'] ==
                        LocalStorageService().read(LocalStorageKeys.email)
                    ? Alignment.topRight
                    : Alignment.topLeft,
                margin: EdgeInsets.only(
                    top: 10,
                    left: data['senderEmail'] ==
                            LocalStorageService().read(LocalStorageKeys.email)
                        ? 60
                        : 10,
                    right: data['senderEmail'] ==
                            LocalStorageService().read(LocalStorageKeys.email)
                        ? 10
                        : 60),
                backGroundColor: color,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    data['message'],
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              )
      ],
    );
  }

  Widget _buildMessageList() {
    var senderId = LocalStorageService().readInt(LocalStorageKeys.userId);
    return StreamBuilder<QuerySnapshot>(
      stream: chatService.getMessage(widget.receiverId, senderId.toString()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error : ' + snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No messages yet.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                LSizedBox(),
                Text(
                  'Say hello, 👋🏻',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
        }

        print(
            'Stream Data: ${snapshot.data!.docs.map((doc) => doc.data()).toList()}');

        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Scroll to the latest message
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }
}
