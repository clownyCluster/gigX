import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:gigX/api.dart';
import 'package:gigX/colors.dart';
import 'package:gigX/home.dart';
import 'package:gigX/login.dart';
import 'package:gigX/pages/home.dart';
import 'package:gigX/pages/taskdetails.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gigX/pages/time_box.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ProjectDetails extends StatelessWidget {
  const ProjectDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Details Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: ColorsTheme.bgColor),
      home: const ProjectDetailsPage(),
    );
  }
}

var height, width;
Color inCompColor = Colors.black;
Color compColor = Colors.black;
Color inprogColor = Colors.black;
Color todoColor = Colors.black;
double _percent = 40.0;
var projects = [];
var tasks = [];
var tasks_duplicate = [];
var project = [];
var users = [];
String _currentItemSelected = "Select Project";
int project_id = 0;
int priority_id = 0;
int status_id = 0;
int user_id = 0;
String task_name = "";
String task_desc = "";
String start_date = "";
String end_date = "";
String? project_title = "";
String formatted_start_date = "";
String formatted_end_date = "";
String? access_token;
int? selected_project_id = 0;
bool is_loading = false;

class ProjectDetailsPage extends StatefulWidget {
  const ProjectDetailsPage({super.key});

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  SharedPreferences? preferences;
  var formatted_end_date_with_month;
  bool keyboardVisible = false;

  List list = [];
  int current_max = 4;
  late ScrollController controller;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsFlutterBinding.ensureInitialized();

    super.initState();

    KeyboardVisibilityController().onChange.listen((isVisible) {
      setState(() {
        keyboardVisible = isVisible;
      });
    });
    setState(() {
      inCompColor = Colors.black;
      compColor = Colors.black;
      inprogColor = Colors.black;
      todoColor = Colors.black;
    });
    controller = ScrollController();

    list = List.generate(4, (index) => null);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pref();
      getTasks();
      getUsers();
      getProjects();
    });

    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        // pageNumber++;

        setState(() {
          getMoreProjects();
        }); // if add this, Reload your futurebuilder and load more data
      }
    });
  }

  Future<void> pref() async {
    this.preferences = await SharedPreferences.getInstance();
    access_token = this.preferences?.getString('access_token');
    selected_project_id = this.preferences?.getInt('project_id');
    project_title = this.preferences?.getString('project_title');
    print(selected_project_id);
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

  show_loading() async {
    setState(() {
      is_loading = true;
    });
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        is_loading = false;
      });
    });
  }

  getMoreProjects() {
    for (int i = current_max; i < current_max + 4; i++) {
      list.add(i + 2);
    }

    setState(() {
      current_max = current_max + 4;
    });
  }

  Future<void> refreshAddTaskModal() async {
    _addTaskModalBottomSheet(context);
  }

  int? selectedIndex;
  Widget setupSelectProjectDialog() {
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
          API.base_url + 'todos/$selected_project_id/0',
          options: Options(headers: {"authorization": "Bearer $access_token"}));
      Map result = response.data;

      if (response.statusCode == 200) {
        this.preferences?.setBool('someoneLoggedIn', false);
        setState(() {
          tasks = response.data['data'];
          tasks_duplicate = response.data['data'];
          is_loading = false;
          tasks.forEach((element) {
            DateFormat format = DateFormat("dd/MM/yyyy");

            formatted_end_date_with_month = format.parse(element['end_date']);

            element['end_date'] = DateFormat('MMMM dd, yyyy')
                .format(formatted_end_date_with_month!);
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
          print('These are users' + users.toString());
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

  void _addTaskModalBottomSheet(BuildContext context) async {
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
                                          setupSelectProjectDialog(),
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
                                  getTasks();
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

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: OrientationBuilder(builder: (context, orientation) {
        return SingleChildScrollView(
          child: Container(
            width: width,
            height: orientation == Orientation.portrait ? height : height * 2.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(15.0),
                  margin: EdgeInsets.only(top: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: IconButton(
                                onPressed: () async {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Home()));
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                )),
                          ),
                          Container(
                            // padding: EdgeInsets.all(50.0),

                            child: new RichText(
                                text: new TextSpan(children: [
                              new TextSpan(
                                  text: '$project_title \n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600)),
                              new TextSpan(
                                  text: '${tasks.length} Tasks',
                                  style: TextStyle(
                                      color: ColorsTheme.txtDescColor))
                            ])),
                          ),
                        ],
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     showMemberDialog(context);
                      //   },
                      //   child: Container(
                      //     child: Image(
                      //         image: AssetImage('assets/add_member_icon.png')),
                      //   ),
                      // )
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  width: width * 0.95,
                  margin: EdgeInsets.only(left: 30.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: width * 0.3,
                          height: 38.0,
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  compColor = Colors.black;
                                  inprogColor = Colors.black;
                                  todoColor = Colors.black;
                                  inCompColor = ColorsTheme.inCompbtnColor;
                                  tasks = tasks_duplicate;
                                  tasks = tasks
                                      .where(
                                          (element) => element['category'] == 2)
                                      .toList();
                                });
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  side: BorderSide(color: inCompColor),
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
                              child: AutoSizeText(
                                'Pending',
                                style: TextStyle(
                                    color: inCompColor,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400),
                              )),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        SizedBox(
                          width: width * 0.2,
                          height: 38.0,
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  compColor = Colors.black;
                                  inprogColor = Colors.black;
                                  todoColor = ColorsTheme.uIUxColor;
                                  inCompColor = Colors.black;
                                  tasks = tasks_duplicate;

                                  tasks = tasks
                                      .where(
                                          (element) => element['category'] == 0)
                                      .toList();
                                });
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  side: BorderSide(color: todoColor),
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
                              child: Text(
                                'Todo',
                                style: TextStyle(
                                    color: todoColor,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400),
                              )),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        SizedBox(
                          width: width * 0.35,
                          height: 38.0,
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  inCompColor = Colors.black;
                                  inprogColor = Colors.black;
                                  todoColor = Colors.black;
                                  compColor = ColorsTheme.compbtnColor;
                                  tasks = tasks_duplicate;
                                  tasks = tasks
                                      .where(
                                          (element) => element['category'] == 3)
                                      .toList();
                                });
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  side: BorderSide(color: compColor),
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
                              child: Text(
                                'Completed',
                                style: TextStyle(
                                    color: compColor,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400),
                              )),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        SizedBox(
                          width: width * 0.4,
                          height: 38.0,
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  inCompColor = Colors.black;
                                  compColor = Colors.black;
                                  todoColor = Colors.black;
                                  inprogColor = ColorsTheme.inProgbtnColor;

                                  tasks = tasks_duplicate;
                                  tasks = tasks
                                      .where(
                                          (element) => element['category'] == 1)
                                      .toList();
                                });
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                  side: BorderSide(color: inprogColor),
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
                              child: Text(
                                'In Progress',
                                style: TextStyle(
                                    color: inprogColor,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                if (tasks.isNotEmpty)
                  Container(
                    width: width,
                    height: orientation == Orientation.portrait
                        ? height * 0.735
                        : height,
                    padding: EdgeInsets.only(left: 15.0),
                    child: LazyLoadScrollView(
                      onEndOfPage: () => show_loading(),
                      child: ListView.builder(
                          controller: controller,
                          itemCount: list.length < tasks.length
                              ? list.length + 1
                              : tasks.length,
                          shrinkWrap: true,
                          itemExtent: 250.0,
                          itemBuilder: (BuildContext context, index) {
                            if (index == list.length)
                              return Center(
                                  child: CircularProgressIndicator(
                                color: ColorsTheme.btnColor,
                              ));
                            return Container(
                              margin: EdgeInsets.all(10),
                              width: width,
                              child: GestureDetector(
                                onTap: () async {
                                  this.preferences =
                                      await SharedPreferences.getInstance();
                                  this
                                      .preferences
                                      ?.setInt('task_id', tasks[index]['id']);
                                  Navigator.of(context, rootNavigator: false)
                                      .push(MaterialPageRoute(
                                          builder: (context) => TaskDetails()));
                                },
                                child: Container(
                                  height: 180.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                          color: Color(0xffEBEBEB),
                                          width: 2.0)),
                                  child: Column(children: [
                                    Container(
                                      padding: EdgeInsets.all(20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: tasks[index]['title']
                                                        .toString()
                                                        .length >
                                                    20
                                                ? width * 0.5
                                                : width * 0.4,
                                            height: 40.0,
                                            child: TextButton(
                                              style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                )),
                                                foregroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith<Color>(
                                                            (Set<MaterialState>
                                                                states) {
                                                  if (states.contains(
                                                          MaterialState
                                                              .hovered) ||
                                                      states.contains(
                                                          MaterialState
                                                              .focused))
                                                    return ColorsTheme
                                                        .uIUxColor;
                                                  return ColorsTheme.uIUxColor;
                                                }),
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith<Color>(
                                                            (Set<MaterialState>
                                                                states) {
                                                  if (states.contains(
                                                          MaterialState
                                                              .hovered) ||
                                                      states.contains(
                                                          MaterialState
                                                              .focused))
                                                    return Colors
                                                        .purple.shade100;

                                                  return Colors.purple.shade100;
                                                }),
                                              ),
                                              child: AutoSizeText(
                                                tasks[index]['title'],
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color:
                                                        ColorsTheme.uIUxColor,
                                                    fontSize: 12.0,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              onPressed: () {},
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          SizedBox(
                                            width: width * 0.2,
                                            height: 40.0,
                                            child: TextButton(
                                              style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                )),
                                                foregroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith<Color>(
                                                            (Set<MaterialState>
                                                                states) {
                                                  if (states.contains(
                                                          MaterialState
                                                              .hovered) ||
                                                      states.contains(
                                                          MaterialState
                                                              .focused))
                                                    return tasks[index]
                                                                ['priority'] ==
                                                            0
                                                        ? ColorsTheme
                                                            .compbtnColor
                                                        : tasks[index][
                                                                    'priority'] ==
                                                                1
                                                            ? ColorsTheme
                                                                .inCompbtnColor
                                                            : ColorsTheme
                                                                .inProgbtnColor;
                                                  return ColorsTheme.uIUxColor;
                                                }),
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith<Color>(
                                                            (Set<MaterialState>
                                                                states) {
                                                  if (states.contains(
                                                          MaterialState
                                                              .hovered) ||
                                                      states.contains(
                                                          MaterialState
                                                              .focused))
                                                    return tasks[index]
                                                                ['priority'] ==
                                                            0
                                                        ? ColorsTheme
                                                            .compbtnColor
                                                        : tasks[index][
                                                                    'priority'] ==
                                                                1
                                                            ? ColorsTheme
                                                                .inCompbtnColor
                                                            : ColorsTheme
                                                                .inProgbtnColor;
                                                  ;

                                                  return tasks[index]
                                                              ['priority'] ==
                                                          0
                                                      ? Colors.green.shade100
                                                      : tasks[index][
                                                                  'priority'] ==
                                                              1
                                                          ? Colors.red.shade100
                                                          : Colors
                                                              .orange.shade100;
                                                }),
                                              ),
                                              child: Text(
                                                tasks[index]['priority'] == 0
                                                    ? 'Low'
                                                    : tasks[index]
                                                                ['priority'] ==
                                                            1
                                                        ? 'High'
                                                        : 'Urgent',
                                                style: TextStyle(
                                                    color: tasks[index]
                                                                ['priority'] ==
                                                            0
                                                        ? ColorsTheme
                                                            .compbtnColor
                                                        : tasks[index][
                                                                    'priority'] ==
                                                                1
                                                            ? ColorsTheme
                                                                .inCompbtnColor
                                                            : ColorsTheme
                                                                .inProgbtnColor,
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              onPressed: () {},
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(
                                          top: 20.0, bottom: 20.0),
                                      margin:
                                          EdgeInsets.only(left: 20, right: 20),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                        color: Colors.black,
                                      ))),
                                      child: AutoSizeText(
                                        tasks[index]['description'],
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.0),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(20.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                  'assets/due_date_icon.png'),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Text(tasks[index]['end_date']
                                                  .toString())
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ]),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                if (is_loading == true && tasks.isEmpty)
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(top: height * 0.3),
                    // margin: EdgeInsets.only(to),
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(ColorsTheme.btnColor),
                    ),
                  ),
                if (is_loading == false && tasks.length == 0)
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(top: height * 0.3),
                    // margin: EdgeInsets.only(to),
                    child: Text(
                      'No Task Found',
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
      // floatingActionButton: Visibility(
      //   visible: !keyboardVisible,
      //   child: GestureDetector(
      //     onTap: () {
      //       _addTaskModalBottomSheet(context);
      //     },
      //     child: Container(
      //       margin: EdgeInsets.only(bottom: 40.0),
      //       height: 90,
      //       width: 90,
      //       decoration: BoxDecoration(
      //           image: DecorationImage(
      //               image: AssetImage('assets/plus_floating_button.png'))),
      //     ),
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _addProjectModalBottomSheet(context);
      //   },
      //   child: Icon(Icons.add),
      //   backgroundColor: ColorsTheme.btnColor,
      // ),
/////////////////////////////////
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        backgroundColor: ColorsTheme.btnColor,
        distance: 75,
        children: [
          FloatingActionButton.extended(
            backgroundColor: ColorsTheme.btnColor,
            heroTag: null,
            label: Text('TimeBox'),
            icon: Icon(Icons.timer),
            // child: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TimeBoxPage()));
            },
          ),
          FloatingActionButton.extended(
            backgroundColor: ColorsTheme.btnColor,

            heroTag: null,
            label: Text('Tasks'),
            icon: Icon(Icons.task),
            // child: const Icon(Icons.search),
            onPressed: () {
              _addTaskModalBottomSheet(context);
            },
          ),
        ],
      ),
//////////////////////////////////
    );
  }
}

void _addProjectModalBottomSheet(BuildContext context) async {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setState /*You can rename this!*/) {
          return Container(
            color: Colors.white,
            height: 480.0,
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'PROJECT NAME',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0),
                  ),
                ),
                Container(
                  child: TextField(
                    onChanged: (value) {},
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
                      AutoSizeText('Add Project Thumbnail')
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    width: width * 0.3,
                    height: 38.0,
                    child: TextButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
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
                )
              ],
            ),
          );
        });
      });
}

Future<dynamic> showMemberDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
        "ADD MEMBER",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14.0),
      ),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                  fillColor: Color(0xffEBEBEB), hintText: "Name or Email"),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
          },
          child: Text(
            "Save",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
                color: ColorsTheme.btnColor),
          ),
        ),
      ],
    ),
  );
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
      return true;
    } else
      return false;
  } on DioError catch (e) {
    print(e.message);
    return false;
  }
}
