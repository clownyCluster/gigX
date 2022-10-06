import 'package:auto_size_text/auto_size_text.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:efleet_project_tree/colors.dart';
import 'package:efleet_project_tree/pages/account.dart';
import 'package:efleet_project_tree/pages/home.dart';
import 'package:efleet_project_tree/pages/notifications.dart';
import 'package:efleet_project_tree/pages/tasks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      home: const HomePage(),
    );
  }
}

var height, width;
int _current_index = 0;
bool? viewed_project_details = false;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_app_bar');
  SharedPreferences? preferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    initializePrefs();
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
      body: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            key: globalKey,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Image(image: AssetImage('assets/navbaricon_home.png')),
                  label: 'Home',
                  backgroundColor: Colors.white),
              BottomNavigationBarItem(
                  icon: Image(image: AssetImage('assets/navbaricon_tasks.png')),
                  label: 'Tasks',
                  backgroundColor: Colors.white),
              BottomNavigationBarItem(
                  icon: Image(
                      image: AssetImage('assets/navbaricon_notifications.png')),
                  label: 'Notifications',
                  backgroundColor: Colors.white),
              BottomNavigationBarItem(
                  icon:
                      Image(image: AssetImage('assets/navbaricon_account.png')),
                  label: 'Account',
                  backgroundColor: Colors.white),
            ],
            onTap: (int index) {
              setState(() {
                changeTabs(index);
              });
            },
          ),
          tabBuilder: (context, index) {
            switch (index) {
              case 0:
                return CupertinoTabView(builder: (context) {
                  return CupertinoPageScaffold(child: HomeTab());
                });
              case 1:
                return CupertinoTabView(builder: (context) {
                  return CupertinoPageScaffold(child: TaskTab());
                });
              case 2:
                return CupertinoTabView(builder: (context) {
                  return CupertinoPageScaffold(
                    child: NotificationTab(),
                  );
                });
              case 3:
                return CupertinoTabView(builder: (context) {
                  return CupertinoPageScaffold(
                    child: AccountTab(),
                  );
                });
              default:
                return CupertinoTabView(builder: (context) {
                  return CupertinoPageScaffold(child: HomeTab());
                });
            }
          }),
    );
  }
}

void _addTaskModalBottomSheet(BuildContext context) async {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setState /*You can rename this!*/) {
          return Container(
            height: 700.0,
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'Task Name',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0),
                  ),
                ),
                Container(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Name',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: 20.0, left: 5.0, bottom: 20.0, right: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          print('Add image');
                        },
                        child: Container(
                          padding: EdgeInsets.only(right: 20.0),
                          child: Image(
                            image: AssetImage('assets/plus_add_project.png'),
                          ),
                        ),
                      ),
                      AutoSizeText('Add Project')
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: 20.0, left: 5.0, bottom: 20.0, right: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Image(
                              image: AssetImage('assets/unassigned_icon.png'),
                            ),
                          ),
                          AutoSizeText('Unassigned'),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        var results = await showCalendarDatePicker2Dialog(
                          context: context,
                          config: CalendarDatePicker2WithActionButtonsConfig(
                              selectedDayHighlightColor: ColorsTheme.btnColor,
                              cancelButton: null,
                              shouldCloseDialogAfterCancelTapped: true),
                          barrierDismissible: false,
                          dialogSize: const Size(325, 400),
                          borderRadius: BorderRadius.circular(15),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            top: 20.0, left: 5.0, bottom: 20.0, right: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 20.0),
                              child: Image(
                                image: AssetImage('assets/due_date_icon.png'),
                              ),
                            ),
                            AutoSizeText('Due Date'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Text(
                    'Description',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0),
                  ),
                ),
                Container(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type here',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Text(
                    'STATUS',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: width * 0.45,
                        height: 38.0,
                        child: TextButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              side: BorderSide(color: ColorsTheme.txtDescColor),
                              borderRadius: BorderRadius.circular(14.0),
                            )),
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered) ||
                                  states.contains(MaterialState.focused))
                                return ColorsTheme.txtDescColor;
                              return ColorsTheme.txtDescColor;
                            }),
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered) ||
                                  states.contains(MaterialState.focused))
                                return ColorsTheme.bgColor;

                              return ColorsTheme.bgColor;
                            }),
                          ),
                          child: Text('Incompleted Tasks'),
                          onPressed: () {},
                        ),
                      ),
                      Container(
                        width: width * 0.42,
                        height: 38.0,
                        child: TextButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              side: BorderSide(color: ColorsTheme.txtDescColor),
                              borderRadius: BorderRadius.circular(14.0),
                            )),
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered) ||
                                  states.contains(MaterialState.focused))
                                return ColorsTheme.txtDescColor;
                              return ColorsTheme.txtDescColor;
                            }),
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered) ||
                                  states.contains(MaterialState.focused))
                                return ColorsTheme.bgColor;

                              return ColorsTheme.bgColor;
                            }),
                          ),
                          child: Text('Completed Tasks'),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        side: BorderSide(color: ColorsTheme.txtDescColor),
                        borderRadius: BorderRadius.circular(14.0),
                      )),
                      foregroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered) ||
                            states.contains(MaterialState.focused))
                          return ColorsTheme.txtDescColor;
                        return ColorsTheme.txtDescColor;
                      }),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered) ||
                            states.contains(MaterialState.focused))
                          return ColorsTheme.bgColor;

                        return ColorsTheme.bgColor;
                      }),
                    ),
                    child: Text('In Progress'),
                    onPressed: () {},
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Project Type',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: width * 0.32,
                        height: 38.0,
                        child: TextButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              side: BorderSide(color: ColorsTheme.txtDescColor),
                              borderRadius: BorderRadius.circular(14.0),
                            )),
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered) ||
                                  states.contains(MaterialState.focused))
                                return ColorsTheme.txtDescColor;
                              return ColorsTheme.txtDescColor;
                            }),
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered) ||
                                  states.contains(MaterialState.focused))
                                return ColorsTheme.bgColor;

                              return ColorsTheme.bgColor;
                            }),
                          ),
                          child: Text('UI/UX Design'),
                          onPressed: () {},
                        ),
                      ),
                      Container(
                        width: width * 0.5,
                        height: 38.0,
                        child: TextButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              side: BorderSide(color: ColorsTheme.txtDescColor),
                              borderRadius: BorderRadius.circular(14.0),
                            )),
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered) ||
                                  states.contains(MaterialState.focused))
                                return ColorsTheme.txtDescColor;
                              return ColorsTheme.txtDescColor;
                            }),
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered) ||
                                  states.contains(MaterialState.focused))
                                return ColorsTheme.bgColor;

                              return ColorsTheme.bgColor;
                            }),
                          ),
                          child: Text('Flutter Development'),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: width * 0.32,
                        height: 38.0,
                        child: TextButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              side: BorderSide(color: ColorsTheme.txtDescColor),
                              borderRadius: BorderRadius.circular(14.0),
                            )),
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered) ||
                                  states.contains(MaterialState.focused))
                                return ColorsTheme.txtDescColor;
                              return ColorsTheme.txtDescColor;
                            }),
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered) ||
                                  states.contains(MaterialState.focused))
                                return ColorsTheme.bgColor;

                              return ColorsTheme.bgColor;
                            }),
                          ),
                          child: Text('Web Design'),
                          onPressed: () {},
                        ),
                      ),
                      Container(
                        width: width * 0.5,
                        height: 38.0,
                        child: TextButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              side: BorderSide(color: ColorsTheme.txtDescColor),
                              borderRadius: BorderRadius.circular(14.0),
                            )),
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered) ||
                                  states.contains(MaterialState.focused))
                                return ColorsTheme.txtDescColor;
                              return ColorsTheme.txtDescColor;
                            }),
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered) ||
                                  states.contains(MaterialState.focused))
                                return ColorsTheme.bgColor;

                              return ColorsTheme.bgColor;
                            }),
                          ),
                          child: Text('Laravel Development'),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.camera_alt)),
                          IconButton(onPressed: () {}, icon: Icon(Icons.image)),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.attach_file)),
                          GestureDetector(
                              onTap: () {},
                              child:
                                  Image.asset('assets/add_assignee_icon.png'))
                        ],
                      ),
                      Container(
                        width: width * 0.3,
                        height: 38.0,
                        child: TextButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                              side: BorderSide(color: ColorsTheme.txtDescColor),
                              borderRadius: BorderRadius.circular(14.0),
                            )),
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered) ||
                                  states.contains(MaterialState.focused))
                                return ColorsTheme.txtDescColor;
                              return ColorsTheme.txtDescColor;
                            }),
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered) ||
                                  states.contains(MaterialState.focused))
                                return ColorsTheme.bgColor;

                              return ColorsTheme.bgColor;
                            }),
                          ),
                          child: Text('Create'),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
      });
}
