import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:efleet_project_tree/colors.dart';
import 'package:efleet_project_tree/home.dart';
import 'package:efleet_project_tree/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class ProjectDetailsPage extends StatefulWidget {
  const ProjectDetailsPage({super.key});

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  SharedPreferences? preferences;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pref();
    setState(() {
      inCompColor = Colors.black;
      compColor = Colors.black;
      inprogColor = Colors.black;
    });
  }

  Future<void> pref() async {
    this.preferences = await SharedPreferences.getInstance();
    this.preferences?.setBool('viewed_project_details', true);
    print(this.preferences?.getBool('viewed_project_details'));
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return SingleChildScrollView(
          child: Container(
            width: width,
            height: orientation == Orientation.portrait ? height : height * 2.2,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(40.0),
                  margin: EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: IconButton(
                                onPressed: () async {
                                  this.preferences?.setInt('current_index', 0);
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
                                  text: 'eFleet Pass \n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600)),
                              new TextSpan(
                                  text: '5 Tasks',
                                  style: TextStyle(
                                      color: ColorsTheme.txtDescColor))
                            ])),
                          ),
                        ],
                      ),
                      Container(
                        child: Image(
                            image: AssetImage('assets/add_member_icon.png')),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  width: width * 0.8,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(
                          width: width * 0.4,
                          height: 38.0,
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  compColor = Colors.black;
                                  inprogColor = Colors.black;
                                  inCompColor = ColorsTheme.inCompbtnColor;
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
                              child: Text(
                                'Incompleted Tasks',
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
                          width: width * 0.4,
                          height: 38.0,
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  inCompColor = Colors.black;
                                  inprogColor = Colors.black;
                                  compColor = ColorsTheme.compbtnColor;
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
                                'Completed Tasks',
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
                                  inprogColor = ColorsTheme.inProgbtnColor;
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
                                'Inprogress',
                                style: TextStyle(
                                    color: inprogColor,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400),
                              )),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
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

void _addTaskModalBottomSheet(BuildContext context) async {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
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

void _addProjectModalBottomSheet(BuildContext context) async {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setState /*You can rename this!*/) {
          return Container(
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
