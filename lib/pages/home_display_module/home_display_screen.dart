
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:gigX/constant/constants.dart';
// import 'package:provider/provider.dart';

// import 'home_display_state.dart';

// class Home extends StatelessWidget {
//   const Home({Key? key}) : super(key: key);
//   static const String id = 'homeScreen';

//   @override
//   Widget build(BuildContext context) {
//     final state = Provider.of<HomeState>(context);
//     return Scaffold(
//       body: state.onNavigation.elementAt(state.selectedIndex),
      
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         unselectedItemColor: Colors.grey,
//         showUnselectedLabels: true,
//         backgroundColor: Colors.white,
//         items: const <BottomNavigationBarItem>[
//           // BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           // BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),

//           // BottomNavigationBarItem(
//           //     icon: Icon(Icons.shopping_cart), label: 'Cart'),
//           // BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
//           // BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
//           BottomNavigationBarItem(
//               icon: Image(
//                 image: AssetImage(
//                   'assets/navbaricon_home.png',
//                 ),
//               ),
//               label: 'Home',
//               backgroundColor: Colors.white),
//           BottomNavigationBarItem(
//               icon: Image(
//                 image: AssetImage('assets/navbaricon_tasks.png'),
//               ),
//               label: 'Tasks',
//               backgroundColor: Colors.white),
//           BottomNavigationBarItem(
//             icon: Image(
//               image: AssetImage('assets/navbaricon_notifications.png'),
//             ),
//             label: 'Notifications',
//             backgroundColor: Colors.white,
//           ),
//           BottomNavigationBarItem(
//             icon: Image(
//               image: AssetImage('assets/navbaricon_account.png'),
//             ),
//             label: 'Account',
//             backgroundColor: Colors.white,
//           ),
//           BottomNavigationBarItem(
//             // icon: Image(image: AssetImage('assets/navbaricon_account.png')),
//             icon: Image(
//               image: AssetImage('assets/chat.png'),
//             ),
//             label: 'Chats',
//             backgroundColor: Colors.white,
//           ),
//         ],
//         currentIndex: state.selectedIndex,
//         selectedItemColor: blueColor,
//         onTap: state.onItemTapped,
//       ),
//     );
//   }
// }