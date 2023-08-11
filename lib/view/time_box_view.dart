import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:gigX/constant/constants.dart';
import 'package:gigX/pages/tasks.dart';
import 'package:gigX/view_model/time_box_view_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeboxView extends StatelessWidget {
  const TimeboxView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Get.put(TimeBoxViewModel());

    showColorPickUpDialog() {
      return showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  // insetPadding: EdgeInsets.zero,
                  title: Text('Pick a Color!', style: kBoldTextStyle()),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: state.pickerColor.value,
                      onColorChanged: (val) {
                        state.onColorChanged(val);
                      },
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        "Cancel",
                        style: kTextStyle().copyWith(color: Colors.grey),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                        child: Text(
                          'Ok',
                          style: kTextStyle().copyWith(color: primaryColor),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        }),
                  ],
                );
              },
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Time Box',
          style: kkBoldTextStyle(),
        ),
      ),
      body: SfCalendar(
        view: CalendarView.day,
        initialSelectedDate: DateTime.now(),
        firstDayOfWeek: 1,
        dataSource: MeetingDataSource(getAppointments()),
        onLongPress: (calendarLongPressDetails) {
          print(calendarLongPressDetails.date);
          Get.bottomSheet(Container(
              padding: kStandardPadding(),
              decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  LSizedBox(),
                  Text(
                    'Appointment Title',
                    style: kBoldTextStyle(),
                  ),
                  sSizedBox(),
                  TextFormField(
                    decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: primaryColor)),
                        labelText: 'Title'),
                  ),
                  kSizedBox(),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Duration(hrs)',
                              style: kBoldTextStyle(),
                            ),
                            sSizedBox(),
                            TextFormField(
                                decoration: InputDecoration(
                                    isDense: true,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide:
                                            BorderSide(color: primaryColor)),
                                    labelText: 'duration')),
                          ],
                        ),
                      ),
                      largeWidthSpan(),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Colors',
                            style: kBoldTextStyle(),
                          ),
                          sSizedBox(),
                          InkWell(
                            onTap: () {
                              showColorPickUpDialog();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(5)),
                              padding: kStandardPadding(),
                              child: Row(
                                children: [
                                  Obx(
                                    () => SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Container(
                                        color: state.pickerColor.value,
                                      ),
                                    ),
                                  ),
                                  Center(
                                      child: Text(
                                    ' Pick Color',
                                  )),
                                ],
                              ),
                            ),
                          )
                          // Container(
                          //     width: double.infinity,
                          //     decoration: BoxDecoration(
                          //       border: Border.all(color: Colors.grey),
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //     child: DropdownButtonHideUnderline(
                          //       child: DropdownButton(
                          //           isExpanded: true,
                          //           padding: EdgeInsets.only(left: 10),
                          //           value: state.selectedColor.value,
                          //           items: state.colors.map((e) {
                          //             return DropdownMenuItem(
                          //                 value: e, child: Text(e));
                          //           }).toList(),
                          //           onChanged: (val) {
                          //             state.onSelectedColorsChanged(val);
                          //           }),
                          //     )),
                        ],
                      )),
                    ],
                  ),
                  LSizedBox(),
                  LSizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: Get.width * 0.4,
                        padding: kStandardPadding(),
                        child: Center(
                          child: Text(
                            'Add',
                            style: TextStyle(color: whiteColor),
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: primaryColor),
                      ),
                    ],
                  ),
                  LSizedBox(),
                  LSizedBox(),
                ],
              )));
        },
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

List data = [
  {
    'startTime': DateTime(2023, 08, 08, 01, 0, 0),
    'endTime': DateTime(2023, 08, 08, 07, 0, 0),
    'subject': 'Subject 1',
    'color': Colors.blue
  },
  {
    'startTime': DateTime(2023, 08, 09, 8, 0, 0),
    'endTime': DateTime(2023, 08, 09, 9, 30, 0),
    'subject': 'Subject 2',
    'color': Colors.red
  },
  {
    'startTime': DateTime(2023, 08, 07, 13, 0, 0),
    'endTime': DateTime(2023, 08, 07, 17, 0, 0),
    'subject': 'Subject 3',
    'color': Colors.orange
  },
  {
    'startTime': DateTime(2023, 08, 10, 2, 0, 0),
    'endTime': DateTime(2023, 08, 10, 6, 0, 0),
    'subject': 'Subject 4',
    'color': Colors.green
  }
];

List<Appointment> getAppointments() {
  List<Appointment> meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(Duration(hours: 2));

  data.forEach((element) {
    meetings.add(Appointment(
        startTime: element['startTime'],
        endTime: element['endTime'],
        color: element['color'],
        subject: element['subject']));
  });

  // meetings.add(Appointment(
  //     startTime: startTime,
  //     endTime: endTime,
  //     subject: 'Meeting',
  //     color: Colors.amber));

  return meetings;
}
