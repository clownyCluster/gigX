import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigX/pages/chat_module/chatService/chatService.dart';
import 'package:gigX/pages/taskdetails.dart';

class SingleChatState extends GetxController {
  String? userId;
  String? email;
  SingleChatState() {
    final args = Get.arguments;
    if (args != null) {
      args['email'] = email;
    }
    if (args[userId] != null) {
      args['userId'] = userId;
    }
  }

  final messageController = TextEditingController();

  final ChatService chatService = ChatService();

  sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatService.sendMessage(userId, messageController.text);
      messageController.clear();
    }
  }
}
