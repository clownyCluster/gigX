import 'package:auto_size_text/auto_size_text.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:gigX/appRoute/routeName.dart';
import 'package:gigX/main.dart';
import 'package:gigX/view_model/project_details_view_model.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../colors.dart';
import '../constant/constants.dart';

class ProjectDetailsView extends StatelessWidget {
  const ProjectDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Get.put(ProjectDetailsViewModel());
    return Scaffold(
      // backgroundColor: whiteColor,
      appBar: AppBar(
        // iconTheme: IconThemeData(color: Colors.grey),
        // backgroundColor: state.isDark.value ? greyColor : whiteColor,
        centerTitle: false,
        elevation: 0,
        title: Container(
          // padding: EdgeInsets.all(15.0),
          // margin: EdgeInsets.only(top: 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text( 'project_title',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w600)),
                    
                  
                ],
              ),
              GestureDetector(
                onTap: () {
                  // showMemberDialog(context);
                },
                child: Container(
                  child: Image(image: AssetImage('assets/add_member_icon.png')),
                ),
              )
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      
      body: Obx(() {
        return state.isLoading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : state.taskResponse!.data!.isEmpty ||
                    state.taskResponse!.data == []
                ? Center(
                    child: Text('No task!'),
                  )
                : Container(
                    padding: kStandardPadding(),
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              ProjectStatusTile(
                                  state: state, status: 'InCompleted Tasks'),
                              maxWidthSpan(),
                              ProjectStatusTile(
                                  state: state, status: 'Completed Tasks'),
                              maxWidthSpan(),
                              ProjectStatusTile(
                                  state: state, status: 'Inprogress'),
                            ],
                          ),
                        ),
                        kSizedBox(),
                        Expanded(
                            child: ListView.builder(
                                itemCount: state.taskResponse!.data!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.all(10),
                                    width: Get.width,
                                    child: GestureDetector(
                                      onTap: () async {
                                        Get.toNamed(RouteName.projectEditScreen,
                                            arguments: state
                                                .taskResponse!.data![index]);
                                      },
                                      child: Container(
                                        // height: 180.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            border: Border.all(
                                                color: Color.fromARGB(
                                                    255, 208, 203, 203),
                                                width: 1.0)),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                // padding: EdgeInsets.all(20.0),
                                                padding: kStandardPadding(),
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: state.taskResponse!.data![index].priority ==
                                                                        0
                                                                    ? Color(0xff00DB99)
                                                                        .withOpacity(
                                                                            0.1)
                                                                    : state.taskResponse!.data![index].priority ==
                                                                            1
                                                                        ? Colors
                                                                            .orange
                                                                            .withOpacity(
                                                                                0.1)
                                                                        : Colors
                                                                            .red
                                                                            .withOpacity(0.1)),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5,
                                                                horizontal: 10),
                                                        child: Text(
                                                          state
                                                              .taskResponse!
                                                              .data![index]
                                                              .title!,
                                                          style: kTextStyle()
                                                              .copyWith(
                                                                  color: state
                                                                              .taskResponse!
                                                                              .data![
                                                                                  index]
                                                                              .priority ==
                                                                          0
                                                                      ? Color(
                                                                          0xff00DB99)
                                                                      : state.taskResponse!.data![index].priority ==
                                                                              1
                                                                          ? Colors
                                                                              .orange
                                                                          : Colors
                                                                              .red),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10.0,
                                                      ),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: state.taskResponse!.data![index].priority ==
                                                                        0
                                                                    ? Color(0xff00DB99)
                                                                        .withOpacity(
                                                                            0.1)
                                                                    : state.taskResponse!.data![index].priority ==
                                                                            1
                                                                        ? Colors
                                                                            .orange
                                                                            .withOpacity(
                                                                                0.1)
                                                                        : Colors
                                                                            .red
                                                                            .withOpacity(0.1)),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5,
                                                                horizontal: 10),
                                                        child: Text(
                                                          state
                                                                      .taskResponse!
                                                                      .data![
                                                                          index]
                                                                      .priority ==
                                                                  0
                                                              ? 'Low'
                                                              : state
                                                                          .taskResponse!
                                                                          .data![
                                                                              index]
                                                                          .priority ==
                                                                      1
                                                                  ? 'High'
                                                                  : 'Urgent',
                                                          style: kTextStyle()
                                                              .copyWith(
                                                                  color: state
                                                                              .taskResponse!
                                                                              .data![
                                                                                  index]
                                                                              .priority ==
                                                                          0
                                                                      ? Color(
                                                                          0xff00DB99)
                                                                      : state.taskResponse!.data![index].priority ==
                                                                              1
                                                                          ? Colors
                                                                              .orange
                                                                          : Colors
                                                                              .red),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.only(
                                                    bottom: 20.0),
                                                margin: EdgeInsets.only(
                                                    left: 20, right: 20),
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                  
                                                ))),
                                                child: AutoSizeText(
                                                  state.taskResponse!
                                                      .data![index].description
                                                      .toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15.0),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.all(20.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Image.asset(
                                                            'assets/due_date_icon.png'),
                                                        SizedBox(
                                                          width: 10.0,
                                                        ),
                                                        Text(state
                                                            .taskResponse!
                                                            .data![index]
                                                            .endDate
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
                                }))
                      ],
                    ),
                  );
      }),
      // floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        // backgroundColor:
        //     state.isDark.value ? buttonColor : ColorsTheme.btnColor,
        distance: 75,
        children: [
          FloatingActionButton.extended(
            // backgroundColor:
            //     state.isDark.value ? buttonColor : ColorsTheme.btnColor,
            // heroTag: null,
            label: Text('TimeBox'),
            icon: Icon(Icons.timer),
            // child: const Icon(Icons.edit),
            onPressed: () {},
          ),
          FloatingActionButton.extended(
            // backgroundColor: state.isDark.value ? buttonColor : ColorsTheme.btnColor,

            // heroTag: null,
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
                                  child: 
                                  state.showProject.value ? 
                                  AutoSizeText(
                                    state
                                            .projectResponse!
                                            .data![state.selectedProject.value]
                                            .title!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ) : Text('Select Project'),
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
                                child: 
                                state.showUser.value ?
                                AutoSizeText(
                                  state
                                          .userResponse!
                                          .data![state.selectedUser.value]
                                          .username!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ) : Text('Select User'),
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

  final ProjectDetailsViewModel state;

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

class TaskUrgencyTile extends StatelessWidget {
  TaskUrgencyTile({super.key, required this.state, this.status});
  String? status;

  final ProjectDetailsViewModel state;

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

class ProjectStatusTile extends StatelessWidget {
  ProjectStatusTile({super.key, required this.state, this.status});
  String? status;

  final ProjectDetailsViewModel state;

  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
          onTap: () {
            state.onProjectStatusChanged(status);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            decoration: BoxDecoration(
              border: Border.all(
                color: state.projectStatus == status &&
                        state.projectStatus == 'InCompleted Tasks'
                    ? Colors.red
                    : state.projectStatus == status &&
                            state.projectStatus == 'Completed Tasks'
                        ? Colors.green
                        : state.projectStatus == status &&
                                state.projectStatus == 'Inprogress'
                            ? Colors.orange
                            : Colors.grey,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(status!,
                style: kkTextStyle().copyWith(
                    color: state.projectStatus == status &&
                            state.projectStatus == 'InCompleted Tasks'
                        ? Colors.red
                        : state.projectStatus == status &&
                                state.projectStatus == 'Completed Tasks'
                            ? Colors.green
                            : state.projectStatus == status &&
                                    state.projectStatus == 'Inprogress'
                                ? Colors.orange
                                : Colors.grey)),
          ),
        ));
  }
}

enum priority { Low, High, Urgent }
