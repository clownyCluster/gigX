import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigX/home.dart';
import 'package:gigX/pages/account.dart';
import 'package:gigX/pages/chat_module/chat_screen.dart';
import 'package:gigX/pages/chat_module/chat_screen_state.dart';
import 'package:gigX/pages/home.dart';
import 'package:gigX/pages/notifications.dart';
import 'package:gigX/pages/tasks.dart';
import 'package:gigX/view/account_view.dart';
import 'package:gigX/view/home_screen_view.dart';
import 'package:gigX/view/notification_view.dart';
import 'package:gigX/view/task_view.dart';
import 'package:provider/provider.dart';

import '../colors.dart';
import '../constant/constants.dart';
import '../view_model/home_view_model.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final state = Get.put(HomeController());
    return Scaffold(
        body: Obx(() => IndexedStack(
              index: controller.currentIndex.value,
              children: [
                HomeScreenView(),
                // Center(child: Text('Tssak')),
                TaskViewScreen(),
                NotificationView(),
                AccountView(),

                // TaskTabPage(),
                // NotificationTabPage(),
                // AccountTabPage(),
                ChangeNotifierProvider(
                    create: (_) => ChatScreenState(), child: ChatScreen())
              ],
            )),
        bottomNavigationBar: Obx(
          () => Container(
            decoration: BoxDecoration(
                // borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                border: Border(
                    top: BorderSide(color: Colors.grey.withOpacity(0.2))),
                color: whiteColor),
            child: BottomNavigationBar(
              // backgroundColor: Get.isDarkMode ? greyColor : whiteColor,
              currentIndex: controller.currentIndex.value,
              selectedItemColor:
                  Get.isDarkMode ? buttonColor : ColorsTheme.btnColor,
              unselectedItemColor: Colors.grey,
              onTap: controller.changePage,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Image(
                    image: AssetImage(
                      'assets/navbaricon_home.png',
                    ),
                    color: state.currentIndex == 0 && Get.isDarkMode
                        ? buttonColor
                        : state.currentIndex == 0
                            ? ColorsTheme.btnColor
                            : Colors.grey,
                  ),
                  // icon: Icon(Icons.home),
                  label: 'Home',
                  // backgroundColor: Colors.white
                ),
                BottomNavigationBarItem(
                  icon: Image(
                    image: AssetImage('assets/navbaricon_tasks.png'),
                    color: state.currentIndex == 1 && Get.isDarkMode
                        ? buttonColor
                        : state.currentIndex == 1
                            ? ColorsTheme.btnColor
                            : Colors.grey,
                  ),
                  label: 'Tasks',
                  // backgroundColor: Colors.white
                ),
                BottomNavigationBarItem(
                  icon: Image(
                    image: AssetImage(
                      'assets/navbaricon_notifications.png',
                    ),
                    color: state.currentIndex == 2 && Get.isDarkMode
                        ? buttonColor
                        : state.currentIndex == 2
                            ? ColorsTheme.btnColor
                            : Colors.grey,
                  ),
                  label: 'Notifications',
                  // backgroundColor: Colors.white
                  // ,
                ),
                BottomNavigationBarItem(
                  icon: Image(
                    image: AssetImage('assets/navbaricon_account.png'),
                    color: state.currentIndex == 3 && Get.isDarkMode
                        ? buttonColor
                        : state.currentIndex == 3
                            ? ColorsTheme.btnColor
                            : Colors.grey,
                  ),
                  label: 'Account',
                  // backgroundColor: Colors.white
                  // ,
                ),
                BottomNavigationBarItem(
                  // icon: Image(image: AssetImage('assets/navbaricon_account.png')),
                  icon: Image(
                    image: AssetImage('assets/chat.png'),
                    color: state.currentIndex == 4 && Get.isDarkMode
                        ? buttonColor
                        : state.currentIndex == 4
                            ? ColorsTheme.btnColor
                            : Colors.grey,
                  ),
                  label: 'Chats',
                  // backgroundColor: Colors.white
                  // ,
                ),
              ],
            ),
          ),
        ));
  }
}
