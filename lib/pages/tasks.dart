import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_builder/calendar_builder.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:gigX/api.dart';
import 'package:gigX/colors.dart';
import 'package:gigX/home.dart';
import 'package:gigX/login.dart';
import 'package:gigX/pages/home.dart';
import 'package:gigX/pages/projectdetails.dart';
import 'package:gigX/utils/notification_service.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

var project = [];
var tempList = [];
var userList = [];

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
int assinged_to = 0;
int project_to = 0;
double percent_done = 0.0;
DateTime selected_start_date = DateTime.now();
DateTime selected_end_date = DateTime.now();
bool is_selected_date_changed = false;
Map result = new Map();

class _TaskTabPageState extends State<TaskTabPage> {
  var projects = [];
  var dupList = [];
  var tasks = [];
  var users = [];

  var notifications = [];
  late Map taskMap;
  late Map userMap;
  String? selected_project_index = "";

  SharedPreferences? preferences;
  List<DateTime>? event_start_date = [];
  List<DateTime>? event_end_date = [];

  @override
  void initState() {
    // TODO: implement initState
    WidgetsFlutterBinding.ensureInitialized();

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      pref();
      getProjects();
      getUsers();
      getUserTasks();

      getDeviceToken();
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
          tempList = response.data['data'];
          // tasks = response.data['data'];
          is_loading = false;
          tempList.forEach((element) {
            taskMap = {
              'id': element['id'],
              'start_date': element['start_date'].toString(),
              'end_date': element['end_date'].toString(),
              'project_id': element['project_id'],
              'category': element['category'],
              'priority': element['priority'],
              'title': element['title'].toString(),
              'description': element['description'].toString(),
              'assign_to': element['assign_to'],
              'percent_done': element['percent_done'],
              'selected_project_id': 2
            };
            tasks.add(taskMap);

            // tasks.add(element);
            // tasks.add({'newKey': 2});
            // tasks.add({'newKey': 2});
          });

          tasks.forEach((element) {
            event_start_date?.add(
                DateFormat("dd/MM/yyyy HH:mm").parse(element['start_date']));
            event_end_date?.add(
                DateFormat("dd/MM/yyyy HH:mm").parse(element['end_date']));
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

  List<Appointment> getAppointments() {
    List<Appointment> meetings = <Appointment>[];

    tasks.forEach((element) {
      // DateTime startDate = DateTime.parse(element['start_date']);

      meetings.add(Appointment(
          startTime:
              DateFormat("dd/MM/yyyy HH:mm").parse(element['start_date']),
          endTime: DateFormat("dd/MM/yyyy HH:mm").parse(element['end_date']),
          subject: element['title'],
          color: ColorsTheme.aptBox,
          notes: element['selected_project_id'].toString(),
          id: element['id'],

          // recurrenceRule: 'FREQ=DAILY;COUNT=10',
          isAllDay: false));
    });

    return meetings;
  }

  Future<void> refreshAddTaskModal() async {
    _addTaskModalBottomSheet(context);
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
              onTap: () async {
                setState(() {
                  selectedIndex = index;
                  project_id = projects[index]['id'];
                  selected_project_index =
                      projects[index]['selected_project_id'].toString();
                  print(selected_project_index);
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
  bool selectedAddProject = true;

  Widget setupUpdateSelectProjectDialog(StateSetter updateState) {
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
                updateState(() {
                  selectedAddProject = true;
                  selectedIndex3 = index;
                  print('This is index' + index.toString());

                  project_id = projects[index]['id'];
                });
                Navigator.of(context).pop();
                // refreshUpdateTaskModal();
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
  Widget setupUpdateSelectUserDialog(StateSetter updateState) {
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
                updateState(() {
                  selectedIndex4 = index;
                  user_id = users[index]['id'];
                });
                Navigator.of(context).pop();
                // refreshUpdateTaskModal();
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
    int i = -1;
    late Map projectMap;

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
          dupList = response.data['data'];

          dupList.forEach((element) {
            i++;
            projectMap = {
              'id': element['id'],
              'title': element['title'],
              'selected_project_id': i
            };
            projects.add(projectMap);
          });

          projects.forEach((element) {
            print(element);
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

  Future<void> getUsers() async {
    final _dio = Dio();
    int i = -1;
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
          userList = response.data['data'];

          userList.forEach((element) {
            i++;
            userMap = {
              'id': element['id'],
              'username': element['username'],
              'selected_user_id': i
            };
            users.add(userMap);
          });
          // users
          //     .where((element) => element['email'] == email)
          //     .forEach((element) {
          //   logged_in_user_id = element['id'];
          // });
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
      print(appointment.notes);
      String? picked_project_index = appointment.notes;

      _updateTaskModalBottomSheet(context, task_id, picked_project_index);
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
            notes: selected_project_index.toString(),
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
    DateTime stDate;
    DateTime edDate;

    if (is_selected_date_changed == false) {
      stDate = selected_start_date;
      edDate = selected_end_date;
    } else {
      stDate = DateFormat('d/MM/yyyy HH:mm').parse(formatted_start_date);
      edDate = DateFormat('d/MM/yyyy HH:mm').parse(formatted_end_date);
    }
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

  void setSelectedProjectIndex(int task_id) {
    tasks.where((element) => element['id'] == task_id).forEach((element) {
      element['selected_project_id'] = selected_project_index;
    });
  }

  Future<void> getNotifications() async {
    final _dio = Dio();
    String? access_token;
    DateTime? formatted_updated_at;
    int count = 0;

    DateFormat format = DateFormat("yyyy-MM-dd hh:mm:ss");

    this.preferences = await SharedPreferences.getInstance();
    setState(() {
      access_token = this.preferences?.getString('access_token');
      count++;
    });

    this.preferences?.setInt('count', 0);

    try {
      Response response = await _dio.get(API.base_url + 'my/todo-notifications',
          options: Options(headers: {"authorization": "Bearer $access_token"}));
      Map result = response.data;

      if (response.statusCode == 200) {
        setState(() {
          notifications = response.data['data'];

          notifications
              .where((element) => element['is_read'] == 0)
              .forEach((element) {
            formatted_updated_at = format.parse(element['updated_at']);
            // final difference = formatted_updated_at
            //     ?.difference(DateTime.now())
            //     .inMinutes
            //     .abs();
            // print('The difference is ' + difference.toString());
            // if (difference! < 700) {
            sendNotification(element['id'], element['notification']);
            // }
          });
        });
      }

      return null;
    } on DioError catch (e) {
      return null;
    }
  }

  Future getDeviceToken() async {
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging _firebaseMessage = FirebaseMessaging.instance;
    String? deviceToken = await _firebaseMessage.getToken();
    return (deviceToken == null) ? "" : deviceToken;
    //    final _dio = new Dio();
    // this.preferences = await SharedPreferences.getInstance();
    // setState(() {
    //   access_token = this.preferences?.getString('access_token');
    // });
    // try {
    //   Response response = await _dio.get(API.base_url + 'me',
    //       options: Options(headers: {"authorization": "Bearer $access_token"}));

    //   if (response.statusCode == 200) {
    //     this.preferences?.setBool('someoneLoggedIn', false);
    //     setState(() {

    //     });
    //   } else if (response.statusCode == 401) {
    //     await this.preferences?.remove('access_token');
    //     Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
    //       MaterialPageRoute(
    //         builder: (BuildContext context) {
    //           return const Login();
    //         },
    //       ),
    //       (_) => false,
    //     );
    //   }
    // } on DioError catch (e) {
    //   print(e);

    // }
  }

  Future<void> sendNotification(int id, String notification) async {
    var postUrl = "https://fcm.googleapis.com/fcm/send";

    var token = await getDeviceToken();

    final data = {
      "notification": {"body": "Tap to view details", "title": notification},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": id,
        "status": "done"
      },
      "to": "$token"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAASM8sfCA:APA91bFHBZYV2O1Xix8vA4XYVtUCeJbqNRoNypN2IWeXNcrulxJngCUDNWwGeVniEjy9ET9DQDJDdFuIh6VOTJpnDRXdvbM9lo59dYTiloqOwdOfhvZBy99VNiIz0ntQ7Mwc95-6VuXH'
    };

    BaseOptions options = new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: headers,
    );

    try {
      final response = await Dio(options).post(postUrl, data: data);

      if (response.statusCode == 200) {
        // Fluttertoast.showToast(msg: 'Request Sent To Driver');
      } else {
        print('notification sending failed');
        // on failure do sth
      }
    } catch (e) {
      print('exception $e');
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     IconButton(
                        //         onPressed: () {}, icon: Icon(Icons.camera_alt)),
                        //     IconButton(
                        //         onPressed: () {}, icon: Icon(Icons.image)),
                        //     IconButton(
                        //         onPressed: () {},
                        //         icon: Icon(Icons.attach_file)),
                        //     GestureDetector(
                        //         onTap: () {},
                        //         child:
                        //             Image.asset('assets/add_assignee_icon.png'))
                        //   ],
                        // ),
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

                                  // sendNotification(project_id, 'Task assigned');
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

  void _updateTaskModalBottomSheet(
      BuildContext context, int task_id, String? picked_project_index) async {
    tasks.where((element) => element['id'] == task_id).forEach((element) {
      // print(element);
      txt_updateTaskNameController.text = element['title'];
      txt_updateTaskDescController.text = element['description'];
      task_name = element['title'];
      task_desc = element['description'];
      priority_id = element['priority'];
      status_id = element['category'];
      project_id = element['project_id'];
    });
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
              StateSetter state /*You can rename this!*/) {
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
                        state(() {
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
                                          setupUpdateSelectProjectDialog(state),
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
                        selectedAddProject != false
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
                                              setupUpdateSelectUserDialog(
                                                  state),
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
                              initialStartTime: selected_start_date,
                              initialEndTime: selected_end_date,
                              mode: DateTimeRangePickerMode.dateAndTime,
                              minimumTime:
                                  DateTime.now().subtract(Duration(days: 120)),
                              maximumTime:
                                  DateTime.now().add(Duration(days: 365)),
                              use24hFormat: false,
                              onConfirm: (start, end) {
                                formatted_start_date =
                                    DateFormat('dd/MM/yyyy HH:mm')
                                        .format(start);
                                formatted_end_date =
                                    DateFormat('dd/MM/yyyy HH:mm').format(end);
                              }).showPicker(context);
                          state(() {
                            is_selected_date_changed = true;
                          });
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
                              AutoSizeText('Date Selected'),
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
                      value: percent_done,
                      activeColor: ColorsTheme.btnColor,
                      interval: 20,
                      showTicks: true,
                      showLabels: true,
                      enableTooltip: true,
                      minorTicksPerInterval: 1,
                      onChanged: (dynamic value) {
                        state(() {
                          // print(value);
                          percent_done = value;
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
                              state(() {
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
                              state(() {
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
                              state(() {
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
                              state(() {
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
                              state(() {
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
                              state(() {
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
                              state(() {
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     IconButton(
                        //         onPressed: () {}, icon: Icon(Icons.camera_alt)),
                        //     IconButton(
                        //         onPressed: () {}, icon: Icon(Icons.image)),
                        //     IconButton(
                        //         onPressed: () {},
                        //         icon: Icon(Icons.attach_file)),
                        //     GestureDetector(
                        //         onTap: () {},
                        //         child:
                        //             Image.asset('assets/add_assignee_icon.png'))
                        //   ],
                        // ),
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
                            child: Text('Update'),
                            onPressed: () async {
                              bool result = false;

                              if (task_name.isNotEmpty &&
                                  task_desc.isNotEmpty &&
                                  selected_start_date != null &&
                                  selected_end_date != null) {
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
                                          builder: (context) => const TaskTab(),
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

  void getSelectedTasks(DateTime selectedDateTime) {
    List<String> dates = [];
    late Map selectTaskMap;
    var dupList = [];
    int count = 0;
    // print(DateFormat("dd/MM/yyyy").format(selectedDateTime));
    tasks.where((element) => element['project_id'] != 0).forEach((element) {
      // print(element['start_date']);
      if (element['start_date']
          .toString()
          .substring(0, 11)
          .contains(DateFormat("dd/MM/yyyy").format(selectedDateTime))) {
        count++;
        selectTaskMap = {
          'id': element['id'],
          'title': element['title'],
          'description': element['description'],
          'project_id': element['project_id'],
          'assign_to': element['assign_to'],
          'percent_done': double.parse(element['percent_done']),
          'start_date': element['start_date'],
          'end_date': element['end_date'],
          'selected_project_index': count - 1
        };
        dupList.add(selectTaskMap);
        // print(element['id']);
      }
    });

    showSelectedTaskDetails(context, dupList);
    print(selectTaskMap['project_id']);

    // dates.add(DateFormat("dd/MM/yyyy HH:mm").format(selectedDateTime));
  }

  void showSelectedTaskDetails(
      BuildContext context, List<dynamic> selectedTasks) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      // useRootNavigator: false,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14.0), topRight: Radius.circular(14.0))),
      builder: (context) {
        return StatefulBuilder(builder:
            (BuildContext context, StateSetter state /*You can rename this!*/) {
          return Container(
            height: 560.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text('Tasks'),
                ),
                Container(
                  height: 500.0,
                  width: width,
                  padding: EdgeInsets.all(20.0),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                        itemCount: selectedTasks.length,
                        itemBuilder: ((context, index) {
                          return InkWell(
                            onTap: () {
                              // print(selectedTasks[index]['id']);

                              setState(() {
                                assinged_to = selectedTasks[index]['assign_to'];
                                selected_start_date =
                                    DateFormat("dd/MM/yyyy HH:mm").parse(
                                        selectedTasks[index]['start_date']);
                                selected_end_date =
                                    DateFormat("dd/MM/yyyy HH:mm").parse(
                                        selectedTasks[index]['end_date']);
                                percent_done =
                                    selectedTasks[index]['percent_done'];
                                projects
                                    .where((element) =>
                                        element['id'] ==
                                        selectedTasks[index]['project_id'])
                                    .forEach((element) {
                                  selectedIndex3 =
                                      element['selected_project_id'];
                                  // print(project_to);
                                  print(assinged_to);
                                });

                                users
                                    .where((element) =>
                                        element['id'] ==
                                        selectedTasks[index]['assign_to'])
                                    .forEach((element) {
                                  selectedIndex4 = element['selected_user_id'];
                                });
                              });
                              Navigator.of(context).pop();
                              _updateTaskModalBottomSheet(
                                  context,
                                  selectedTasks[index]['id'],
                                  selectedTasks[index]['project_id']
                                      .toString());
                            },
                            child: Container(
                              width: width * 0.8,
                              height: 200.0,
                              color: ColorsTheme.uIUxColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      child: AutoSizeText(
                                    selectedTasks[index]['title'],
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  )),
                                  Flexible(
                                    child: Container(
                                        child: AutoSizeText(selectedTasks[index]
                                            ['description'])),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
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
                  margin: EdgeInsets.only(top: 40.0),
                  child: AutoSizeText(
                    'Tasks',
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
                  )),
              Container(
                width: width,
                // height: height * 1.9,
                // height: height * 1.9,

                height: orientation == Orientation.portrait && height < 820
                    ? height * 4.62
                    : orientation == Orientation.portrait && height > 820
                        ? height * 4.12
                        : height * 10.42,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: CbMonthBuilder(
                    onDateClicked: (onDateSelected) {
                      {
                        if (onDateSelected.hasEvent)
                          getSelectedTasks(onDateSelected.selectedDate);
                      }
                    },
                    cbConfig: CbConfig(
                        startDate: DateTime(2020),
                        endDate: DateTime(2123),
                        selectedDate: DateTime(2022),
                        selectedYear: DateTime(2022),
                        weekStartsFrom: WeekStartsFrom.sunday,

                        // eventDates: [
                        //   // DateTime(2022, 1, 2),
                        //   // DateTime(2022, 1, 2),
                        //   // DateTime(2022, 1, 3)
                        // ],

                        eventDates: event_start_date,
                        highlightedDates: []),
                    yearDropDownCustomizer: YearDropDownCustomizer(
                      yearHeaderBuilder: (isYearPickerExpanded, selectedDate,
                          selectedYear, year) {
                        return Container(
                          height: 40,
                          color: ColorsTheme.uIUxColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                year,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Icon(!isYearPickerExpanded
                                  ? Icons.arrow_drop_down_outlined
                                  : Icons.arrow_drop_up_outlined)
                            ],
                          ),
                        );
                      },
                    ),
                    monthCustomizer: MonthCustomizer(
                      montMinhHeight: 200,
                      monthMinWidth: 450,
                      padding: const EdgeInsets.all(20),
                      monthHeaderBuilder:
                          (month, headerHeight, headerWidth, paddingLeft) {
                        return Container(
                          color: Colors.grey[200],
                          height: headerHeight,
                          width: headerWidth,
                          child: Padding(
                            padding: EdgeInsets.only(left: paddingLeft),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                month,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      monthWeekBuilder: (index, weeks, weekHeight, weekWidth) {
                        return SizedBox(
                          height: weekHeight,
                          width: weekWidth,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.red)),
                              child: Align(
                                child: Text(
                                  weeks,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      monthButtonBuilder: (dateTime,
                          childHeight,
                          childWidth,
                          isSelected,
                          isDisabled,
                          hasEvent,
                          isHighlighted,
                          isCurrentDay) {
                        //Text Theme
                        final txtTheme = Theme.of(context).textTheme;
                        //color theme
                        final colorTheme = Theme.of(context);

                        var daysText = Align(
                          child: Text(
                            '${dateTime.day}',
                            style: isDisabled
                                ? txtTheme.caption
                                : isSelected
                                    ? txtTheme.bodyText1!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorTheme.brightness ==
                                                Brightness.dark
                                            ? Colors.black
                                            : Colors.white)
                                    : isHighlighted
                                        ? txtTheme
                                            .bodyText2 //Highlighted TextStyle
                                        : isCurrentDay
                                            ? txtTheme
                                                .bodyText2 //CurrentDay TextStyle
                                            : txtTheme.bodyText2,
                          ),
                        );
                        if (isSelected) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.rectangle,
                            ),
                            margin: const EdgeInsets.all(2),
                            child: daysText,
                          );
                        }
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.0),
                              border: hasEvent || isHighlighted
                                  ? Border.all(
                                      color: isHighlighted
                                          ? Colors.red
                                          : Colors.blue,
                                      width: 2)
                                  : null),
                          margin: const EdgeInsets.all(2),
                          child: daysText,
                        );
                      },
                    ),
                  ),
                ),

                // child: SfCalendar(
                //   controller: _controller,
                //   key: ValueKey(view),
                //   view: CalendarView.timelineMonth,
                //   firstDayOfWeek: 6,
                //   initialSelectedDate: DateTime.now(),
                //   cellBorderColor: Colors.transparent,
                //   todayHighlightColor: ColorsTheme.btnColor,
                //   showNavigationArrow: true,
                //   showDatePickerButton: true,
                //   onTap: calendarTapped,
                //   dataSource: MeetingDataSource(getAppointments()),
                //   timeSlotViewSettings: TimeSlotViewSettings(
                //       timeIntervalHeight: 600,
                //       timeIntervalWidth: 80,
                //       dayFormat: 'EEEE',
                //       dateFormat: 'dd',
                //       timeFormat: 'hh:mm: a',
                //       timelineAppointmentHeight: 800),
                //   appointmentBuilder: (BuildContext context,
                //       CalendarAppointmentDetails calendarAppointmentDetails) {
                //     final Appointment meeting =
                //         calendarAppointmentDetails.appointments.first;
                //     // DateFormat format = DateFormat("dd/MM/yyyy");

                //     return SingleChildScrollView(
                //       scrollDirection: Axis.vertical,
                //       physics: NeverScrollableScrollPhysics(),
                //       child: Container(
                //         decoration: BoxDecoration(color: ColorsTheme.aptBox),
                //         padding: EdgeInsets.all(10.0),
                //         height: 300,
                //         child: Column(
                //             mainAxisAlignment: MainAxisAlignment.start,
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               FittedBox(
                //                 fit: BoxFit.contain,
                //                 child: Row(
                //                   mainAxisAlignment:
                //                       MainAxisAlignment.spaceBetween,
                //                   children: [
                //                     AutoSizeText(
                //                       meeting.subject,
                //                       style: TextStyle(
                //                           color: Colors.white,
                //                           fontWeight: FontWeight.w600,
                //                           fontSize: 18.0),
                //                     ),
                //                     IconButton(
                //                         onPressed: () {},
                //                         icon: Icon(
                //                           Icons.notifications,
                //                           color: Colors.white,
                //                         ))
                //                   ],
                //                 ),
                //               ),
                //               Container(
                //                 child: Text(
                //                   'eFleetPass',
                //                   style: TextStyle(
                //                       color: Colors.white,
                //                       fontSize: 12.0,
                //                       fontWeight: FontWeight.w400),
                //                 ),
                //               ),
                //               Divider(
                //                 thickness: 1.0,
                //                 color: Colors.white,
                //               ),
                //               FittedBox(
                //                 fit: BoxFit.contain,
                //                 child: Row(
                //                   mainAxisAlignment: MainAxisAlignment.start,
                //                   children: [
                //                     IconButton(
                //                         onPressed: () {},
                //                         icon: Icon(
                //                           Icons.alarm,
                //                           color: Colors.white,
                //                         )),
                //                     Text(
                //                       DateFormat('MMMM dd, yyyy hh:mm a')
                //                               .format(meeting.startTime) +
                //                           ' - ' +
                //                           DateFormat('MMMM dd, yyyy hh:mm a')
                //                               .format(meeting.endTime),
                //                       style: TextStyle(color: Colors.white),
                //                     )
                //                   ],
                //                 ),
                //               )
                //             ]),
                //       ),
                //     );
                //   },
                // ),
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
