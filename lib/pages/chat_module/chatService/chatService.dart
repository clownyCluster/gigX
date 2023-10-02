import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:gigX/data/network/network_api_services.dart';
import 'package:gigX/pages/chat_module/models/messageModel.dart';
import 'package:gigX/pages/taskdetails.dart';
import 'package:gigX/service/local_storage_service.dart';

class ChatService extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send Messages to the users

  sendMessage(String? receiverId, String? message) async {
    String? currentUserEmail =
        LocalStorageService().read(LocalStorageKeys.email);
    String? currentUserId =
        LocalStorageService().readInt(LocalStorageKeys.userId).toString();
    // get Current user Info
    final timeStamp = Timestamp.now();

    // Create new message

    MessageModel newMessage = MessageModel(
        senderEmail: currentUserEmail,
        senderId: currentUserId,
        message: message,
        receiverId: receiverId,
        timestamp: timeStamp);
    print('naya message ho:');
    print(newMessage.toString());

    // Construct a chatRoomId

    List<String> roomId = [currentUserId, receiverId!];
    roomId.sort();
    String? chatRoomId = roomId.join('_');
    // Add new data to database
    print('chat room id : $chatRoomId');
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // GetMessages

  Stream<QuerySnapshot> getMessage(String? userId, String? otherUserId) {
    List<String> ids = [userId!, otherUserId!];
    ids.sort();
    String chatRoomId = ids.join('_');

    Stream<QuerySnapshot> messageStream = _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages').orderBy('timeStamp')
        .snapshots();

    messageStream.listen((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot document) {
        print(document.data());
      });
    });

    return messageStream;
  }
}
