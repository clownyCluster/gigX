import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:efleet_project_tree/api.dart';
import 'package:efleet_project_tree/colors.dart';
import 'package:efleet_project_tree/login.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class TaskTab extends StatelessWidget {
  const TaskTab({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Tab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: ColorsTheme.bgColor),
      home: const TaskTabPage(),
    );
  }
}

String subject = "Create a Landing Page";
final CalendarController _controller = CalendarController();
String _text = '';
final DateTime today = DateTime.now();
final DateTime startTime =
    DateTime(today.year, today.month, today.day, 9, 0, 0);
final DateTime endTime = startTime.add(const Duration(hours: 1));

class TaskTabPage extends StatefulWidget {
  const TaskTabPage({super.key});

  @override
  State<TaskTabPage> createState() => _TaskTabPageState();
}

List<Appointment> getAppointments() {
  List<Appointment> meetings = <Appointment>[];

  meetings.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: subject,
      color: ColorsTheme.aptBox,

      // recurrenceRule: 'FREQ=DAILY;COUNT=10',
      isAllDay: false));

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

var height, width;
Color inCompColor = Colors.black;
Color compColor = Colors.black;
Color inprogColor = Colors.black;
double _percent = 40.0;
var projects = [];
var project = [];

var tasks = [];
String _currentItemSelected = "Select Project";
int project_id = 0;
int priority_id = 0;
int status_id = 0;
String task_name = "";
String task_desc = "";
String start_date = "";
String end_date = "";
String formatted_start_date = "";
String formatted_end_date = "";
String? access_token;
int? selected_project_id = 0;
bool is_loading = false;

class _TaskTabPageState extends State<TaskTabPage> {
  SharedPreferences? preferences;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pref();
    getProjects();
    getTasks();
    setState(() {
      inCompColor = Colors.black;
      compColor = Colors.black;
      inprogColor = Colors.black;
    });
  }

  Future<void> pref() async {
    this.preferences = await SharedPreferences.getInstance();
    access_token = this.preferences?.getString('access_token');
  }

  Future<void> getTasks() async {
    final _dio = Dio();
    is_loading = true;
    String? access_token;

    this.preferences = await SharedPreferences.getInstance();
    setState(() {
      access_token = this.preferences?.getString('access_token');
    });

    try {
      Response response = await _dio.get(
          API.base_url + 'todos/',
          options: Options(headers: {"authorization": "Bearer $access_token"}));
      Map result = response.data;

      if (response.statusCode == 200) {
        this.preferences?.setBool('someoneLoggedIn', false);
        setState(() {
          tasks = response.data['data'];
          is_loading = false;
          tasks.forEach((element) {
            print(element['end_date']);
          });
        });
      } else if (response.statusCode == 401) {
        await this.preferences?.remove('access_token');
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const Login();
            },
          ),
          (_) => false,
        );
      }

      return null;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        this.preferences?.setBool('someoneLoggedIn', true);
        await this.preferences?.remove('access_token');
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const Login();
            },
          ),
          (_) => false,
        );
      }
      return null;
    }
  }

  int? selectedIndex;
  Widget setupAlertDialoadContainer() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: projects.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                print(projects[index]['id']);
                setState(() {
                  selectedIndex = index;
                  project_id = projects[index]['id'];
                });
                Navigator.of(context).pop();
              },
              child: Container(
                color: selectedIndex == index ? ColorsTheme.btnColor : null,
                child: ListTile(
                  title: Text(
                    projects[index]['title'],
                    style: TextStyle(
                        color: selectedIndex == index
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> getProjects() async {
    final _dio = Dio();

    String? access_token;
    this.preferences = await SharedPreferences.getInstance();
    setState(() {
      access_token = this.preferences?.getString('access_token');
    });

    try {
      Response response = await _dio.get(API.base_url + 'todo-projects',
          options: Options(headers: {"authorization": "Bearer $access_token"}));
      Map result = response.data;
      print('Status Code ' + response.statusCode.toString());

      if (response.statusCode == 200) {
        this.preferences?.setBool('someoneLoggedIn', false);
        setState(() {
          projects = response.data['data'];
        });
        print(projects);
      } else if (response.statusCode == 401) {
        await this.preferences?.remove('access_token');
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const Login();
            },
          ),
          (_) => false,
        );
      }

      return null;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        this.preferences?.setBool('someoneLoggedIn', true);
        await this.preferences?.remove('access_token');
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const Login();
            },
          ),
          (_) => false,
        );
      }
      return null;
    }
  }

  void _addTaskModalBottomSheet(BuildContext context) async {
    Future.delayed(Duration.zero, () {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useRootNavigator: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
          builder: (context) {
            return StatefulBuilder(builder: (BuildContext context,
                StateSetter setState /*You can rename this!*/) {
              return Container(
                height: 700.0,
                padding: EdgeInsets.all(20.0),
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
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
                        onChanged: (value) {
                          setState(() {
                            task_name = value.toString();
                          });
                        },
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
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Please select a project.',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            setupAlertDialoadContainer(),
                                          ],
                                        ),
                                        // content: Column(
                                        //     mainAxisSize: MainAxisSize.min,
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.start,
                                        //     children: <Widget>[
                                        //       new Text(
                                        //           "Please select a project."),
                                        //       PopupMenuButton<dynamic>(
                                        //         itemBuilder: (context) {
                                        //           return projects.map((str) {
                                        //             return PopupMenuItem(
                                        //               height: 20,
                                        //               value: str['id'],
                                        //               child: Text(str['title']),
                                        //             );
                                        //           }).toList();
                                        //         },
                                        //         child: Row(
                                        //           mainAxisSize: MainAxisSize.min,
                                        //           children: <Widget>[
                                        //             Text(_currentItemSelected),
                                        //             Icon(Icons.arrow_drop_down),
                                        //           ],
                                        //         ),
                                        //         onSelected: (v) {
                                        //           setState(() {
                                        //             project_id = v;

                                        //             project = projects
                                        //                 .where((element) =>
                                        //                     element['id'] ==
                                        //                     project_id)
                                        //                 .toList();
                                        //             project.forEach((element) =>
                                        //                 _currentItemSelected =
                                        //                     element['title']);
                                        //             print(project_id);
                                        //           });
                                        //         },
                                        //       ),
                                        //     ]),
                                        actions: <Widget>[
                                          // usually buttons at the bottom of the dialog
                                          new TextButton(
                                            child: new Text("Close"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.only(right: 20.0),
                              child: Image(
                                image:
                                    AssetImage('assets/plus_add_project.png'),
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
                                  image:
                                      AssetImage('assets/unassigned_icon.png'),
                                ),
                              ),
                              AutoSizeText('Unassigned'),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            DateTimeRangePicker(
                                startText: "From",
                                endText: "To",
                                doneText: "Yes",
                                cancelText: "Cancel",
                                interval: 5,
                                initialStartTime: DateTime.now(),
                                initialEndTime:
                                    DateTime.now().add(Duration(days: 20)),
                                mode: DateTimeRangePickerMode.dateAndTime,
                                minimumTime:
                                    DateTime.now().subtract(Duration(days: 5)),
                                maximumTime:
                                    DateTime.now().add(Duration(days: 365)),
                                use24hFormat: false,
                                onConfirm: (start, end) {
                                  formatted_start_date =
                                      DateFormat('dd/MM/yyyy HH:mm')
                                          .format(start);
                                  formatted_end_date =
                                      DateFormat('dd/MM/yyyy HH:mm')
                                          .format(end);
                                  print(formatted_start_date);
                                  print(formatted_end_date);
                                }).showPicker(context);
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
                                    image:
                                        AssetImage('assets/due_date_icon.png'),
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
                        onChanged: (value) {
                          setState(() {
                            task_desc = value.toString();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Type here',
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        'Percent Done',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0),
                      ),
                    ),
                    Container(
                      child: SfSlider(
                        min: 0.0,
                        max: 100.0,
                        value: _percent,
                        activeColor: ColorsTheme.btnColor,
                        interval: 20,
                        showTicks: true,
                        showLabels: true,
                        enableTooltip: true,
                        minorTicksPerInterval: 1,
                        onChanged: (dynamic value) {
                          setState(() {
                            // print(value);
                            _percent = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Priority',
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
                            width: width * 0.23,
                            height: 38.0,
                            child: TextButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: priority_id == 0
                                          ? Colors.white
                                          : ColorsTheme.txtDescColor),
                                  borderRadius: BorderRadius.circular(14.0),
                                )),
                                foregroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered) ||
                                      states.contains(MaterialState.focused))
                                    return priority_id == 0
                                        ? Colors.white
                                        : ColorsTheme.txtDescColor;
                                  return priority_id == 0
                                      ? Colors.white
                                      : ColorsTheme.txtDescColor;
                                }),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered) ||
                                      states.contains(MaterialState.focused))
                                    return priority_id == 0
                                        ? ColorsTheme.compbtnColor
                                        : ColorsTheme.bgColor;

                                  return priority_id == 0
                                      ? ColorsTheme.compbtnColor
                                      : ColorsTheme.bgColor;
                                }),
                              ),
                              child: Text('Low'),
                              onPressed: () {
                                setState(() {
                                  priority_id = 0;
                                });
                              },
                            ),
                          ),
                          Container(
                            width: width * 0.23,
                            height: 38.0,
                            child: TextButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: priority_id == 1
                                          ? Colors.white
                                          : ColorsTheme.txtDescColor),
                                  borderRadius: BorderRadius.circular(14.0),
                                )),
                                foregroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered) ||
                                      states.contains(MaterialState.focused))
                                    return priority_id == 1
                                        ? Colors.white
                                        : ColorsTheme.txtDescColor;
                                  return priority_id == 1
                                      ? Colors.white
                                      : ColorsTheme.txtDescColor;
                                }),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered) ||
                                      states.contains(MaterialState.focused))
                                    return priority_id == 1
                                        ? ColorsTheme.inCompbtnColor
                                        : ColorsTheme.bgColor;

                                  return priority_id == 1
                                      ? ColorsTheme.inCompbtnColor
                                      : ColorsTheme.bgColor;
                                }),
                              ),
                              child: Text('High'),
                              onPressed: () {
                                setState(() {
                                  priority_id = 1;
                                });
                              },
                            ),
                          ),
                          Container(
                            width: width * 0.23,
                            height: 38.0,
                            child: TextButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: priority_id == 2
                                          ? Colors.white
                                          : ColorsTheme.txtDescColor),
                                  borderRadius: BorderRadius.circular(14.0),
                                )),
                                foregroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered) ||
                                      states.contains(MaterialState.focused))
                                    return priority_id == 2
                                        ? Colors.white
                                        : ColorsTheme.txtDescColor;
                                  return priority_id == 2
                                      ? Colors.white
                                      : ColorsTheme.txtDescColor;
                                }),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered) ||
                                      states.contains(MaterialState.focused))
                                    return priority_id == 2
                                        ? ColorsTheme.inProgbtnColor
                                        : ColorsTheme.bgColor;

                                  return priority_id == 2
                                      ? ColorsTheme.inProgbtnColor
                                      : ColorsTheme.bgColor;
                                }),
                              ),
                              child: Text('Urgent'),
                              onPressed: () {
                                setState(() {
                                  priority_id = 2;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Text(
                        'Status',
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
                                  side: BorderSide(
                                      color: status_id == 0
                                          ? Colors.white
                                          : ColorsTheme.txtDescColor),
                                  borderRadius: BorderRadius.circular(14.0),
                                )),
                                foregroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered) ||
                                      states.contains(MaterialState.focused))
                                    return status_id == 0
                                        ? Colors.white
                                        : ColorsTheme.txtDescColor;
                                  return status_id == 0
                                      ? Colors.white
                                      : ColorsTheme.txtDescColor;
                                }),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered) ||
                                      states.contains(MaterialState.focused))
                                    return status_id == 0
                                        ? ColorsTheme.uIUxColor
                                        : ColorsTheme.bgColor;

                                  return status_id == 0
                                      ? ColorsTheme.uIUxColor
                                      : ColorsTheme.bgColor;
                                }),
                              ),
                              child: Text('Todo'),
                              onPressed: () {
                                setState(() {
                                  status_id = 0;
                                });
                              },
                            ),
                          ),
                          Container(
                            width: width * 0.5,
                            height: 38.0,
                            child: TextButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: status_id == 1
                                          ? Colors.white
                                          : ColorsTheme.txtDescColor),
                                  borderRadius: BorderRadius.circular(14.0),
                                )),
                                foregroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered) ||
                                      states.contains(MaterialState.focused))
                                    return status_id == 1
                                        ? Colors.white
                                        : ColorsTheme.txtDescColor;
                                  return status_id == 1
                                      ? Colors.white
                                      : ColorsTheme.txtDescColor;
                                }),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered) ||
                                      states.contains(MaterialState.focused))
                                    return status_id == 1
                                        ? ColorsTheme.inProgbtnColor
                                        : ColorsTheme.bgColor;

                                  return status_id == 1
                                      ? ColorsTheme.inProgbtnColor
                                      : ColorsTheme.bgColor;
                                }),
                              ),
                              child: Text('Progress'),
                              onPressed: () {
                                setState(() {
                                  status_id = 1;
                                });
                              },
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
                                  side: BorderSide(
                                      color: status_id == 2
                                          ? Colors.white
                                          : ColorsTheme.txtDescColor),
                                  borderRadius: BorderRadius.circular(14.0),
                                )),
                                foregroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered) ||
                                      states.contains(MaterialState.focused))
                                    return status_id == 2
                                        ? Colors.white
                                        : ColorsTheme.txtDescColor;
                                  return status_id == 2
                                      ? Colors.white
                                      : ColorsTheme.txtDescColor;
                                }),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered) ||
                                      states.contains(MaterialState.focused))
                                    return status_id == 2
                                        ? ColorsTheme.inCompbtnColor
                                        : ColorsTheme.bgColor;

                                  return status_id == 2
                                      ? ColorsTheme.inCompbtnColor
                                      : ColorsTheme.bgColor;
                                }),
                              ),
                              child: Text('Pending'),
                              onPressed: () {
                                setState(() {
                                  status_id = 2;
                                });
                              },
                            ),
                          ),
                          Container(
                            width: width * 0.5,
                            height: 38.0,
                            child: TextButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: status_id == 3
                                          ? Colors.white
                                          : ColorsTheme.txtDescColor),
                                  borderRadius: BorderRadius.circular(14.0),
                                )),
                                foregroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered) ||
                                      states.contains(MaterialState.focused))
                                    return status_id == 3
                                        ? Colors.white
                                        : ColorsTheme.txtDescColor;
                                  return status_id == 3
                                      ? Colors.white
                                      : ColorsTheme.txtDescColor;
                                }),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered) ||
                                      states.contains(MaterialState.focused))
                                    return status_id == 3
                                        ? ColorsTheme.compbtnColor
                                        : ColorsTheme.bgColor;

                                  return status_id == 3
                                      ? ColorsTheme.compbtnColor
                                      : ColorsTheme.bgColor;
                                }),
                              ),
                              child: Text('Complete'),
                              onPressed: () {
                                setState(() {
                                  status_id = 3;
                                });
                              },
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
                                  onPressed: () {},
                                  icon: Icon(Icons.camera_alt)),
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.image)),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.attach_file)),
                              GestureDetector(
                                  onTap: () {},
                                  child: Image.asset(
                                      'assets/add_assignee_icon.png'))
                            ],
                          ),
                          Container(
                            width: width * 0.3,
                            height: 38.0,
                            child: TextButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: ColorsTheme.txtDescColor),
                                  borderRadius: BorderRadius.circular(14.0),
                                )),
                                foregroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered) ||
                                      states.contains(MaterialState.focused))
                                    return Colors.white;
                                  return Colors.white;
                                }),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered) ||
                                      states.contains(MaterialState.focused))
                                    return ColorsTheme.btnColor;

                                  return ColorsTheme.btnColor;
                                }),
                              ),
                              child: Text('Create'),
                              onPressed: () async {
                                bool result = false;

                                if (task_name.isNotEmpty &&
                                    task_desc.isNotEmpty &&
                                    formatted_start_date.isNotEmpty &&
                                    formatted_end_date.isNotEmpty &&
                                    project_id != 0) {
                                  result = await saveTask();
                                  if (result == true) {
                                    setState(() {
                                      task_name = '';
                                      task_desc = '';
                                      formatted_end_date = '';
                                      formatted_end_date = '';
                                    });
                                    Navigator.of(context).pop();
                                    // getTasks();
                                    Fluttertoast.showToast(
                                        msg: "Task Added!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: ColorsTheme.btnColor,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  } else
                                    Fluttertoast.showToast(
                                        msg: "Something went wrong!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor:
                                            ColorsTheme.dangerColor,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                } else
                                  Fluttertoast.showToast(
                                      msg: "Any field is missing!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: ColorsTheme.dangerColor,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                              },
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
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return SingleChildScrollView(
            child: Container(
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(40.0),
                  child: AutoSizeText(
                    'Tasks',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
                  )),
              Container(
                width: width,
                height: height * 0.85,
                child: SfCalendar(
                  controller: _controller,
                  view: CalendarView.day,
                  firstDayOfWeek: 6,
                  initialSelectedDate: DateTime.now(),
                  cellBorderColor: Colors.transparent,
                  todayHighlightColor: ColorsTheme.btnColor,
                  showNavigationArrow: true,
                  dataSource: MeetingDataSource(getAppointments()),
                  timeSlotViewSettings: TimeSlotViewSettings(
                      timeIntervalHeight: 200.0, timeIntervalWidth: 100),
                  appointmentBuilder: (BuildContext context,
                      CalendarAppointmentDetails calendarAppointmentDetails) {
                    return Container(
                      decoration: BoxDecoration(color: ColorsTheme.aptBox),
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AutoSizeText(
                                  subject,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.0),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.notifications,
                                      color: Colors.white,
                                    ))
                              ],
                            ),
                            Container(
                              child: Text(
                                'eFleetPass',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Divider(
                              thickness: 1.0,
                              color: Colors.white,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.alarm,
                                      color: Colors.white,
                                    )),
                                Text(
                                  DateFormat.Hms()
                                          .format(startTime)
                                          .toString() +
                                      ' - ' +
                                      DateFormat.Hms()
                                          .format(endTime)
                                          .toString(),
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            )
                          ]),
                    );
                  },
                ),
              )
            ],
          ),
        ));
      }),
      floatingActionButton: GestureDetector(
        onTap: () {
          _addTaskModalBottomSheet(context);
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 40.0),
          height: 90,
          width: 90,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/plus_floating_button.png'))),
        ),
      ),
    );
  }
}

Future<bool> saveTask() async {
  final _dio = new Dio();

  try {
    final formData = FormData.fromMap({
      'title': task_name,
      'description': task_desc,
      'start_date': formatted_start_date,
      'end_date': formatted_end_date,
      'percent_done': _percent,
      'project_id': project_id,
      'priority': priority_id,
      'category': status_id
    });
    Response response = await _dio.post(API.base_url + 'todos',
        data: formData,
        options: Options(headers: {
          "Content-type": "multipart/form-data",
          "authorization": "Bearer " + access_token.toString()
        }));
    print(response.data);
    if (response.statusCode == 200) {
      return true;
    } else
      return false;
  } on DioError catch (e) {
    print(e.message);
    return false;
  }
}
