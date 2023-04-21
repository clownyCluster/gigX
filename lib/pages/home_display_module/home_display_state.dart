
// import 'package:flutter/material.dart';
// import 'package:gigX/pages/home.dart';
// import 'package:provider/provider.dart';

// import '../account.dart';
// import '../chat_module/chat_screen.dart';
// import '../chat_module/chat_screen_state.dart';
// import '../notifications.dart';
// import '../tasks.dart';

// class HomeState extends ChangeNotifier {
//   HomeState(context) {
//     final args = ModalRoute.of(context)?.settings.arguments;
//     if (args != null) {
//       selectedIndex = 2;
//       notifyListeners();
//     }
//   }
//   int selectedIndex = 0;
//   void onItemTapped(int index) {
//     selectedIndex = index;
//     notifyListeners();
//   }

//   List onNavigation = [
//     HomeTab(),
//     TaskTab(),
//     NotificationTab(),
//     AccountTab(),
//     ChangeNotifierProvider(
//         create: (_) => ChatScreenState(), child: ChatScreen())

    
    
//   ];
// }