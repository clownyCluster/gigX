import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:gigX/api.dart';
import 'package:gigX/colors.dart';
import 'package:gigX/constant/constants.dart';
import 'package:gigX/login.dart';
import 'package:gigX/pages/account.dart';
import 'package:gigX/pages/timebox_module/time_box_state.dart';
import 'package:gigX/pages/webviewprivacypolicy.dart';
import 'package:gigX/pages/webviewtermsandconditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

// class TimeBox extends StatelessWidget {
//   const TimeBox({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'TimeBox Page',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//           primarySwatch: Colors.blue,
//           fontFamily: 'Poppins',
//           scaffoldBackgroundColor: Colors.white),
//       home: const TimeBoxPage(),
//     );
//   }
// }

// var height, width;
// Map<String, dynamic> user = new Map<String, dynamic>();
// String? access_token = "";
// String userEmail = "", userName = "", profileUrl = "";

// class TimeBoxPage extends StatefulWidget {
//   const TimeBoxPage({super.key});

//   @override
//   State<TimeBoxPage> createState() => _TimeBoxPageState();
// }

// class _TimeBoxPageState extends State<TimeBoxPage> {
//   SharedPreferences? preferences;
//   bool is_loading = false;
//   var orien;
//   bool keyboardVisible = false;
//   String timebox_date = "";
//   String top_priorities = "";
//   String brain_dump = "";
//   String? access_token = "";
//   bool isDateChanged = false;
//   List time_list = [];
//   List task_list = [];
//   Map<String, dynamic> timeboxDetails = Map<String, dynamic>();
//   TextEditingController txttopPriorController = new TextEditingController();
//   TextEditingController txtbrainDumpController = new TextEditingController();

//   TextEditingController txttaskController1 = new TextEditingController();
//   TextEditingController txttaskController2 = new TextEditingController();
//   TextEditingController txttaskController3 = new TextEditingController();
//   TextEditingController txttaskController4 = new TextEditingController();
//   TextEditingController txttaskController5 = new TextEditingController();
//   TextEditingController txttaskController6 = new TextEditingController();
//   TextEditingController txttaskController7 = new TextEditingController();
//   TextEditingController txttaskController8 = new TextEditingController();
//   TextEditingController txttaskController9 = new TextEditingController();
//   TextEditingController txttaskController10 = new TextEditingController();
//   TextEditingController txttaskController11 = new TextEditingController();
//   TextEditingController txttaskController12 = new TextEditingController();
//   TextEditingController txttaskController13 = new TextEditingController();
//   TextEditingController txttaskController14 = new TextEditingController();
//   TextEditingController txttaskController15 = new TextEditingController();
//   TextEditingController txttaskController16 = new TextEditingController();
//   TextEditingController txttaskController17 = new TextEditingController();
//   TextEditingController txttaskController18 = new TextEditingController();
//   TextEditingController txttaskController19 = new TextEditingController();
//   TextEditingController txttaskController20 = new TextEditingController();
//   TextEditingController txttaskController21 = new TextEditingController();

//   static const FloatingActionButtonLocation centerDocked =
//       _CenterDockedFloatingActionButtonLocation();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       setState(() {
//         timebox_date = DateTime.now().toString();
//       });
//       getTimeBoxDetails();
//       KeyboardVisibilityController().onChange.listen((isVisible) {
//         setState(() {
//           keyboardVisible = isVisible;
//         });
//       });
//     });
//   }

//   Future<void> saveTimeBox() async {
//     final _dio = new Dio();
//     this.preferences = await SharedPreferences.getInstance();
//     setState(() {
//       access_token = this.preferences?.getString('access_token');
//       is_loading = true;
//     });

//     Map<String, dynamic> timeboxMap = {
//       'timebox_date':
//           DateFormat('dd/MM/yyyy').format(DateTime.parse(timebox_date)),
//       'top_priorities': top_priorities,
//       'brain_dump': brain_dump,
//       'task_time[]': time_list.toSet().toList(),
//       'task_list[]': task_list.toSet().toList()
//     };

//     try {
//       final formData = FormData.fromMap(timeboxMap);
//       Response response = await _dio.post(API.base_url + 'todo-timebox',
//           data: formData,
//           options: Options(headers: {
//             "Content-type": "multipart/form-data",
//             "authorization": "Bearer " + access_token.toString()
//           }));

//       if (response.statusCode == 200) {
//         getTimeBoxDetails();
//         Fluttertoast.showToast(
//             msg: "Timebox added!",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.CENTER,
//             timeInSecForIosWeb: 1,
//             backgroundColor: ColorsTheme.btnColor,
//             textColor: Colors.white,
//             fontSize: 16.0);
//       } else
//         Fluttertoast.showToast(
//             msg: "Error Occured. Try again!",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.CENTER,
//             timeInSecForIosWeb: 1,
//             backgroundColor: ColorsTheme.dangerColor,
//             textColor: Colors.white,
//             fontSize: 16.0);
//     } on DioError catch (e) {
//       print(e.message);
//     }
//   }

//   Future<void> getTimeBoxDetails() async {
//     final _dio = Dio();
//     var taskList = [];

//     this.preferences = await SharedPreferences.getInstance();
//     setState(() {
//       access_token = this.preferences?.getString('access_token');
//     });
//     print(DateFormat('dd/MM/yyyy').format(DateTime.parse(timebox_date)));
//     try {
//       Response response = await _dio.get(
//           API.base_url +
//               'todo-timebox?timebox_date=${DateFormat('dd/MM/yyyy').format(DateTime.parse(timebox_date))}',
//           options: Options(headers: {"authorization": "Bearer $access_token"}));
//       Map result = response.data;

//       if (response.statusCode == 200) {
//         this.preferences?.setBool('someoneLoggedIn', false);

//         if (response.data['status'] == 'SUCCESS') {
//           setState(() {
//             timeboxDetails = response.data['data'];
//             print(timeboxDetails['top_priorities']);
//             txttopPriorController.text = timeboxDetails['top_priorities'];
//             txtbrainDumpController.text = timeboxDetails['brain_dump'];
//             taskList = jsonDecode(timeboxDetails['task_list']);

//             taskList.forEach((element) {
//               setTaskList(element['time'], element['task']);
//             });
//           });
//         } else {
//           print('Not found');
//           txttopPriorController.clear();
//           txtbrainDumpController.clear();
//         }
//       } else if (response.statusCode == 401) {
//         await this.preferences?.remove('access_token');
//         Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
//           MaterialPageRoute(
//             builder: (BuildContext context) {
//               return const Login();
//             },
//           ),
//           (_) => false,
//         );
//       }

//       return null;
//     } on DioError catch (e) {
//       if (e.response?.statusCode == 401) {
//         this.preferences?.setBool('someoneLoggedIn', true);
//         await this.preferences?.remove('access_token');
//         Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
//           MaterialPageRoute(
//             builder: (BuildContext context) {
//               return const Login();
//             },
//           ),
//           (_) => false,
//         );
//       }
//       return null;
//     }
//   }

//   void settimeboxdate(StateSetter state, DateTime value) {
//     setState(() {
//       // timebox_date = DateFormat('dd/MM/yyyy').format(value);
//       timebox_date = value.toString();
//     });
//   }

//   Future<dynamic> showDatePicker(BuildContext context) {
//     return showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         useRootNavigator: true,
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
//         builder: (context) {
//           return StatefulBuilder(builder:
//               (BuildContext context, void Function(void Function()) state) {
//             return Container(
//               margin: EdgeInsets.only(top: 10.0, left: 24.0),
//               width: width * 0.88,
//               height: 300,
//               child: CupertinoDatePicker(
//                 mode: CupertinoDatePickerMode.date,
//                 onDateTimeChanged: (value) {
//                   isDateChanged = true;
//                   print('So there');

//                   // String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(value);
//                   settimeboxdate(state, value);
//                   getTimeBoxDetails();
//                 },
//                 use24hFormat: false,
//               ),
//             );
//           });
//         });
//   }

//   void setTaskList(String time, String task) {
//     if (time == '09:00') txttaskController1.text = task;
//     if (time == '09:30') txttaskController2.text = task;
//     if (time == '10:00') txttaskController3.text = task;
//     if (time == '10:30') txttaskController4.text = task;
//     if (time == '11:00') txttaskController5.text = task;
//     if (time == '11:30') txttaskController6.text = task;
//     if (time == '12:00') txttaskController7.text = task;
//     if (time == '12:30') txttaskController8.text = task;
//     if (time == '01:00') txttaskController9.text = task;
//     if (time == '01:30') txttaskController10.text = task;
//     if (time == '02:00') txttaskController11.text = task;
//     if (time == '02:30') txttaskController12.text = task;
//     if (time == '03:00') txttaskController13.text = task;
//     if (time == '03:30') txttaskController14.text = task;
//     if (time == '04:00') txttaskController15.text = task;
//     if (time == '04:30') txttaskController16.text = task;
//     if (time == '05:00') txttaskController17.text = task;
//     if (time == '05:30') txttaskController18.text = task;
//     if (time == '06:00') txttaskController19.text = task;
//     if (time == '06:30') txttaskController20.text = task;
//     if (time == '07:00') txttaskController20.text = task;
//   }

//   @override
//   Widget build(BuildContext context) {
//     height = MediaQuery.of(context).size.height;
//     width = MediaQuery.of(context).size.width;
//     orien = MediaQuery.of(context).orientation;

//     return GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           body: OrientationBuilder(builder: (context, orientation) {
//             return SingleChildScrollView(
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Container(
//                     width: width,
//                     height: orientation == Orientation.portrait && height < 820
//                         ? height * 2.6
//                         : orientation == Orientation.portrait && height > 820
//                             ? height * 2.16
//                             : height * 6.4,
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   margin: EdgeInsets.only(top: 40.0),
//                                   child: IconButton(
//                                       onPressed: () async {
//                                         // Navigator.of(context).push(
//                                         //     MaterialPageRoute(
//                                         //         builder: (context) =>
//                                         //             AccountTab()));
//                                         Navigator.pop(context);
//                                       },
//                                       icon: Icon(
//                                         Icons.arrow_back,
//                                         color: Colors.black,
//                                       )),
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.all(10.0),
//                                   margin: EdgeInsets.only(top: 40.0),
//                                   child: AutoSizeText(
//                                     'Time Box',
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 20.0),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                               alignment: Alignment.center,
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   InkWell(
//                                       onTap: () {
//                                         setState(() {
//                                           DateTime currentDateTime =
//                                               DateTime.parse(timebox_date);
//                                           DateTime prevDateTime =
//                                               currentDateTime
//                                                   .subtract(Duration(days: 1));

//                                           // print(prevDateTime);
//                                           // DateTime now = DateTime.now()
//                                           //     .subtract(Duration(days: 1));
//                                           // print(now);

//                                           timebox_date =
//                                               DateFormat('yyyy-MM-dd')
//                                                   .format(prevDateTime);

//                                           getTimeBoxDetails();
//                                         });
//                                       },
//                                       child:
//                                           Image.asset('assets/box_back.png')),
//                                   InkWell(
//                                     onTap: () {
//                                       showDatePicker(context);
//                                       print('SO');
//                                     },
//                                     child: AutoSizeText(
//                                       DateTime.parse(timebox_date).day ==
//                                                   DateTime.now().day &&
//                                               DateTime.parse(timebox_date)
//                                                       .month ==
//                                                   DateTime.now().month &&
//                                               DateTime.parse(timebox_date)
//                                                       .year ==
//                                                   DateTime.now().year
//                                           ? 'Today'
//                                           : DateFormat('dd/MM/yyyy').format(
//                                               DateTime.parse(timebox_date)),
//                                       style: TextStyle(
//                                           fontSize: 16.0,
//                                           fontWeight: FontWeight.w600),
//                                     ),
//                                   ),
//                                   InkWell(
//                                       onTap: () {
//                                         setState(() {
//                                           DateTime currentDateTime =
//                                               DateTime.parse(timebox_date);
//                                           DateTime nextDateTime =
//                                               currentDateTime
//                                                   .add(Duration(days: 1));
//                                           timebox_date =
//                                               DateFormat('yyyy-MM-dd')
//                                                   .format(nextDateTime);
//                                           getTimeBoxDetails();
//                                         });
//                                       },
//                                       child: Image.asset(
//                                           'assets/box_forward.png')),
//                                 ],
//                               )),
//                           Container(
//                             padding: EdgeInsets.only(left: 16.0, right: 16.0),
//                             margin: EdgeInsets.only(top: 29.0),
//                             child: AutoSizeText(
//                               'Top Priorities',
//                               style: TextStyle(
//                                   fontSize: 15.0, fontWeight: FontWeight.w600),
//                             ),
//                           ),
//                           Container(
//                             // padding: EdgeInsets.only(left: 35, top: 5, right: 10),
//                             padding: EdgeInsets.only(left: 16.0, right: 16.0),
//                             // margin: EdgeInsets.only(top: 5.0),
//                             child: Container(
//                               color: Colors.white,

//                               // padding: EdgeInsets.all(2.0),
//                               child: TextField(
//                                 maxLines: 6, //or null
//                                 textInputAction: TextInputAction.next,
//                                 controller: txttopPriorController,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     top_priorities = value.toString();
//                                     print(top_priorities);
//                                   });
//                                 },

//                                 decoration: InputDecoration(
//                                     hintText: 'Details about priority',
//                                     hintStyle: TextStyle(fontSize: 14.0),
//                                     enabledBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                             width: 0.5,
//                                             color: ColorsTheme.txtDescColor))),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             padding: EdgeInsets.only(left: 16.0, right: 16.0),
//                             margin: EdgeInsets.only(top: 20),
//                             child: AutoSizeText(
//                               'Brain Dump',
//                               style: TextStyle(
//                                   fontSize: 15.0, fontWeight: FontWeight.w600),
//                             ),
//                           ),
//                           Container(
//                             padding: EdgeInsets.only(left: 16.0, right: 16.0),
//                             // margin: EdgeInsets.only(top: 5.0),
//                             child: Container(
//                               color: Colors.white,
//                               child: Padding(
//                                 padding: EdgeInsets.all(1.0),
//                                 child: TextField(
//                                   maxLines: 6, //or null
//                                   textInputAction: TextInputAction.done,
//                                   controller: txtbrainDumpController,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       brain_dump = value.toString();
//                                     });
//                                   },
//                                   decoration: InputDecoration(
//                                       hintText:
//                                           'User will type here and save and view in this same box.',
//                                       hintStyle: TextStyle(fontSize: 14.0),
//                                       enabledBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               width: 0.5,
//                                               color:
//                                                   ColorsTheme.txtDescColor))),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             padding: EdgeInsets.all(16.0),
//                             margin: EdgeInsets.only(top: 39),
//                             child: Table(
//                               columnWidths: {
//                                 0: height < 820
//                                     ? FractionColumnWidth(.35)
//                                     : FractionColumnWidth(.25),
//                                 1: height < 820
//                                     ? FractionColumnWidth(.65)
//                                     : FractionColumnWidth(.75)
//                               },
//                               border: TableBorder(
//                                 verticalInside: BorderSide(
//                                   color: ColorsTheme.txtDescColor,
//                                 ),
//                                 bottom: BorderSide(
//                                   color: ColorsTheme.txtDescColor,
//                                 ),
//                               ),
//                               children: [
//                                 TableRow(
//                                     decoration: BoxDecoration(
//                                         // borderRadius: BorderRadius.circular(2.0),
//                                         border: Border.all(
//                                             color: ColorsTheme.txtDescColor)),
//                                     children: [
//                                       Center(
//                                           child: Container(
//                                               margin: EdgeInsets.only(
//                                                   top: 9, bottom: 8),
//                                               child: AutoSizeText('Time'))),
//                                       Center(
//                                           child: Container(
//                                               margin: EdgeInsets.only(
//                                                   top: 9, bottom: 8),
//                                               child: AutoSizeText('Task'))),
//                                     ]),
//                                 TableRow(
//                                     decoration: BoxDecoration(
//                                         border: Border(
//                                             left: BorderSide(
//                                                 color:
//                                                     ColorsTheme.txtDescColor),
//                                             right: BorderSide(
//                                                 color:
//                                                     ColorsTheme.txtDescColor))),
//                                     children: [
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, bottom: 8, top: 16.0),
//                                           height: 40.0,
//                                           child: AutoSizeText('9:00 AM')),
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 16.0),
//                                           padding: EdgeInsets.only(right: 8.0),
//                                           height: 40.0,
//                                           child: TextField(
//                                             textInputAction:
//                                                 TextInputAction.next,
//                                             controller: txttaskController1,
//                                             decoration: InputDecoration(
//                                                 hintText: 'Enter task',
//                                                 hintStyle:
//                                                     TextStyle(fontSize: 14.0),
//                                                 contentPadding:
//                                                     EdgeInsets.all(4.0),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                         borderSide: BorderSide(
//                                                             width: 0.5,
//                                                             color: ColorsTheme
//                                                                 .txtDescColor))),
//                                           )),
//                                     ]),
//                                 TableRow(
//                                     decoration: BoxDecoration(
//                                         border: Border(
//                                             left: BorderSide(
//                                                 color:
//                                                     ColorsTheme.txtDescColor),
//                                             right: BorderSide(
//                                                 color:
//                                                     ColorsTheme.txtDescColor))),
//                                     children: [
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 10),
//                                           height: 40.0,
//                                           child: AutoSizeText('9:30 AM')),
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 16.0),
//                                           padding: EdgeInsets.only(right: 8.0),
//                                           height: 40.0,
//                                           child: TextField(
//                                             textInputAction:
//                                                 TextInputAction.next,
//                                             controller: txttaskController2,
//                                             decoration: InputDecoration(
//                                                 hintText: 'Enter task',
//                                                 hintStyle:
//                                                     TextStyle(fontSize: 14.0),
//                                                 contentPadding:
//                                                     EdgeInsets.all(4.0),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                         borderSide: BorderSide(
//                                                             width: 0.5,
//                                                             color: ColorsTheme
//                                                                 .txtDescColor))),
//                                           )),
//                                     ]),
//                                 TableRow(
//                                     decoration: BoxDecoration(
//                                         border: Border(
//                                             left: BorderSide(
//                                                 color:
//                                                     ColorsTheme.txtDescColor),
//                                             right: BorderSide(
//                                                 color:
//                                                     ColorsTheme.txtDescColor))),
//                                     children: [
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 10.0),
//                                           height: 40.0,
//                                           child: AutoSizeText('10:00 AM')),
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 16.0),
//                                           padding: EdgeInsets.only(right: 8.0),
//                                           height: 40.0,
//                                           child: TextField(
//                                             textInputAction:
//                                                 TextInputAction.next,
//                                             controller: txttaskController3,
//                                             decoration: InputDecoration(
//                                                 hintText: 'Enter task',
//                                                 hintStyle:
//                                                     TextStyle(fontSize: 14.0),
//                                                 contentPadding:
//                                                     EdgeInsets.all(4.0),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                         borderSide: BorderSide(
//                                                             width: 0.5,
//                                                             color: ColorsTheme
//                                                                 .txtDescColor))),
//                                           )),
//                                     ]),
//                                 TableRow(
//                                     decoration: BoxDecoration(
//                                         border: Border(
//                                             left: BorderSide(
//                                                 color:
//                                                     ColorsTheme.txtDescColor),
//                                             right: BorderSide(
//                                                 color:
//                                                     ColorsTheme.txtDescColor))),
//                                     children: [
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 10.0),
//                                           height: 40.0,
//                                           child: AutoSizeText('10:30 AM')),
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 16.0),
//                                           padding: EdgeInsets.only(right: 8.0),
//                                           height: 40.0,
//                                           child: TextField(
//                                             textInputAction:
//                                                 TextInputAction.next,
//                                             controller: txttaskController4,
//                                             decoration: InputDecoration(
//                                                 hintText: 'Enter task',
//                                                 hintStyle:
//                                                     TextStyle(fontSize: 14.0),
//                                                 contentPadding:
//                                                     EdgeInsets.all(4.0),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                         borderSide: BorderSide(
//                                                             width: 0.5,
//                                                             color: ColorsTheme
//                                                                 .txtDescColor))),
//                                           )),
//                                     ]),
//                                 TableRow(
//                                     decoration: BoxDecoration(
//                                         border: Border(
//                                             left: BorderSide(
//                                                 color:
//                                                     ColorsTheme.txtDescColor),
//                                             right: BorderSide(
//                                                 color:
//                                                     ColorsTheme.txtDescColor))),
//                                     children: [
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 10),
//                                           height: 40.0,
//                                           child: AutoSizeText('11:00 AM')),
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 16.0),
//                                           padding: EdgeInsets.only(right: 8.0),
//                                           height: 40.0,
//                                           child: TextField(
//                                             textInputAction:
//                                                 TextInputAction.next,
//                                             controller: txttaskController5,
//                                             decoration: InputDecoration(
//                                                 hintText: 'Enter task',
//                                                 hintStyle:
//                                                     TextStyle(fontSize: 14.0),
//                                                 contentPadding:
//                                                     EdgeInsets.all(4.0),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                         borderSide: BorderSide(
//                                                             width: 0.5,
//                                                             color: ColorsTheme
//                                                                 .txtDescColor))),
//                                           )),
//                                     ]),
//                                 TableRow(
//                                     decoration: BoxDecoration(
//                                         border: Border(
//                                             left: BorderSide(
//                                                 color:
//                                                     ColorsTheme.txtDescColor),
//                                             right: BorderSide(
//                                                 color:
//                                                     ColorsTheme.txtDescColor))),
//                                     children: [
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 10.0),
//                                           height: 40.0,
//                                           child: AutoSizeText('11:30 AM')),
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 16.0),
//                                           padding: EdgeInsets.only(right: 8.0),
//                                           height: 40.0,
//                                           child: TextField(
//                                             textInputAction:
//                                                 TextInputAction.next,
//                                             controller: txttaskController6,
//                                             decoration: InputDecoration(
//                                                 hintText: 'Enter task',
//                                                 hintStyle:
//                                                     TextStyle(fontSize: 14.0),
//                                                 contentPadding:
//                                                     EdgeInsets.all(4.0),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                         borderSide: BorderSide(
//                                                             width: 0.5,
//                                                             color: ColorsTheme
//                                                                 .txtDescColor))),
//                                           )),
//                                     ]),
//                                 TableRow(
//                                     decoration: BoxDecoration(
//                                         border: Border(
//                                             left: BorderSide(
//                                                 color:
//                                                     ColorsTheme.txtDescColor),
//                                             right: BorderSide(
//                                                 color:
//                                                     ColorsTheme.txtDescColor))),
//                                     children: [
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 10.0),
//                                           height: 40,
//                                           child: AutoSizeText('12:00 PM')),
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 16.0),
//                                           padding: EdgeInsets.only(right: 8.0),
//                                           height: 40.0,
//                                           child: TextField(
//                                             textInputAction:
//                                                 TextInputAction.next,
//                                             controller: txttaskController7,
//                                             decoration: InputDecoration(
//                                                 hintText: 'Enter task',
//                                                 hintStyle:
//                                                     TextStyle(fontSize: 14.0),
//                                                 contentPadding:
//                                                     EdgeInsets.all(4.0),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                         borderSide: BorderSide(
//                                                             width: 0.5,
//                                                             color: ColorsTheme
//                                                                 .txtDescColor))),
//                                           )),
//                                     ]),
//                                 TableRow(
//                                     decoration: BoxDecoration(
//                                         border: Border(
//                                             left: BorderSide(
//                                                 color:
//                                                     ColorsTheme.txtDescColor),
//                                             right: BorderSide(
//                                                 color:
//                                                     ColorsTheme.txtDescColor))),
//                                     children: [
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 10.0),
//                                           height: 40,
//                                           child: AutoSizeText('12:30 PM')),
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 16.0),
//                                           padding: EdgeInsets.only(right: 8.0),
//                                           height: 40.0,
//                                           child: TextField(
//                                             textInputAction:
//                                                 TextInputAction.next,
//                                             controller: txttaskController8,
//                                             decoration: InputDecoration(
//                                                 hintText: 'Enter task',
//                                                 hintStyle:
//                                                     TextStyle(fontSize: 14.0),
//                                                 contentPadding:
//                                                     EdgeInsets.all(4.0),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                         borderSide: BorderSide(
//                                                             width: 0.5,
//                                                             color: ColorsTheme
//                                                                 .txtDescColor))),
//                                           )),
//                                     ]),
//                                 TableRow(
//                                     decoration: BoxDecoration(
//                                         border: Border(
//                                             left: BorderSide(
//                                                 color:
//                                                     ColorsTheme.txtDescColor),
//                                             right: BorderSide(
//                                                 color:
//                                                     ColorsTheme.txtDescColor))),
//                                     children: [
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 10.0),
//                                           height: 40.0,
//                                           child: AutoSizeText('01:00 PM')),
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 16.0),
//                                           padding: EdgeInsets.only(right: 8.0),
//                                           height: 40.0,
//                                           child: TextField(
//                                             textInputAction:
//                                                 TextInputAction.next,
//                                             controller: txttaskController9,
//                                             decoration: InputDecoration(
//                                                 hintText: 'Enter task',
//                                                 hintStyle:
//                                                     TextStyle(fontSize: 14.0),
//                                                 contentPadding:
//                                                     EdgeInsets.all(4.0),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                         borderSide: BorderSide(
//                                                             width: 0.5,
//                                                             color: ColorsTheme
//                                                                 .txtDescColor))),
//                                           )),
//                                     ]),
//                                 TableRow(
//                                     decoration: BoxDecoration(
//                                         border: Border(
//                                             left: BorderSide(
//                                                 color:
//                                                     ColorsTheme.txtDescColor),
//                                             right: BorderSide(
//                                                 color:
//                                                     ColorsTheme.txtDescColor))),
//                                     children: [
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 10.0),
//                                           height: 40,
//                                           child: AutoSizeText('01:30 PM')),
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 16.0),
//                                           padding: EdgeInsets.only(right: 8.0),
//                                           height: 40.0,
//                                           child: TextField(
//                                             textInputAction:
//                                                 TextInputAction.next,
//                                             controller: txttaskController10,
//                                             decoration: InputDecoration(
//                                                 hintText: 'Enter task',
//                                                 hintStyle:
//                                                     TextStyle(fontSize: 14.0),
//                                                 contentPadding:
//                                                     EdgeInsets.all(4.0),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                         borderSide: BorderSide(
//                                                             width: 0.5,
//                                                             color: ColorsTheme
//                                                                 .txtDescColor))),
//                                           )),
//                                     ]),
//                                 TableRow(
//                                     decoration: BoxDecoration(
//                                         border: Border(
//                                       left: BorderSide(
//                                           color: ColorsTheme.txtDescColor),
//                                       right: BorderSide(
//                                         color: ColorsTheme.txtDescColor,
//                                       ),
//                                     )),
//                                     children: [
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 10.0),
//                                           height: 40,
//                                           child: AutoSizeText('02:00 PM')),
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 16.0),
//                                           padding: EdgeInsets.only(right: 8.0),
//                                           height: 40.0,
//                                           child: TextField(
//                                             textInputAction:
//                                                 TextInputAction.next,
//                                             controller: txttaskController11,
//                                             decoration: InputDecoration(
//                                                 hintText: 'Enter task',
//                                                 hintStyle:
//                                                     TextStyle(fontSize: 14.0),
//                                                 contentPadding:
//                                                     EdgeInsets.all(4.0),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                         borderSide: BorderSide(
//                                                             width: 0.5,
//                                                             color: ColorsTheme
//                                                                 .txtDescColor))),
//                                           )),
//                                     ]),
//                                 TableRow(
//                                     decoration: BoxDecoration(
//                                         border: Border(
//                                       left: BorderSide(
//                                           color: ColorsTheme.txtDescColor),
//                                       right: BorderSide(
//                                         color: ColorsTheme.txtDescColor,
//                                       ),
//                                     )),
//                                     children: [
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 10.0),
//                                           height: 40,
//                                           child: AutoSizeText('02:30 PM')),
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 16.0),
//                                           padding: EdgeInsets.only(right: 8.0),
//                                           height: 40.0,
//                                           child: TextField(
//                                             textInputAction:
//                                                 TextInputAction.next,
//                                             controller: txttaskController12,
//                                             decoration: InputDecoration(
//                                                 hintText: 'Enter task',
//                                                 hintStyle:
//                                                     TextStyle(fontSize: 14.0),
//                                                 contentPadding:
//                                                     EdgeInsets.all(4.0),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                         borderSide: BorderSide(
//                                                             width: 0.5,
//                                                             color: ColorsTheme
//                                                                 .txtDescColor))),
//                                           )),
//                                     ]),
//                                 TableRow(
//                                     decoration: BoxDecoration(
//                                         border: Border(
//                                       left: BorderSide(
//                                           color: ColorsTheme.txtDescColor),
//                                       right: BorderSide(
//                                         color: ColorsTheme.txtDescColor,
//                                       ),
//                                     )),
//                                     children: [
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 10.0),
//                                           child: AutoSizeText('03:00 PM')),
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 16.0),
//                                           padding: EdgeInsets.only(right: 8.0),
//                                           height: 40.0,
//                                           child: TextField(
//                                             textInputAction:
//                                                 TextInputAction.next,
//                                             controller: txttaskController13,
//                                             decoration: InputDecoration(
//                                                 hintText: 'Enter task',
//                                                 hintStyle:
//                                                     TextStyle(fontSize: 14.0),
//                                                 contentPadding:
//                                                     EdgeInsets.all(4.0),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                         borderSide: BorderSide(
//                                                             width: 0.5,
//                                                             color: ColorsTheme
//                                                                 .txtDescColor))),
//                                           )),
//                                     ]),
//                                 TableRow(
//                                     decoration: BoxDecoration(
//                                         border: Border(
//                                       left: BorderSide(
//                                           color: ColorsTheme.txtDescColor),
//                                       right: BorderSide(
//                                         color: ColorsTheme.txtDescColor,
//                                       ),
//                                     )),
//                                     children: [
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 10.0),
//                                           height: 40,
//                                           child: AutoSizeText('03:30 PM')),
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 16.0),
//                                           padding: EdgeInsets.only(right: 8.0),
//                                           height: 40.0,
//                                           child: TextField(
//                                             textInputAction:
//                                                 TextInputAction.next,
//                                             controller: txttaskController14,
//                                             decoration: InputDecoration(
//                                                 hintText: 'Enter task',
//                                                 hintStyle:
//                                                     TextStyle(fontSize: 14.0),
//                                                 contentPadding:
//                                                     EdgeInsets.all(4.0),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                         borderSide: BorderSide(
//                                                             width: 0.5,
//                                                             color: ColorsTheme
//                                                                 .txtDescColor))),
//                                           )),
//                                     ]),
//                                 TableRow(
//                                     decoration: BoxDecoration(
//                                         border: Border(
//                                       left: BorderSide(
//                                           color: ColorsTheme.txtDescColor),
//                                       right: BorderSide(
//                                         color: ColorsTheme.txtDescColor,
//                                       ),
//                                     )),
//                                     children: [
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 10.0),
//                                           height: 40,
//                                           child: AutoSizeText('04:00 PM')),
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 16.0),
//                                           padding: EdgeInsets.only(right: 8.0),
//                                           height: 40.0,
//                                           child: TextField(
//                                             textInputAction:
//                                                 TextInputAction.next,
//                                             controller: txttaskController15,
//                                             decoration: InputDecoration(
//                                                 hintText: 'Enter task',
//                                                 hintStyle:
//                                                     TextStyle(fontSize: 14.0),
//                                                 contentPadding:
//                                                     EdgeInsets.all(4.0),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                         borderSide: BorderSide(
//                                                             width: 0.5,
//                                                             color: ColorsTheme
//                                                                 .txtDescColor))),
//                                           )),
//                                     ]),
//                                 TableRow(
//                                     decoration: BoxDecoration(
//                                         border: Border(
//                                       left: BorderSide(
//                                           color: ColorsTheme.txtDescColor),
//                                       right: BorderSide(
//                                         color: ColorsTheme.txtDescColor,
//                                       ),
//                                     )),
//                                     children: [
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 10.0),
//                                           child: AutoSizeText('04:30 PM')),
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 16.0),
//                                           padding: EdgeInsets.only(right: 8.0),
//                                           height: 40.0,
//                                           child: TextField(
//                                             textInputAction:
//                                                 TextInputAction.next,
//                                             controller: txttaskController16,
//                                             decoration: InputDecoration(
//                                                 hintText: 'Enter task',
//                                                 hintStyle:
//                                                     TextStyle(fontSize: 14.0),
//                                                 contentPadding:
//                                                     EdgeInsets.all(4.0),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                         borderSide: BorderSide(
//                                                             width: 0.5,
//                                                             color: ColorsTheme
//                                                                 .txtDescColor))),
//                                           )),
//                                     ]),
//                                 TableRow(
//                                     decoration: BoxDecoration(
//                                         border: Border(
//                                       left: BorderSide(
//                                           color: ColorsTheme.txtDescColor),
//                                       right: BorderSide(
//                                         color: ColorsTheme.txtDescColor,
//                                       ),
//                                     )),
//                                     children: [
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 10.0),
//                                           height: 40,
//                                           child: AutoSizeText('05:00 PM')),
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 16.0),
//                                           padding: EdgeInsets.only(right: 8.0),
//                                           height: 40.0,
//                                           child: TextField(
//                                             textInputAction:
//                                                 TextInputAction.next,
//                                             controller: txttaskController17,
//                                             decoration: InputDecoration(
//                                                 hintText: 'Enter task',
//                                                 hintStyle:
//                                                     TextStyle(fontSize: 14.0),
//                                                 contentPadding:
//                                                     EdgeInsets.all(4.0),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                         borderSide: BorderSide(
//                                                             width: 0.5,
//                                                             color: ColorsTheme
//                                                                 .txtDescColor))),
//                                           )),
//                                     ]),
//                                 TableRow(
//                                     decoration: BoxDecoration(
//                                         border: Border(
//                                       left: BorderSide(
//                                           color: ColorsTheme.txtDescColor),
//                                       right: BorderSide(
//                                         color: ColorsTheme.txtDescColor,
//                                       ),
//                                     )),
//                                     children: [
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 10.0),
//                                           height: 40,
//                                           child: AutoSizeText('05:30 PM')),
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 16.0),
//                                           padding: EdgeInsets.only(right: 8.0),
//                                           height: 40.0,
//                                           child: TextField(
//                                             textInputAction:
//                                                 TextInputAction.next,
//                                             controller: txttaskController18,
//                                             decoration: InputDecoration(
//                                                 hintText: 'Enter task',
//                                                 hintStyle:
//                                                     TextStyle(fontSize: 14.0),
//                                                 contentPadding:
//                                                     EdgeInsets.all(4.0),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                         borderSide: BorderSide(
//                                                             width: 0.5,
//                                                             color: ColorsTheme
//                                                                 .txtDescColor))),
//                                           )),
//                                     ]),
//                                 TableRow(
//                                     decoration: BoxDecoration(
//                                         border: Border(
//                                       left: BorderSide(
//                                           color: ColorsTheme.txtDescColor),
//                                       right: BorderSide(
//                                         color: ColorsTheme.txtDescColor,
//                                       ),
//                                     )),
//                                     children: [
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 10.0),
//                                           height: 40,
//                                           child: AutoSizeText('06:00 PM')),
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 16.0),
//                                           padding: EdgeInsets.only(right: 8.0),
//                                           height: 40.0,
//                                           child: TextField(
//                                             textInputAction:
//                                                 TextInputAction.next,
//                                             controller: txttaskController19,
//                                             decoration: InputDecoration(
//                                                 hintText: 'Enter task',
//                                                 hintStyle:
//                                                     TextStyle(fontSize: 14.0),
//                                                 contentPadding:
//                                                     EdgeInsets.all(4.0),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                         borderSide: BorderSide(
//                                                             width: 0.5,
//                                                             color: ColorsTheme
//                                                                 .txtDescColor))),
//                                           )),
//                                     ]),
//                                 TableRow(
//                                     decoration: BoxDecoration(
//                                         border: Border(
//                                       left: BorderSide(
//                                           color: ColorsTheme.txtDescColor),
//                                       right: BorderSide(
//                                         color: ColorsTheme.txtDescColor,
//                                       ),
//                                     )),
//                                     children: [
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 10.0),
//                                           child: AutoSizeText('06:30 PM')),
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0, top: 16.0),
//                                           padding: EdgeInsets.only(right: 8.0),
//                                           height: 40.0,
//                                           child: TextField(
//                                             textInputAction:
//                                                 TextInputAction.next,
//                                             controller: txttaskController20,
//                                             decoration: InputDecoration(
//                                                 hintText: 'Enter task',
//                                                 hintStyle:
//                                                     TextStyle(fontSize: 14.0),
//                                                 contentPadding:
//                                                     EdgeInsets.all(4.0),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                         borderSide: BorderSide(
//                                                             width: 0.5,
//                                                             color: ColorsTheme
//                                                                 .txtDescColor))),
//                                           )),
//                                     ]),
//                                 TableRow(
//                                     decoration: BoxDecoration(
//                                         border: Border(
//                                       left: BorderSide(
//                                           color: ColorsTheme.txtDescColor),
//                                       right: BorderSide(
//                                         color: ColorsTheme.txtDescColor,
//                                       ),
//                                     )),
//                                     children: [
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0,
//                                               top: 10.0,
//                                               bottom: 10),
//                                           height: 40,
//                                           child: AutoSizeText('07:00 PM')),
//                                       Container(
//                                           margin: EdgeInsets.only(
//                                               left: 13.0,
//                                               top: 16.0,
//                                               bottom: 10),
//                                           padding: EdgeInsets.only(right: 8.0),
//                                           height: 40.0,
//                                           child: TextField(
//                                             textInputAction:
//                                                 TextInputAction.next,
//                                             controller: txttaskController21,
//                                             decoration: InputDecoration(
//                                                 hintText: 'Enter task',
//                                                 hintStyle:
//                                                     TextStyle(fontSize: 14.0),
//                                                 contentPadding:
//                                                     EdgeInsets.all(4.0),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                         borderSide: BorderSide(
//                                                             width: 0.5,
//                                                             color: ColorsTheme
//                                                                 .txtDescColor))),
//                                           )),
//                                     ]),
//                               ],
//                             ),
//                           ),
//                         ]),
//                   ),
//                   // if (is_loading == true && user.isEmpty)
//                   //   Container(
//                   //     alignment: Alignment.topCenter,
//                   //     // margin: EdgeInsets.only(to),
//                   //     child: CircularProgressIndicator(
//                   //       valueColor:
//                   //           AlwaysStoppedAnimation<Color>(ColorsTheme.btnColor),
//                   //     ),
//                   //   ),
//                 ],
//               ),
//             );
//           }),
//           floatingActionButton: Visibility(
//             visible: !keyboardVisible,
//             child: Container(
//               margin: const EdgeInsets.only(top: 120.0),
//               child: Container(
//                 alignment: Alignment.bottomCenter,
//                 // margin: EdgeInsets.only(top: 20.0),
//                 child: Container(
//                   width: orien == Orientation.portrait
//                       ? width * 0.85
//                       : width * 0.94,
//                   margin: EdgeInsets.only(top: 50.0),
//                   height: 48.0,
//                   child: TextButton(
//                     onPressed: () async {
//                       if (timebox_date.isNotEmpty &&
//                           txttopPriorController.text.isNotEmpty &&
//                           txtbrainDumpController.text.isNotEmpty) {
//                         if (txttaskController1.text.isNotEmpty) {
//                           task_list.add(txttaskController1.text);
//                           time_list.add('09:00');
//                         }
//                         if (txttaskController2.text.isNotEmpty) {
//                           task_list.add(txttaskController2.text);
//                           time_list.add('09:30');
//                         }
//                         if (txttaskController3.text.isNotEmpty) {
//                           task_list.add(txttaskController3.text);
//                           time_list.add('10:00');
//                         }
//                         if (txttaskController4.text.isNotEmpty) {
//                           task_list.add(txttaskController4.text);
//                           time_list.add('10:30');
//                         }
//                         if (txttaskController5.text.isNotEmpty) {
//                           task_list.add(txttaskController5.text);
//                           time_list.add('11:00');
//                         }
//                         if (txttaskController6.text.isNotEmpty) {
//                           task_list.add(txttaskController6.text);
//                           time_list.add('11:30');
//                         }
//                         if (txttaskController7.text.isNotEmpty) {
//                           task_list.add(txttaskController7.text);
//                           time_list.add('12:00');
//                         }
//                         if (txttaskController8.text.isNotEmpty) {
//                           task_list.add(txttaskController8.text);
//                           time_list.add('12:30');
//                         }
//                         if (txttaskController9.text.isNotEmpty) {
//                           task_list.add(txttaskController9.text);
//                           time_list.add('01:00');
//                         }
//                         if (txttaskController10.text.isNotEmpty) {
//                           task_list.add(txttaskController10.text);
//                           time_list.add('01:30');
//                         }
//                         if (txttaskController11.text.isNotEmpty) {
//                           task_list.add(txttaskController11.text);
//                           time_list.add('02:00');
//                         }
//                         if (txttaskController12.text.isNotEmpty) {
//                           task_list.add(txttaskController12.text);
//                           time_list.add('02:30');
//                         }
//                         if (txttaskController13.text.isNotEmpty) {
//                           task_list.add(txttaskController13.text);
//                           time_list.add('03:00');
//                         }
//                         if (txttaskController14.text.isNotEmpty) {
//                           task_list.add(txttaskController14.text);
//                           time_list.add('03:30');
//                         }
//                         if (txttaskController15.text.isNotEmpty) {
//                           task_list.add(txttaskController15.text);
//                           time_list.add('04:00');
//                         }
//                         if (txttaskController16.text.isNotEmpty) {
//                           task_list.add(txttaskController16.text);
//                           time_list.add('04:30');
//                         }
//                         if (txttaskController17.text.isNotEmpty) {
//                           task_list.add(txttaskController17.text);
//                           time_list.add('05:00');
//                         }
//                         if (txttaskController18.text.isNotEmpty) {
//                           task_list.add(txttaskController18.text);
//                           time_list.add('05:30');
//                         }
//                         if (txttaskController19.text.isNotEmpty) {
//                           task_list.add(txttaskController19.text);
//                           time_list.add('06:00');
//                         }
//                         if (txttaskController20.text.isNotEmpty) {
//                           task_list.add(txttaskController20.text);
//                           time_list.add('06:30');
//                         }
//                         if (txttaskController21.text.isNotEmpty) {
//                           task_list.add(txttaskController21.text);
//                           time_list.add('07:00');
//                         }

//                         task_list.forEach((element) {
//                           print(element);
//                         });

//                         if (task_list.length != 0) {
//                           saveTimeBox();
//                           setState(() {
//                             txttopPriorController.clear();
//                             txtbrainDumpController.clear();
//                             txttaskController1.clear();
//                             txttaskController2.clear();
//                             txttaskController3.clear();
//                             txttaskController4.clear();
//                             txttaskController5.clear();
//                             txttaskController6.clear();
//                             txttaskController7.clear();
//                             txttaskController8.clear();
//                             txttaskController9.clear();
//                             txttaskController10.clear();
//                             txttaskController11.clear();
//                             txttaskController12.clear();
//                             txttaskController13.clear();
//                             txttaskController14.clear();
//                             txttaskController15.clear();
//                             txttaskController16.clear();
//                             txttaskController17.clear();
//                             txttaskController18.clear();
//                             txttaskController19.clear();
//                             txttaskController20.clear();
//                             txttaskController21.clear();
//                           });
//                         } else
//                           Fluttertoast.showToast(
//                               msg: "Any field is missing!",
//                               toastLength: Toast.LENGTH_SHORT,
//                               gravity: ToastGravity.CENTER,
//                               timeInSecForIosWeb: 1,
//                               backgroundColor: ColorsTheme.dangerColor,
//                               textColor: Colors.white,
//                               fontSize: 16.0);
//                       } else
//                         Fluttertoast.showToast(
//                             msg: "Any field is missing!",
//                             toastLength: Toast.LENGTH_SHORT,
//                             gravity: ToastGravity.CENTER,
//                             timeInSecForIosWeb: 1,
//                             backgroundColor: ColorsTheme.dangerColor,
//                             textColor: Colors.white,
//                             fontSize: 16.0);
//                     },
//                     style: ButtonStyle(
//                         alignment: Alignment.center,
//                         shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30.0))),
//                         backgroundColor:
//                             MaterialStateProperty.all(ColorsTheme.btnColor)),
//                     child: AutoSizeText(
//                       'Save',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           // floatingActionButtonLocation:
//           //     FloatingActionButtonLocation.centerFloat,
//           floatingActionButtonLocation: centerDocked,
//         ));
//   }
// }

// class _CenterDockedFloatingActionButtonLocation
//     extends _DockedFloatingActionButtonLocation {
//   const _CenterDockedFloatingActionButtonLocation();

//   @override
//   Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
//     final double fabX = (scaffoldGeometry.scaffoldSize.width -
//             scaffoldGeometry.floatingActionButtonSize.width) /
//         2.0;
//     return Offset(fabX, getDockedY(scaffoldGeometry));
//   }
// }

// abstract class _DockedFloatingActionButtonLocation
//     extends FloatingActionButtonLocation {
//   const _DockedFloatingActionButtonLocation();
//   @protected
//   double getDockedY(ScaffoldPrelayoutGeometry scaffoldGeometry) {
//     final double contentBottom = scaffoldGeometry.contentBottom;
//     final double appBarHeight = scaffoldGeometry.bottomSheetSize.height;
//     final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
//     final double snackBarHeight = scaffoldGeometry.snackBarSize.height;

//     double fabY = contentBottom - fabHeight / 2.0;
//     if (snackBarHeight > 0.0)
//       fabY = math.min(
//           fabY,
//           contentBottom -
//               snackBarHeight -
//               fabHeight -
//               kFloatingActionButtonMargin);
//     if (appBarHeight > 0.0)
//       fabY = math.min(fabY, contentBottom - appBarHeight - fabHeight / 2.0);

//     final double maxFabY = scaffoldGeometry.scaffoldSize.height - fabHeight;
//     return math.min(maxFabY, fabY);
//   }
// }

//              FLUTTER CALENDAR VIEW                //////////////

// class TimeBoxPage extends StatelessWidget {
//   const TimeBoxPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // return CalendarControllerProvider<Event>(
//     //   controller: EventController<Event>()..addAll(_events),
//     final state = Provider.of<TimeBoxState>(context);
//     return Scaffold(
//       body: state.isLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           :
//            DayView(
//               controller: EventController()..addAll(state.eventList),
//               // controller: EventController(),
//               // controller: CalendarControllerProvider.of(context).controller..add(state.event),
//               eventTileBuilder: (date, events, boundry, start, end) {
//                 // Return your widget to display as event tile.

//                 return Text(start.toString());
//                 // return Container();
//               },
//               fullDayEventBuilder: (events, date) {
//                 // Return your widget to display full day event view.
//                 return Container(
//                   // child:
//                   // state.timeBoxResponse!.data!.tasklist!.isEmpty ?
//                   // Column(
//                   //   children: state.timeBoxResponse!.data!.tasklist!.map((e) {
//                   //     return Row(
//                   //       children: [
//                   //         Text(e.time ?? ''),
//                   //         Text(e.task ?? ''),
//                   //       ],
//                   //     );
//                   //   }).toList(),
//                   // ) : Container(),
//                 );
//                 // return Container();
//               },

//               showVerticalLine: true, // To display live time line in day view.
//               showLiveTimeLineInAllDays:
//                   true, // To display live time line in all pages in day view.
//               minDay: DateTime(1990),
//               maxDay: DateTime(2050),
//               initialDay: DateTime.now(),
//               heightPerMinute: 1, // height occupied by 1 minute time span.
//               eventArranger:
//                   SideEventArranger(), // To define how simultaneous events will be arranged.
//               onEventTap: (events, date) => print(events),
//               onDateLongPress: (date) => print(date),
//               onDateTap: (date) {
//                 showModalBottomSheet(
//                     context: context,
//                     builder: (context) {
//                       return Container(
//                         padding: kStandardPadding(),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             LSizedBox(),
//                             Center(
//                                 child:
//                                     Text('Add Task', style: kkBoldTextStyle())),
//                             kSizedBox(),
//                             Text('Top Priority', style: kBoldTextStyle()),
//                             sSizedBox(),
//                             TextFormField(
//                               controller: state.prioritiesController,
//                               decoration: InputDecoration(
//                                   isDense: true,
//                                   border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(5)),
//                                   focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(5),
//                                       borderSide:
//                                           BorderSide(color: blueColor))),
//                             ),
//                             kSizedBox(),
//                             Text('Brain dump', style: kBoldTextStyle()),
//                             sSizedBox(),
//                             TextFormField(
//                               controller: state.brainDumpController,
//                               maxLines: 2,
//                               decoration: InputDecoration(
//                                   isDense: true,
//                                   border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(5)),
//                                   focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(5),
//                                       borderSide:
//                                           BorderSide(color: blueColor))),
//                             ),
//                             kSizedBox(),
//                             Text('Tasks', style: kBoldTextStyle()),
//                             sSizedBox(),
//                             TextFormField(
//                               onChanged: state.onTaskDataChanged,
//                               maxLines: 3,
//                               decoration: InputDecoration(
//                                   isDense: true,
//                                   border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(5)),
//                                   focusedBorder: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(5),
//                                       borderSide:
//                                           BorderSide(color: blueColor))),
//                             ),
//                             kSizedBox(),
//                             InkWell(
//                               onTap: () {
//                                 state.saveTimeBox(date);
//                               },
//                               child: Container(
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(
//                                   color: blueColor,
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 padding: EdgeInsets.symmetric(vertical: 15),
//                                 child: Center(
//                                     child: Text(
//                                   'Add Task',
//                                   style: kkWhiteBoldTextStyle(),
//                                 )),
//                               ),
//                             )
//                           ],
//                         ),
//                       );
//                     });
//               },
//             ),
//     );
//   }
// }

///////////                   SYNCFUSION CALENDAR FLUTTER           /////////

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../models/meeting.dart';

/// The app which hosts the home page which contains the calendar on it.

/// The hove page which hosts the calendar
class TimeBoxPage extends StatefulWidget {
  /// Creates the home page to display teh calendar widget.
  const TimeBoxPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TimeBoxPageState createState() => _TimeBoxPageState();
}

class _TimeBoxPageState extends State<TimeBoxPage> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<TimeBoxState>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Time Box',
            style: kkBoldTextStyle().copyWith(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body:
        state.isLoading ? Center(
          child: CircularProgressIndicator(),
        ) :
         SfCalendar(
          view: CalendarView.day,
          dataSource: MeetingDataSource(state.getDataSource()),
          appointmentTextStyle: kWhiteBoldTextStyle(),
          backgroundColor: Colors.white,
          appointmentBuilder: (BuildContext context,
                CalendarAppointmentDetails details) {
              final Appointment meeting =
                  details.appointments.first;
              // final String image = _getImage();
              if (state.calendarController.view != CalendarView.month &&
                  state.calendarController.view != CalendarView.schedule) {
                return Container(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3),
                        height: 50,
                        alignment: Alignment.topLeft,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                          color: meeting.color,
                        ),
                        child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  meeting.subject,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 3,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                        'Time: ${DateFormat('hh:mm a').format(meeting.startTime)} - ' +
                                            '${DateFormat('hh:mm a').format(meeting.endTime)}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      )
                              ],
                        )),
                      ),
                      Container(
                        height: details.bounds.height - 70,
                        padding: EdgeInsets.fromLTRB(3, 5, 3, 2),
                        color: meeting.color.withOpacity(0.8),
                        alignment: Alignment.topLeft,
                        child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Image(
                                        image:
                                            ExactAssetImage('assets/chat.png'),
                                        fit: BoxFit.contain,
                                        width: details.bounds.width,
                                        height: 60)),
                                Text(
                                  meeting.notes!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                )
                              ],
                        )),
                      ),
                      Container(
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          color: meeting.color,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container(
                child: Text(meeting.subject),
              );
            },
          
          // appointmentBuilder: (context, calendarAppointmentDetails) {
          //   return Container();
          // },
          // by default the month appointment display mode set as Indicator, we can
          // change the display mode as appointment using the appointment display
          // mode property
          monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
              controller: CalendarController(),
        ));
  }

  
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
