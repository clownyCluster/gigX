import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_builder/calendar_builder.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gigX/appRoute/routeName.dart';
import 'package:gigX/main.dart';
import 'package:gigX/pages/single_day_task_module/singleDayTask.dart';
import 'package:gigX/pages/single_day_task_module/single_day_task_state.dart';
import 'package:gigX/pages/taskdetails.dart';
import 'package:gigX/service/toastService.dart';
import 'package:gigX/view_model/task_view_model.dart';
import 'package:intl/intl.dart';
import 'package:paged_vertical_calendar/utils/date_utils.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:paged_vertical_calendar/paged_vertical_calendar.dart';

import '../colors.dart';
import '../constant/constants.dart';

class TaskViewScreen extends StatelessWidget {
  const TaskViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('Widget being build');
    final state = Get.put(TaskViewModel());

    // List<Event> _getEventsForDay(DateTime day) {
    //   return kEvents[day] ?? [];
    // }

    // final kEvents = LinkedHashMap<DateTime, List<Event>>(
    //   equals: isSameDay,
    //   hashCode: getHashCode,
    // )..addAll(_kEventSource);

    // final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    //     key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    //     value: (item) => List.generate(
    //         item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
    //   ..addAll({
    //     kToday: [
    //       Event('Event 1'),
    //       Event('Event 2'),
    //     ],
    //   });

    int? selectedIndex4;
    Widget setupUpdateSelectUserDialog() {
      return Container(
        height: 300.0, // Change as per your requirement
        width: 300.0, // Change as per your requirement
        child: Scrollbar(
          thumbVisibility: true,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: state.userResponse!.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  state.onUserChanged(
                      index, state.userResponse!.data![index].id);
                  Get.back();
                  // refreshUpdateTaskModal();
                },
                child: Container(
                  color:
                      state.selectedUser == index ? ColorsTheme.btnColor : null,
                  child: ListTile(
                    title: Text(
                      state.userResponse!.data![index].username ?? '',
                      style: TextStyle(
                          color: state.selectedUser == index
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

    CleanCalendarController calendarController = CleanCalendarController(
        minDate: DateTime.now(),
        maxDate: DateTime.now().add(Duration(days: 365)));
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: whiteColor,
        centerTitle: false,
        title: Text(
          'Calendar',
          
        ),
      ),
      body: Obx(() {
        return state.isLoading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : Column(
                children: [
                  Container(
                    padding: kStandardPadding(),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: successColor,
                              radius: 10,
                            ),
                            minWidthSpan(),
                            Text(
                              'Completed',
                            )
                          ],
                        ),
                        largeWidthSpan(),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: errorColor,
                              radius: 10,
                            ),
                            minWidthSpan(),
                            Text(
                              'Incomplete',
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  kSizedBox(),
                  Expanded(
                    // child: SfCalendar(
                    //     view: CalendarView.month,
                    //     // monthCellBuilder: (BuildContext buildContext,
                    //     //     MonthCellDetails details) {
                    //     //   // final Color backgroundColor =
                    //     //   //     _getMonthCellBackgroundColor(details.date);
                    //     //   final Color defaultColor =
                    //     //       Theme.of(context).brightness == Brightness.dark
                    //     //           ? Colors.black54
                    //     //           : Colors.white;
                    //     //   return Container(
                    //     //     decoration: BoxDecoration(
                    //     //         color: Colors.grey,
                    //     //         border: Border.all(
                    //     //             color: defaultColor, width: 0.5)),
                    //     //     child: Center(
                    //     //       child: Text(
                    //     //         details.date.day.toString(),
                    //     //         // style: TextStyle(color: _getCellTextColor(backgroundColor)),
                    //     //       ),
                    //     //     ),
                    //     //   );
                    //     // },
                    //     dataSource: ,
                    //     showDatePickerButton: true,
                    //     monthViewSettings: MonthViewSettings(
                    //       showTrailingAndLeadingDates: false,
                    //     )),
                    child: TableCalendar(
                      focusedDay: DateTime.now(),
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().addDays(365),
                      onDaySelected: (selectedDay, focusedDay) {
                        print(selectedDay);
                        Get.to(ChangeNotifierProvider(
                            create: (_) =>
                                SingleDayTaskState(context, selectedDay),
                            child: SingleDayTask()));
                      },
                      eventLoader: state.listOfEvents,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      daysOfWeekHeight: 40,
                      daysOfWeekStyle: DaysOfWeekStyle(
                          weekendStyle: TextStyle(
                              color: const Color.fromARGB(255, 228, 26, 11)),
                          weekdayStyle: TextStyle(
                              color: Get.isDarkMode
                                  ? whiteColor
                                  : Colors.black)),
                      headerStyle: const HeaderStyle(
                        titleTextStyle:
                            TextStyle(color: Colors.white, fontSize: 20.0),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(247, 147, 10, 10),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        formatButtonTextStyle:
                            TextStyle(color: Colors.red, fontSize: 16.0),
                        formatButtonDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                        ),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                          size: 28,
                        ),
                        rightChevronIcon: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      calendarStyle: const CalendarStyle(
                        // Weekend dates color (Sat & Sun Column)
                        weekendTextStyle:
                            TextStyle(color: Color.fromARGB(255, 231, 25, 10)),

                        // highlighted color for today
                        todayDecoration: BoxDecoration(
                          color: Color.fromARGB(255, 126, 11, 175),
                          shape: BoxShape.circle,
                        ),
                        // highlighted color for selected day
                        selectedDecoration: BoxDecoration(
                          color: Color.fromARGB(255, 131, 52, 23),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              );
      }),
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   Get.bottomSheet(Obx(() => Container(
      //         decoration: BoxDecoration(
      //             color: whiteColor,
      //             borderRadius: BorderRadius.only(
      //                 topLeft: Radius.circular(20),
      //                 topRight: Radius.circular(20))),
      //         padding: EdgeInsets.all(20.0),
      //         child: SingleChildScrollView(
      //           child: Column(
      //             mainAxisSize: MainAxisSize.max,
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Container(
      //                 child: Text(
      //                   'Task Name',
      //                   style: TextStyle(
      //                       color: Colors.black,
      //                       fontWeight: FontWeight.w600,
      //                       fontSize: 14.0),
      //                 ),
      //               ),
      //               Container(
      //                 child: TextField(
      //                   controller: state.titleController.value,
      //                   onChanged: (value) {
      //                     //   setState(() {
      //                     //     task_name = value.toString();
      //                     //   });
      //                   },
      //                   decoration: InputDecoration(
      //                     hintText: 'Name',
      //                   ),
      //                 ),
      //               ),
      //               Container(
      //                 margin: EdgeInsets.only(
      //                     top: 20.0, left: 5.0, bottom: 20.0, right: 5.0),
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.start,
      //                   children: [
      //                     InkWell(
      //                       onTap: () {
      //                         // Navigator.of(context).pop();

      //                         showDialog(
      //                           context: context,
      //                           builder: (BuildContext context) {
      //                             return StatefulBuilder(
      //                               builder: (BuildContext context,
      //                                   StateSetter setState) {
      //                                 return AlertDialog(
      //                                   content: Column(
      //                                     mainAxisSize: MainAxisSize.min,
      //                                     crossAxisAlignment:
      //                                         CrossAxisAlignment.start,
      //                                     children: [
      //                                       Text(
      //                                         'Please select project.',
      //                                         style: TextStyle(
      //                                             color: Colors.black,
      //                                             fontWeight: FontWeight.w700),
      //                                       ),
      //                                       Container(
      //                                         height:
      //                                             300.0, // Change as per your requirement
      //                                         width:
      //                                             300.0, // Change as per your requirement
      //                                         child: Scrollbar(
      //                                           thumbVisibility: true,
      //                                           child: ListView.builder(
      //                                             shrinkWrap: true,
      //                                             itemCount: state
      //                                                 .projectResponse!
      //                                                 .data!
      //                                                 .length,
      //                                             itemBuilder:
      //                                                 (BuildContext context,
      //                                                     int index) {
      //                                               return InkWell(
      //                                                 onTap: () {
      //                                                   state.onProjectChanged(
      //                                                       index,
      //                                                       state
      //                                                           .projectResponse!
      //                                                           .data![index]
      //                                                           .id!);
      //                                                   Get.back();
      //                                                   // refreshUpdateTaskModal();
      //                                                 },
      //                                                 child: Container(
      //                                                   color:
      //                                                       state.selectedProject ==
      //                                                               index
      //                                                           ? ColorsTheme
      //                                                               .btnColor
      //                                                           : null,
      //                                                   child: ListTile(
      //                                                     title: Text(
      //                                                       state
      //                                                               .projectResponse!
      //                                                               .data![
      //                                                                   index]
      //                                                               .title ??
      //                                                           '',
      //                                                       style: TextStyle(
      //                                                           color: state.selectedProject ==
      //                                                                   index
      //                                                               ? Colors
      //                                                                   .white
      //                                                               : Colors
      //                                                                   .black),
      //                                                     ),
      //                                                   ),
      //                                                 ),
      //                                               );
      //                                             },
      //                                           ),
      //                                         ),
      //                                       )
      //                                     ],
      //                                   ),
      //                                   actions: <Widget>[
      //                                     // usually buttons at the bottom of the dialog
      //                                     new TextButton(
      //                                       child: new Text("Close"),
      //                                       onPressed: () {
      //                                         Navigator.of(context).pop();
      //                                       },
      //                                     ),
      //                                   ],
      //                                 );
      //                               },
      //                             );
      //                           },
      //                         );
      //                       },
      //                       child: Container(
      //                         padding: EdgeInsets.only(right: 20.0),
      //                         child: Image(
      //                           image:
      //                               AssetImage('assets/plus_add_project.png'),
      //                         ),
      //                       ),
      //                     ),
      //                     // selectedIndex != null
      //                     //     ? AutoSizeText('Project Selected')
      //                     //     :
      //                     // AutoSizeText('Add Project')
      //                     Expanded(
      //                       child: AutoSizeText(
      //                         state
      //                                 .projectResponse!
      //                                 .data![state.selectedProject.value]
      //                                 .title ??
      //                             'Select Project',
      //                         overflow: TextOverflow.ellipsis,
      //                         maxLines: 1,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   InkWell(
      //                     onTap: () {
      //                       showDialog(
      //                         context: context,
      //                         builder: (BuildContext context) {
      //                           return StatefulBuilder(
      //                             builder: (BuildContext context,
      //                                 StateSetter setState) {
      //                               return AlertDialog(
      //                                 content: Column(
      //                                   mainAxisSize: MainAxisSize.min,
      //                                   crossAxisAlignment:
      //                                       CrossAxisAlignment.start,
      //                                   children: [
      //                                     Text(
      //                                       'Please select a user.',
      //                                       style: TextStyle(
      //                                           color: Colors.black,
      //                                           fontWeight: FontWeight.w700),
      //                                     ),
      //                                     Container(
      //                                       height:
      //                                           300.0, // Change as per your requirement
      //                                       width:
      //                                           300.0, // Change as per your requirement
      //                                       child: Scrollbar(
      //                                         thumbVisibility: true,
      //                                         child: ListView.builder(
      //                                           shrinkWrap: true,
      //                                           itemCount: state
      //                                               .userResponse!.data!.length,
      //                                           itemBuilder:
      //                                               (BuildContext context,
      //                                                   int index) {
      //                                             return InkWell(
      //                                               onTap: () {
      //                                                 state.onUserChanged(
      //                                                     index,
      //                                                     state
      //                                                         .userResponse!
      //                                                         .data![index]
      //                                                         .id!);
      //                                                 Get.back();
      //                                                 // refreshUpdateTaskModal();
      //                                               },
      //                                               child: Container(
      //                                                 color:
      //                                                     state.selectedUser ==
      //                                                             index
      //                                                         ? ColorsTheme
      //                                                             .btnColor
      //                                                         : null,
      //                                                 child: ListTile(
      //                                                   title: Text(
      //                                                     state
      //                                                             .userResponse!
      //                                                             .data![index]
      //                                                             .username ??
      //                                                         '',
      //                                                     style: TextStyle(
      //                                                         color:
      //                                                             state.selectedUser ==
      //                                                                     index
      //                                                                 ? Colors
      //                                                                     .white
      //                                                                 : Colors
      //                                                                     .black),
      //                                                   ),
      //                                                 ),
      //                                               ),
      //                                             );
      //                                           },
      //                                         ),
      //                                       ),
      //                                     )
      //                                   ],
      //                                 ),
      //                                 actions: <Widget>[
      //                                   // usually buttons at the bottom of the dialog
      //                                   new TextButton(
      //                                     child: new Text("Close"),
      //                                     onPressed: () {
      //                                       Navigator.of(context).pop();
      //                                     },
      //                                   ),
      //                                 ],
      //                               );
      //                             },
      //                           );
      //                         },
      //                       );
      //                     },
      //                     child: Container(
      //                       padding: EdgeInsets.only(right: 20.0),
      //                       child: Image(
      //                         image: AssetImage('assets/unassigned_icon.png'),
      //                       ),
      //                     ),
      //                   ),
      //                   Expanded(
      //                     child: AutoSizeText(
      //                       state.userResponse!.data![state.selectedUser.value]
      //                               .username ??
      //                           'Select User',
      //                       overflow: TextOverflow.ellipsis,
      //                       maxLines: 1,
      //                     ),
      //                   ),
      //                   GestureDetector(
      //                     onTap: () async {
      //                       DateTimeRangePicker(
      //                           startText: "From",
      //                           endText: "To",
      //                           doneText: "Yes",
      //                           cancelText: "Cancel",
      //                           interval: 5,
      //                           initialStartTime: DateTime.now(),
      //                           initialEndTime:
      //                               DateTime.now().add(Duration(days: 20)),
      //                           mode: DateTimeRangePickerMode.dateAndTime,
      //                           minimumTime:
      //                               DateTime.now().subtract(Duration(days: 5)),
      //                           maximumTime:
      //                               DateTime.now().add(Duration(days: 365)),
      //                           use24hFormat: false,
      //                           onConfirm: (start, end) {
      //                             state.onStartAndEndDateTimeChanged(
      //                                 start, end);
      //                           }).showPicker(context);
      //                     },
      //                     child: Container(
      //                       margin: EdgeInsets.only(
      //                           top: 20.0, left: 5.0, bottom: 20.0, right: 5.0),
      //                       child: Row(
      //                         mainAxisAlignment: MainAxisAlignment.start,
      //                         children: [
      //                           Container(
      //                             padding: EdgeInsets.only(right: 20.0),
      //                             child: Image(
      //                               image:
      //                                   AssetImage('assets/due_date_icon.png'),
      //                             ),
      //                           ),
      //                           AutoSizeText(state.startDate.value == null ||
      //                                   state.endDate.value == null
      //                               ? 'Due Date'
      //                               : DateFormat('MM/dd')
      //                                   .format(state.endDate.value!)),
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //               Container(
      //                 child: Text(
      //                   'Description',
      //                   style: TextStyle(
      //                       color: Colors.black,
      //                       fontWeight: FontWeight.w600,
      //                       fontSize: 14.0),
      //                 ),
      //               ),
      //               Container(
      //                 child: TextField(
      //                   controller: state.descriptionController.value,
      //                   onChanged: (value) {
      //                     // setState(() {
      //                     //   task_desc = value.toString();
      //                     // });
      //                   },
      //                   decoration: InputDecoration(
      //                     hintText: 'Type here',
      //                   ),
      //                 ),
      //               ),
      //               Container(
      //                 child: Text(
      //                   'Percent Done',
      //                   style: TextStyle(
      //                       color: Colors.black,
      //                       fontWeight: FontWeight.w600,
      //                       fontSize: 14.0),
      //                 ),
      //               ),
      //               Container(
      //                 child: SfSlider(
      //                   min: 0.0,
      //                   max: 100.0,
      //                   value: state.percent.value,
      //                   activeColor: ColorsTheme.btnColor,
      //                   interval: 20,
      //                   showTicks: true,
      //                   showLabels: true,
      //                   enableTooltip: true,
      //                   minorTicksPerInterval: 1,
      //                   onChanged: (dynamic value) {
      //                     state.onPercentChanged(value);
      //                     print(value);
      //                   },
      //                 ),
      //               ),
      //               Container(
      //                 margin: EdgeInsets.only(top: 10.0),
      //                 child: Text(
      //                   'Priority',
      //                   style: TextStyle(
      //                       color: Colors.black,
      //                       fontWeight: FontWeight.w600,
      //                       fontSize: 14.0),
      //                 ),
      //               ),
      //               Row(
      //                 children: [
      //                   TaskUrgencyTile(
      //                     state: state,
      //                     status: 'Low',
      //                   ),
      //                   maxWidthSpan(),
      //                   TaskUrgencyTile(
      //                     state: state,
      //                     status: 'High',
      //                   ),
      //                   maxWidthSpan(),
      //                   TaskUrgencyTile(
      //                     state: state,
      //                     status: 'Urgent',
      //                   ),
      //                   maxWidthSpan(),
      //                 ],
      //               ),
      //               Container(
      //                 margin: EdgeInsets.only(top: 10.0),
      //                 child: Text(
      //                   'Status',
      //                   style: TextStyle(
      //                       color: Colors.black,
      //                       fontWeight: FontWeight.w600,
      //                       fontSize: 14.0),
      //                 ),
      //               ),
      //               Container(
      //                 margin: EdgeInsets.only(top: 10.0),
      //                 child: Row(
      //                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   // crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Expanded(
      //                       flex: 1,
      //                       child: Column(
      //                         children: [
      //                           TaskStatusTile(state: state, status: 'Todo'),
      //                           kSizedBox(),
      //                           TaskStatusTile(
      //                               state: state, status: 'Completed'),
      //                         ],
      //                       ),
      //                     ),
      //                     maxWidthSpan(),
      //                     Expanded(
      //                       flex: 2,
      //                       child: Column(
      //                         children: [
      //                           TaskStatusTile(
      //                               state: state, status: 'Incomplete'),
      //                           kSizedBox(),
      //                           TaskStatusTile(
      //                               state: state, status: 'Inprogress'),
      //                         ],
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //               kSizedBox(),
      //               Container(
      //                 margin: EdgeInsets.only(top: 40.0),
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.end,
      //                   children: [
      //                     Container(
      //                       width: Get.width * 0.3,
      //                       height: 38.0,
      //                       child: TextButton(
      //                           style: ButtonStyle(
      //                             shape: MaterialStateProperty.all(
      //                                 RoundedRectangleBorder(
      //                               side: BorderSide(
      //                                   color: ColorsTheme.txtDescColor),
      //                               borderRadius: BorderRadius.circular(14.0),
      //                             )),
      //                             foregroundColor:
      //                                 MaterialStateProperty.resolveWith<Color>(
      //                                     (Set<MaterialState> states) {
      //                               if (states
      //                                       .contains(MaterialState.hovered) ||
      //                                   states.contains(MaterialState.focused))
      //                                 return Colors.white;
      //                               return Colors.white;
      //                             }),
      //                             backgroundColor:
      //                                 MaterialStateProperty.resolveWith<Color>(
      //                                     (Set<MaterialState> states) {
      //                               if (states
      //                                       .contains(MaterialState.hovered) ||
      //                                   states.contains(MaterialState.focused))
      //                                 return ColorsTheme.btnColor;

      //                               return ColorsTheme.btnColor;
      //                             }),
      //                           ),
      //                           child: Text('Create'),
      //                           onPressed: () async {
      //                             state.createTask();
      //                             // bool result = false;

      //                             // if (task_name.isNotEmpty &&
      //                             //     task_desc.isNotEmpty &&
      //                             //     formatted_start_date.isNotEmpty &&
      //                             //     formatted_end_date.isNotEmpty &&
      //                             //     project_id != 0) {
      //                             // result = await saveTask();
      //                             // if (result == true) {
      //                             //   setState(() {
      //                             //     task_name = '';
      //                             //     task_desc = '';
      //                             //     formatted_end_date = '';
      //                             //     formatted_end_date = '';
      //                             //   });
      //                             // Navigator.of(context).pop();
      //                             // getUserTasks();
      //                             // txt_addTaskNameController.clear();
      //                             // txt_addTaskDescController.clear();
      //                             // ToastService().s('Task added successfully!');

      //                             // getAppointments();

      //                             // Navigator.of(context, rootNavigator: false)
      //                             //     .push(MaterialPageRoute(
      //                             //         builder: (context) => const TaskTabPage(),
      //                             //         fullscreenDialog: true));

      //                             // sendNotification(project_id, 'Task assigned');
      //                             //     } else
      //                             //                                       ToastService().e('Something went wrong');

      //                             //   } else
      //                             //     ToastService().e('Some fields is missing');
      //                           }),
      //                     ),
      //                   ],
      //                 ),
      //               )
      //             ],
      //           ),
      //         ),
      //       )));
      // }),

      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        // backgroundColor: 
        // state.isDark.value ? 
        // buttonColor : ColorsTheme.btnColor,
        child: Icon(Icons.add,size: 30,),
        distance: 75,
        children: [
          FloatingActionButton.extended(
            // backgroundColor: state.isDark.value ? buttonColor : ColorsTheme.btnColor,
            label: Text(
              'TimeBox',            
            ),
            icon: Icon(Icons.timer,
                ),
            // child: const Icon(Icons.edit),
            onPressed: () {
              Get.toNamed(RouteName.timeBoxScreen);
            },
          ),
          FloatingActionButton.extended(
            // backgroundColor: state.isDark.value ? buttonColor : ColorsTheme.btnColor,

            label: Text('Tasks',
               ),
            icon: Icon(Icons.task,
                ),
            // child: const Icon(Icons.search),
            onPressed: () {
              Get.bottomSheet(Obx(() => Container(
                    height: Get.height * 0.85,
                    decoration: BoxDecoration(
                        color: Get.isDarkMode ? customDarkTheme.scaffoldBackgroundColor : customLightTheme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    padding: EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
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
                              controller: state.titleController.value,
                              onChanged: (value) {
                                //   setState(() {
                                //     task_name = value.toString();
                                //   });
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
                                    // Navigator.of(context).pop();

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
                                                    'Please select project.',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Container(
                                                    height:
                                                        300.0, // Change as per your requirement
                                                    width:
                                                        300.0, // Change as per your requirement
                                                    child: Scrollbar(
                                                      thumbVisibility: true,
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: state
                                                            .projectResponse!
                                                            .data!
                                                            .length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return InkWell(
                                                            onTap: () {
                                                              state.onProjectChanged(
                                                                  index,
                                                                  state
                                                                      .projectResponse!
                                                                      .data![
                                                                          index]
                                                                      .id!);
                                                              Get.back();
                                                              // refreshUpdateTaskModal();
                                                            },
                                                            child: Container(
                                                              color: state.selectedProject ==
                                                                      index
                                                                  ? ColorsTheme
                                                                      .btnColor
                                                                  : null,
                                                              child: ListTile(
                                                                title: Text(
                                                                  state
                                                                          .projectResponse!
                                                                          .data![
                                                                              index]
                                                                          .title ??
                                                                      '',
                                                                  style: TextStyle(
                                                                      color: state.selectedProject ==
                                                                              index
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  )
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
                                          'assets/plus_add_project.png'),
                                    ),
                                  ),
                                ),
                                // selectedIndex != null
                                //     ? AutoSizeText('Project Selected')
                                //     :
                                // AutoSizeText('Add Project')
                                Expanded(
                                  child: AutoSizeText(
                                    state
                                            .projectResponse!
                                            .data![state.selectedProject.value]
                                            .title ??
                                        'Select Project',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                Container(
                                                  height:
                                                      300.0, // Change as per your requirement
                                                  width:
                                                      300.0, // Change as per your requirement
                                                  child: Scrollbar(
                                                    thumbVisibility: true,
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: state
                                                          .userResponse!
                                                          .data!
                                                          .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return InkWell(
                                                          onTap: () {
                                                            state.onUserChanged(
                                                                index,
                                                                state
                                                                    .userResponse!
                                                                    .data![
                                                                        index]
                                                                    .id!);
                                                            Get.back();
                                                            // refreshUpdateTaskModal();
                                                          },
                                                          child: Container(
                                                            color:
                                                                state.selectedUser ==
                                                                        index
                                                                    ? ColorsTheme
                                                                        .btnColor
                                                                    : null,
                                                            child: ListTile(
                                                              title: Text(
                                                                state
                                                                        .userResponse!
                                                                        .data![
                                                                            index]
                                                                        .username ??
                                                                    '',
                                                                style: TextStyle(
                                                                    color: state.selectedUser ==
                                                                            index
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                )
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
                              Expanded(
                                child: AutoSizeText(
                                  state
                                          .userResponse!
                                          .data![state.selectedUser.value]
                                          .username ??
                                      'Select User',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
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
                                      initialEndTime: DateTime.now()
                                          .add(Duration(days: 20)),
                                      mode: DateTimeRangePickerMode.dateAndTime,
                                      minimumTime: DateTime.now()
                                          .subtract(Duration(days: 5)),
                                      maximumTime: DateTime.now()
                                          .add(Duration(days: 365)),
                                      use24hFormat: false,
                                      onConfirm: (start, end) {
                                        state.onStartAndEndDateTimeChanged(
                                            start, end);
                                      }).showPicker(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: 20.0,
                                      left: 5.0,
                                      bottom: 20.0,
                                      right: 5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(right: 20.0),
                                        child: Image(
                                          image: AssetImage(
                                              'assets/due_date_icon.png'),
                                        ),
                                      ),
                                      AutoSizeText(state.startDate.value ==
                                                  null ||
                                              state.endDate.value == null
                                          ? 'Due Date'
                                          : DateFormat('MM/dd')
                                              .format(state.endDate.value!)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          LSizedBox(),
                          Container(
                            child: Text(
                              'Description',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0),
                            ),
                          ),
                          kSizedBox(),
                          TextField(
                            controller: state.descriptionController.value,
                            onChanged: (value) {
                              // setState(() {
                              //   task_desc = value.toString();
                              // });
                            },
                            decoration: InputDecoration(
                              hintText: 'Type here',
                            ),
                          ),
                          LSizedBox(),
                          Text(
                            'Percent Done',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0),
                          ),
                          kSizedBox(),
                          Container(
                            child: SfSlider(
                              min: 0.0,
                              max: 100.0,
                              value: state.percent.value,
                              activeColor: ColorsTheme.btnColor,
                              interval: 20,
                              showTicks: true,
                              showLabels: true,
                              enableTooltip: true,
                              minorTicksPerInterval: 1,
                              onChanged: (dynamic value) {
                                state.onPercentChanged(value);
                                print(value);
                              },
                            ),
                          ),
                          LSizedBox(),
                          Text(
                            'Priority',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0),
                          ),
                          kSizedBox(),
                          Row(
                            children: [
                              TaskUrgencyTile(
                                state: state,
                                status: 'Low',
                              ),
                              maxWidthSpan(),
                              TaskUrgencyTile(
                                state: state,
                                status: 'High',
                              ),
                              maxWidthSpan(),
                              TaskUrgencyTile(
                                state: state,
                                status: 'Urgent',
                              ),
                              maxWidthSpan(),
                            ],
                          ),
                          LSizedBox(),
                          Text(
                            'Status',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0),
                          ),
                          kSizedBox(),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    TaskStatusTile(
                                        state: state, status: 'Todo'),
                                    kSizedBox(),
                                    TaskStatusTile(
                                        state: state, status: 'Completed'),
                                  ],
                                ),
                              ),
                              maxWidthSpan(),
                              Expanded(
                                child: Column(
                                  children: [
                                    TaskStatusTile(
                                        state: state, status: 'Incomplete'),
                                    kSizedBox(),
                                    TaskStatusTile(
                                        state: state, status: 'Inprogress'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          kSizedBox(),
                          Container(
                            margin: EdgeInsets.only(top: 40.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: Get.width * 0.3,
                                  height: 38.0,
                                  child: TextButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: ColorsTheme.txtDescColor),
                                          borderRadius:
                                              BorderRadius.circular(14.0),
                                        )),
                                        foregroundColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                          if (states.contains(
                                                  MaterialState.hovered) ||
                                              states.contains(
                                                  MaterialState.focused))
                                            return Colors.white;
                                          return Colors.white;
                                        }),
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                          if (states.contains(
                                                  MaterialState.hovered) ||
                                              states.contains(
                                                  MaterialState.focused))
                                            return ColorsTheme.btnColor;

                                          return ColorsTheme.btnColor;
                                        }),
                                      ),
                                      child: Text('Create'),
                                      onPressed: () async {
                                        state.createTask();
                                        // bool result = false;

                                        // if (task_name.isNotEmpty &&
                                        //     task_desc.isNotEmpty &&
                                        //     formatted_start_date.isNotEmpty &&
                                        //     formatted_end_date.isNotEmpty &&
                                        //     project_id != 0) {
                                        // result = await saveTask();
                                        // if (result == true) {
                                        //   setState(() {
                                        //     task_name = '';
                                        //     task_desc = '';
                                        //     formatted_end_date = '';
                                        //     formatted_end_date = '';
                                        //   });
                                        // Navigator.of(context).pop();
                                        // getUserTasks();
                                        // txt_addTaskNameController.clear();
                                        // txt_addTaskDescController.clear();
                                        // ToastService().s('Task added successfully!');

                                        // getAppointments();

                                        // Navigator.of(context, rootNavigator: false)
                                        //     .push(MaterialPageRoute(
                                        //         builder: (context) => const TaskTabPage(),
                                        //         fullscreenDialog: true));

                                        // sendNotification(project_id, 'Task assigned');
                                        //     } else
                                        //                                       ToastService().e('Something went wrong');

                                        //   } else
                                        //     ToastService().e('Some fields is missing');
                                      }),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )));
            },
          ),
        ],
      ),
    );
  }
}

class TaskStatusTile extends StatelessWidget {
  TaskStatusTile({
    super.key,
    required this.state,
    this.status,
  });
  String? status;

  final TaskViewModel state;

  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
          onTap: () {
            state.onTaskStatusChanged(status!);
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Center(
              child: Text(
                status!,
                style: TextStyle(
                    color: state.taskStatus == status
                        ? Colors.white
                        : Colors.grey[800]),
              ),
            ),
            decoration: BoxDecoration(
              color: state.taskStatus == status && state.taskStatus == 'Todo'
                  ? Colors.purple.withOpacity(0.7)
                  : state.taskStatus == status &&
                          state.taskStatus == 'Incomplete'
                      ? Colors.red.withOpacity(0.7)
                      : state.taskStatus == status &&
                              state.taskStatus == 'Completed'
                          ? Colors.green.withOpacity(0.7)
                          : state.taskStatus == status &&
                                  state.taskStatus == 'Inprogress'
                              ? Colors.orange.withOpacity(0.7)
                              : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ));
  }
}

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

class TaskUrgencyTile extends StatelessWidget {
  TaskUrgencyTile({super.key, required this.state, this.status});
  String? status;

  final TaskViewModel state;

  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
          onTap: () {
            state.onTaskUrgencyChanged(status);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            decoration: BoxDecoration(
              color: state.taskUrgency == status && state.taskUrgency == 'Low'
                  ? Colors.green.withOpacity(0.7)
                  : state.taskUrgency == status && state.taskUrgency == 'High'
                      ? Colors.orange
                      : state.taskUrgency == status &&
                              state.taskUrgency == 'Urgent'
                          ? Colors.red
                          : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(status!,
                style: kkTextStyle().copyWith(
                    color: state.taskUrgency == status
                        ? Colors.white
                        : Colors.grey[800])),
          ),
        ));
  }
}
