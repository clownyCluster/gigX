import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:efleet_project_tree/api.dart';
import 'package:efleet_project_tree/colors.dart';
import 'package:efleet_project_tree/home.dart';
import 'package:efleet_project_tree/login.dart';
import 'package:efleet_project_tree/pages/home.dart';
import 'package:efleet_project_tree/pages/projectdetails.dart';
import 'package:efleet_project_tree/utils/notification_service.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
      ),
      home: const TaskTabPage(),
    );
  }
}

String subject = "";
String formatted_start_time = "";
String formatted_end_time = "";
final CalendarController _controller = CalendarController();
CalendarView? view;
String _text = '';
final DateTime today = DateTime.now();
final DateTime startTime =
    DateTime(today.year, today.month, today.day, 9, 0, 0);
final DateTime endTime = startTime.add(const Duration(hours: 1));
int created_task_id = 0;
TextEditingController txt_addTaskNameController = new TextEditingController();
TextEditingController txt_addTaskDescController = new TextEditingController();
TextEditingController txt_updateTaskNameController =
    new TextEditingController();
TextEditingController txt_updateTaskDescController =
    new TextEditingController();

class TaskTabPage extends StatefulWidget {
  const TaskTabPage({super.key});

  @override
  State<TaskTabPage> createState() => _TaskTabPageState();
}

List<Appointment> getAppointments() {
  List<Appointment> meetings = <Appointment>[];

  tasks.forEach((element) {
    // DateTime startDate = DateTime.parse(element['start_date']);
    DateTime tempStartDateTime =
        new DateFormat("dd/MM/yyyy HH:mm").parse(element['start_date']);

    subject = element['title'];

    DateTime tempEndDateTime =
        new DateFormat("dd/MM/yyyy HH:mm").parse(element['end_date']);
    formatted_start_time = DateFormat.Hm().format(tempStartDateTime);
    formatted_end_time = DateFormat.Hm().format(tempEndDateTime);
    print(formatted_start_time);
    meetings.add(Appointment(
        startTime: DateFormat("dd/MM/yyyy HH:mm").parse(element['start_date']),
        endTime: DateFormat("dd/MM/yyyy HH:mm").parse(element['end_date']),
        subject: element['title'],
        color: ColorsTheme.aptBox,
        id: element['id'],

        // recurrenceRule: 'FREQ=DAILY;COUNT=10',
        isAllDay: false));
  });

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
var users = [];
var tasks = [];
String _currentItemSelected = "Select Project";
int project_id = 0;
int priority_id = 0;
int status_id = 0;
int user_id = 0;
String task_name = "";
String task_desc = "";
String start_date = "";
String end_date = "";
String formatted_start_date = "";
String formatted_end_date = "";
String? access_token;
int? selected_project_id = 0;
int logged_in_user_id = 0;
bool is_loading = false;
Map result = new Map();

class _TaskTabPageState extends State<TaskTabPage> {
  SharedPreferences? preferences;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print('testing here so');
      pref();
      getProjects();
      getUsers();
      getUserTasks();
      setState(() {
        inCompColor = Colors.black;
        compColor = Colors.black;
        inprogColor = Colors.black;
      });
    });
  }

  Future<void> pref() async {
    this.preferences = await SharedPreferences.getInstance();
    access_token = this.preferences?.getString('access_token');
  }

  Future<void> getUserTasks() async {
    final _dio = Dio();
    is_loading = true;
    String? access_token;

    this.preferences = await SharedPreferences.getInstance();
    setState(() {
      access_token = this.preferences?.getString('access_token');
    });

    try {
      Response response = await _dio.get(API.base_url + 'my/todos',
          options: Options(headers: {"authorization": "Bearer $access_token"}));

      if (response.statusCode == 200) {
        this.preferences?.setBool('someoneLoggedIn', false);
        setState(() {
          tasks = response.data['data'];
          is_loading = false;
          tasks.forEach((element) {
            var len = [];
            len = element['end_date'];
            print(len.length);
          });
          result = response.data;
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

  Future<void> refreshAddTaskModal() async {
    _addTaskModalBottomSheet(context);
  }

  Future<void> refreshUpdateTaskModal() async {
    CalendarTapDetails? calendarTapDetails;
    Appointment appointment = calendarTapDetails!.appointments![0];
    int task_id = appointment.id as int;
    print('this is task_id ' + task_id.toString());
    _updateTaskModalBottomSheet(context, task_id);
  }

  int? selectedIndex;
  Widget setupAddSelectProjectDialog() {
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
                refreshAddTaskModal();
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

  int? selectedIndex2;
  Widget setupSelectUserDialog() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                print(users[index]['id']);
                setState(() {
                  selectedIndex2 = index;
                  user_id = users[index]['id'];
                });
                Navigator.of(context).pop();
                refreshAddTaskModal();
              },
              child: Container(
                color: selectedIndex2 == index ? ColorsTheme.btnColor : null,
                child: ListTile(
                  title: Text(
                    users[index]['username'],
                    style: TextStyle(
                        color: selectedIndex2 == index
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

  int? selectedIndex3;
  Widget setupUpdateSelectProjectDialog() {
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
                  selectedIndex3 = index;
                  project_id = projects[index]['id'];
                });
                Navigator.of(context).pop();
                refreshUpdateTaskModal();
              },
              child: Container(
                color: selectedIndex3 == index ? ColorsTheme.btnColor : null,
                child: ListTile(
                  title: Text(
                    projects[index]['title'],
                    style: TextStyle(
                        color: selectedIndex3 == index
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

  int? selectedIndex4;
  Widget setupUpdateSelectUserDialog() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                print(users[index]['id']);
                setState(() {
                  selectedIndex4 = index;
                  user_id = users[index]['id'];
                });
                Navigator.of(context).pop();
                refreshUpdateTaskModal();
              },
              child: Container(
                color: selectedIndex4 == index ? ColorsTheme.btnColor : null,
                child: ListTile(
                  title: Text(
                    users[index]['username'],
                    style: TextStyle(
                        color: selectedIndex4 == index
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

  Future<void> getUsers() async {
    final _dio = Dio();
    final storage = new FlutterSecureStorage();
    email = await storage.read(key: 'email') ?? '';

    String? access_token;
    this.preferences = await SharedPreferences.getInstance();
    setState(() {
      access_token = this.preferences?.getString('access_token');
    });

    try {
      Response response = await _dio.get(API.base_url + 'users/select2',
          options: Options(headers: {"authorization": "Bearer $access_token"}));
      Map result = response.data;
      print('Status Code ' + response.statusCode.toString());

      if (response.statusCode == 200) {
        this.preferences?.setBool('someoneLoggedIn', false);
        setState(() {
          users = response.data['data'];
          users
              .where((element) => element['email'] == email)
              .forEach((element) {
            logged_in_user_id = element['id'];
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

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.appointment) {
      Appointment appointment = calendarTapDetails.appointments![0];
      int task_id = appointment.id as int;
      print(task_id);
      _updateTaskModalBottomSheet(context, task_id);
    }
  }

  Future<bool> saveTask() async {
    final _dio = new Dio();
    DateTime stDate = DateFormat('d/MM/yyyy HH:mm').parse(formatted_start_date);
    DateTime edDate = DateFormat('d/MM/yyyy HH:mm').parse(formatted_end_date);
    Map<String, dynamic> result = Map<String, dynamic>();

    try {
      final formData = FormData.fromMap({
        'title': task_name,
        'description': task_desc,
        'start_date': formatted_start_date,
        'end_date': formatted_end_date,
        'percent_done': _percent,
        'project_id': project_id,
        'priority': priority_id,
        'category': status_id,
        'assign_to': user_id
      });
      Response response = await _dio.post(API.base_url + 'todos',
          data: formData,
          options: Options(headers: {
            "Content-type": "multipart/form-data",
            "authorization": "Bearer " + access_token.toString()
          }));
      print(response.data);
      if (response.statusCode == 200) {
        result = response.data['data'];
        setState(() {
          created_task_id = result['id'];
        });
        List<Appointment> meetings = <Appointment>[];
        meetings.add(Appointment(
            startTime: stDate,
            endTime: edDate,
            subject: task_name,
            color: ColorsTheme.aptBox,
            id: result['id'],

            // recurrenceRule: 'FREQ=DAILY;COUNT=10',
            isAllDay: false));

        return true;
      } else
        return false;
    } on DioError catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<bool> updateTask(int task_id) async {
    final _dio = new Dio();

    DateTime stDate = DateFormat('d/MM/yyyy HH:mm').parse(formatted_start_date);
    DateTime edDate = DateFormat('d/MM/yyyy HH:mm').parse(formatted_end_date);
    Map<String, dynamic> result = Map<String, dynamic>();
    // print(stDate);
    // print(edDate);
    // return false;
    try {
      final formData = FormData.fromMap({
        'title': task_name,
        'description': task_desc,
        'start_date': formatted_start_date,
        'end_date': formatted_end_date,
        'percent_done': _percent,
        'project_id': project_id,
        'priority': priority_id,
        'category': status_id,
        'assign_to': user_id
      });
      Response response = await _dio.post(API.base_url + 'todos/$task_id',
          data: formData,
          options: Options(headers: {
            "Content-type": "multipart/form-data",
            "authorization": "Bearer " + access_token.toString()
          }));
      print(response.data);
      if (response.statusCode == 200) {
        List<Appointment> meetings = <Appointment>[];
        meetings.add(Appointment(
            startTime: stDate,
            endTime: edDate,
            subject: task_name,
            color: ColorsTheme.aptBox,
            id: task_id,

            // recurrenceRule: 'FREQ=DAILY;COUNT=10',
            isAllDay: false));

        result = response.data['data'];
        setState(() {
          created_task_id = result['id'];
        });

        return true;
      } else
        return false;
    } on DioError catch (e) {
      print(e.message);
      return false;
    }
  }

  void _addTaskModalBottomSheet(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        useRootNavigator: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.0),
                topRight: Radius.circular(14.0))),
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              height: 620.0,
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
                      controller: txt_addTaskNameController,
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
                            Navigator.of(context).pop();

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
                                          setupAddSelectProjectDialog(),
                                        ],
                                      ),
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
                              image: AssetImage('assets/plus_add_project.png'),
                            ),
                          ),
                        ),
                        selectedIndex != null
                            ? AutoSizeText('Project Selected')
                            : AutoSizeText('Add Project')
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
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
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
                                                'Please select a user.',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              setupSelectUserDialog(),
                                            ],
                                          ),
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
                                      AssetImage('assets/unassigned_icon.png'),
                                ),
                              ),
                            ),
                            selectedIndex2 != null
                                ? AutoSizeText('Assigned')
                                : AutoSizeText('Unassigned'),
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
                                    DateFormat('dd/MM/yyyy HH:mm').format(end);
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
                      controller: txt_addTaskDescController,
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
                                onPressed: () {}, icon: Icon(Icons.camera_alt)),
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.image)),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.attach_file)),
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
                                side:
                                    BorderSide(color: ColorsTheme.txtDescColor),
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
                                  getUserTasks();
                                  txt_addTaskNameController.clear();
                                  txt_addTaskDescController.clear();
                                  Fluttertoast.showToast(
                                      msg: "Task Added!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: ColorsTheme.btnColor,
                                      textColor: Colors.white,
                                      fontSize: 16.0);

                                  getAppointments();

                                  Navigator.of(context, rootNavigator: false)
                                      .push(MaterialPageRoute(
                                          builder: (context) => const TaskTab(),
                                          fullscreenDialog: true));

                                  // NotificationService().showNotification(
                                  //     created_task_id,
                                  //     'Task Added Successfully!',
                                  //     'Tap to view details',
                                  //     10,
                                  //     logged_in_user_id);
                                } else
                                  Fluttertoast.showToast(
                                      msg: "Something went wrong!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: ColorsTheme.dangerColor,
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
  }

  void _updateTaskModalBottomSheet(BuildContext context, int task_id) async {
    Future.delayed(Duration.zero, () {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: true,
          // useRootNavigator: false,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.0),
                  topRight: Radius.circular(14.0))),
          builder: (context) {
            return StatefulBuilder(builder: (BuildContext context,
                StateSetter setState /*You can rename this!*/) {
              return Container(
                height: 620.0,
                padding: EdgeInsets.all(20.0),
                child: ListView(
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
                        controller: txt_updateTaskNameController,
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
                                            setupUpdateSelectProjectDialog(),
                                          ],
                                        ),
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
                          selectedIndex3 != null
                              ? AutoSizeText('Project Selected')
                              : AutoSizeText('Add Project')
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
                                                  'Please select a user.',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                setupUpdateSelectUserDialog(),
                                              ],
                                            ),
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
                                    image: AssetImage(
                                        'assets/unassigned_icon.png'),
                                  ),
                                ),
                              ),
                              selectedIndex4 != null
                                  ? AutoSizeText('Assigned')
                                  : AutoSizeText('Unassigned'),
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
                                minimumTime: DateTime.now()
                                    .subtract(Duration(days: 120)),
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
                        controller: txt_updateTaskDescController,
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
                              child: Text('Update'),
                              onPressed: () async {
                                bool result = false;

                                if (task_name.isNotEmpty &&
                                    task_desc.isNotEmpty &&
                                    formatted_start_date.isNotEmpty &&
                                    formatted_end_date.isNotEmpty &&
                                    project_id != 0) {
                                  result = await updateTask(task_id);
                                  if (result == true) {
                                    setState(() {
                                      task_name = '';
                                      task_desc = '';
                                      formatted_end_date = '';
                                      formatted_end_date = '';
                                    });
                                    Navigator.of(context).pop();
                                    getUserTasks();
                                    txt_updateTaskNameController.clear();
                                    txt_updateTaskDescController.clear();

                                    Fluttertoast.showToast(
                                        msg: "Task Updated!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: ColorsTheme.btnColor,
                                        textColor: Colors.white,
                                        fontSize: 16.0);

                                    getAppointments();

                                    Navigator.of(context, rootNavigator: false)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                const TaskTab(),
                                            fullscreenDialog: true));

                                    // NotificationService().showNotification(
                                    //     created_task_id,
                                    //     'Task Updated Successfully!',
                                    //     'Tap to view details',
                                    //     10);
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
      resizeToAvoidBottomInset: false,
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
                height: height * 1.9,
                child: SfCalendar(
                  controller: _controller,
                  key: ValueKey(view),
                  view: CalendarView.timelineDay,
                  firstDayOfWeek: 6,
                  initialSelectedDate: DateTime.now(),
                  cellBorderColor: Colors.transparent,
                  todayHighlightColor: ColorsTheme.btnColor,
                  showNavigationArrow: true,
                  showDatePickerButton: true,
                  onTap: calendarTapped,
                  dataSource: MeetingDataSource(getAppointments()),
                  timeSlotViewSettings: TimeSlotViewSettings(
                      timeIntervalHeight: 600,
                      timeIntervalWidth: 80,
                      timelineAppointmentHeight: 800),
                  appointmentBuilder: (BuildContext context,
                      CalendarAppointmentDetails calendarAppointmentDetails) {
                    final Appointment meeting =
                        calendarAppointmentDetails.appointments.first;
                    // DateFormat format = DateFormat("dd/MM/yyyy");

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      child: Container(
                        decoration: BoxDecoration(color: ColorsTheme.aptBox),
                        padding: EdgeInsets.all(10.0),
                        height: 300,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FittedBox(
                                fit: BoxFit.contain,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AutoSizeText(
                                      meeting.subject,
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
                              FittedBox(
                                fit: BoxFit.contain,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.alarm,
                                          color: Colors.white,
                                        )),
                                    Text(
                                      meeting.startTime
                                              .toString()
                                              .substring(0, 16)
                                              .replaceAll('-', '/') +
                                          ' - ' +
                                          meeting.endTime
                                              .toString()
                                              .substring(0, 16)
                                              .replaceAll('-', '/'),
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              )
                            ]),
                      ),
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
