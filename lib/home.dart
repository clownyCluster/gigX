import 'package:auto_size_text/auto_size_text.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:gigX/colors.dart';
import 'package:gigX/constant/constants.dart';
import 'package:gigX/pages/account.dart';
import 'package:gigX/pages/chat_module/chat_screen.dart';
import 'package:gigX/pages/chat_module/chat_screen_state.dart';
import 'package:gigX/pages/home.dart';
import 'package:gigX/pages/notifications.dart';
import 'package:gigX/pages/tasks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

GlobalKey bottomWidgetKey = GlobalKey<State<BottomNavigationBar>>();
GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_app_bar');

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: ColorsTheme.bgColor),
      home: const HomePage(
        initialPage: 0,
      ),
    );
  }
}

var height, width;
int _current_index = 0;
bool? viewed_project_details = false;

class HomePage extends StatefulWidget {
  final int initialPage;
  const HomePage({Key? key, required this.initialPage}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences? preferences;

  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    HomeTabPage(),
    TaskTabPage(),
    NotificationTabPage(),
    AccountTabPage(),
    ChangeNotifierProvider(
        create: (_) => ChatScreenState(), child: ChatScreen())
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    initializePrefs();
    if (widget.initialPage != 0) {
      setState(() {
        _selectedIndex = widget.initialPage;
      });
    }
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("BACK BUTTON!"); // Do some stuff.
    return true;
  }

  void changeTabs(int index) async {
    setState(() {
      _current_index = index;
    });
  }

  Future<void> initializePrefs() async {
    this.preferences = await SharedPreferences.getInstance();
    setState(() {
      _current_index = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: bottomWidgetKey,

        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Image(
                image: AssetImage(
                  'assets/navbaricon_home.png',
                ),
                color: _selectedIndex == 0 ? ColorsTheme.btnColor : darkGrey,
              ),
              label: 'Home',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Image(
                image: AssetImage('assets/navbaricon_tasks.png'),
                color: _selectedIndex == 1 ? ColorsTheme.btnColor : darkGrey,
              ),
              label: 'Tasks',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage('assets/navbaricon_notifications.png'),
              color: _selectedIndex == 2 ? ColorsTheme.btnColor : darkGrey,
            ),
            label: 'Notifications',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Image(
              image: AssetImage('assets/navbaricon_account.png'),
              color: _selectedIndex == 3 ? ColorsTheme.btnColor : darkGrey,
            ),
            label: 'Account',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            // icon: Image(image: AssetImage('assets/navbaricon_account.png')),
            icon: Image(
              image: AssetImage('assets/chat.png'),
              color: _selectedIndex == 4 ? ColorsTheme.btnColor : darkGrey,
            ),
            label: 'Chats',
            backgroundColor: Colors.white,
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: ColorsTheme.btnColor,

        selectedFontSize: 12,
        unselectedFontSize: 12,

        // iconSize: 40,
        onTap: _onItemTapped,
      ),
    );
    // return CupertinoTabScaffold(
    //     resizeToAvoidBottomInset: false,
    //     tabBar: CupertinoTabBar(
    //       key: globalKey,
    //       items: <BottomNavigationBarItem>[
    //         BottomNavigationBarItem(
    //             icon: Image(image: AssetImage('assets/navbaricon_home.png')),
    //             label: 'Home',
    //             backgroundColor: Colors.white),
    //         BottomNavigationBarItem(
    //             icon: Image(image: AssetImage('assets/navbaricon_tasks.png')),
    //             label: 'Tasks',
    //             backgroundColor: Colors.white),
    //         BottomNavigationBarItem(
    //             icon: Image(
    //                 image: AssetImage('assets/navbaricon_notifications.png')),
    //             label: 'Notifications',
    //             backgroundColor: Colors.white),
    //         BottomNavigationBarItem(
    //             icon: Image(image: AssetImage('assets/navbaricon_account.png')),
    //             label: 'Account',
    //             backgroundColor: Colors.white),
    //       ],
    //       onTap: (int index) {
    //         setState(() {
    //           changeTabs(index);
    //         });
    //       },
    //     ),
    //     tabBuilder: (context, index) {
    //       switch (index) {
    //         case 0:
    //           return CupertinoTabView(builder: (context) {
    //             return CupertinoPageScaffold(child: HomeTab());
    //           });
    //         case 1:
    //           return CupertinoTabView(builder: (context) {
    //             return CupertinoPageScaffold(child: TaskTab());
    //           });
    //         case 2:
    //           return CupertinoTabView(builder: (context) {
    //             return CupertinoPageScaffold(
    //               child: NotificationTab(),
    //             );
    //           });
    //         case 3:
    //           return CupertinoTabView(builder: (context) {
    //             return CupertinoPageScaffold(
    //               child: AccountTab(),
    //             );
    //           });
    //         default:
    //           return CupertinoTabView(builder: (context) {
    //             return CupertinoPageScaffold(child: HomeTab());
    //           });
    //       }
    //     });
  }
}
