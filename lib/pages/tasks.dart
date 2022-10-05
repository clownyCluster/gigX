import 'package:auto_size_text/auto_size_text.dart';
import 'package:efleet_project_tree/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

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
