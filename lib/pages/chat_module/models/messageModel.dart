import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? senderEmail;
  String? senderId;
  String? receiverId;
  String? message;
  Timestamp? timestamp;

  MessageModel(
      {this.senderEmail,
      this.senderId,
      this.receiverId,
      this.message,
      this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId!,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timeStamp': timestamp
    };
  }
}
