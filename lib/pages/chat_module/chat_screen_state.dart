import 'package:flutter/material.dart';

class ChatScreenState extends ChangeNotifier {
  String selectedStatus = 'Chats';
  onSelectedStatusChanged(val) {
    selectedStatus = val;
    notifyListeners();
  }
}
