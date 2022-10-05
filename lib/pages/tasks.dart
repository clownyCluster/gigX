import 'package:auto_size_text/auto_size_text.dart';
import 'package:efleet_project_tree/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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

var height, width;
final CalendarController _controller = CalendarController();
String _text = '';

class TaskTabPage extends StatefulWidget {
  const TaskTabPage({super.key});

  @override
  State<TaskTabPage> createState() => _TaskTabPageState();
}

List<Appointment> getAppointments() {
  List<Appointment> meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));

  meetings.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: 'Board Meeting',
      color: Colors.blue,
      // recurrenceRule: 'FREQ=DAILY;COUNT=10',
      isAllDay: false));

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class _TaskTabPageState extends State<TaskTabPage> {
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
                  view: CalendarView.week,
                  firstDayOfWeek: 6,
                  initialSelectedDate: DateTime.now(),
                  cellBorderColor: Colors.transparent,
                  todayHighlightColor: ColorsTheme.btnColor,
                  showNavigationArrow: true,
                  dataSource: MeetingDataSource(getAppointments()),
                ),
              )
            ],
          ),
        ));
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
            child: Column(
              children: [
                Container(
                  child: Text('Hey'),
                ),
              ],
            ),
          );
        });
      });
}
