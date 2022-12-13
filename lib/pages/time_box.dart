import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:gigX/api.dart';
import 'package:gigX/colors.dart';
import 'package:gigX/login.dart';
import 'package:gigX/pages/account.dart';
import 'package:gigX/pages/webviewprivacypolicy.dart';
import 'package:gigX/pages/webviewtermsandconditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeBox extends StatelessWidget {
  const TimeBox({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimeBox Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: Colors.white),
      home: const TimeBoxPage(),
    );
  }
}

var height, width;
Map<String, dynamic> user = new Map<String, dynamic>();
String? access_token = "";
String userEmail = "", userName = "", profileUrl = "";

class TimeBoxPage extends StatefulWidget {
  const TimeBoxPage({super.key});

  @override
  State<TimeBoxPage> createState() => _TimeBoxPageState();
}

class _TimeBoxPageState extends State<TimeBoxPage> {
  SharedPreferences? preferences;
  bool is_loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: OrientationBuilder(builder: (context, orientation) {
          return SingleChildScrollView(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: width,
                  height: orientation == Orientation.portrait
                      ? height * 2.47
                      : height * 5.2,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              // padding: EdgeInsets.all(16.0),
                              margin: EdgeInsets.only(top: 40.0, left: 16.0),
                              child: IconButton(
                                  onPressed: () async {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AccountTab()));
                                  },
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.all(10.0),
                              margin: EdgeInsets.only(top: 40.0),
                              child: AutoSizeText(
                                'Time Box',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.0),
                              ),
                            ),
                          ],
                        ),
                        Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset('assets/box_back.png'),
                                AutoSizeText(
                                  'Today',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                Image.asset('assets/box_forward.png'),
                              ],
                            )),
                        Container(
                          padding: EdgeInsets.all(16.0),
                          margin: EdgeInsets.only(top: 29.0, left: 16),
                          child: AutoSizeText(
                            'Today’s Priorities',
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          height: 110,
                          padding: EdgeInsets.all(16.0),
                          margin: EdgeInsets.only(left: 16.0),
                          child: MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: ListView.builder(
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      height: 49.0,
                                      width: width * 0.85,
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.only(bottom: 9.0),
                                      decoration: BoxDecoration(
                                        color: Color(0xffF7F8F9),
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.only(left: 12.0),
                                        width: width * 0.8,
                                        child: AutoSizeText(
                                          'HTML/CSS  - eFleetPass Mobile App',
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: ColorsTheme.txtDescColor,
                                              fontSize: 15.0),
                                        ),
                                      ),
                                    );
                                  })),
                        ),
                        Container(
                          padding: EdgeInsets.all(16.0),
                          margin: EdgeInsets.only(top: 29.0, left: 20),
                          child: AutoSizeText(
                            'Top Priorities',
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          // padding: EdgeInsets.only(left: 35, top: 5, right: 10),
                          padding: EdgeInsets.all(16.0),
                          margin: EdgeInsets.only(top: 5.0, left: 14),
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                maxLines: 6, //or null
                                textInputAction: TextInputAction.next,

                                decoration: InputDecoration(
                                    hintText: 'Details about priority',
                                    hintStyle: TextStyle(fontSize: 14.0),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 0.5,
                                            color: ColorsTheme.txtDescColor))),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            width: orientation == Orientation.portrait
                                ? width * 0.85
                                : width * 0.94,
                            margin: EdgeInsets.only(left: 20.0, top: 30.0),
                            height: 48.0,
                            child: TextButton(
                              onPressed: () async {},
                              style: ButtonStyle(
                                  alignment: Alignment.center,
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0))),
                                  backgroundColor: MaterialStateProperty.all(
                                      ColorsTheme.btnColor)),
                              child: AutoSizeText(
                                'Save',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(left: 40.0, right: 15.0, top: 68),
                          child: AutoSizeText(
                            'Brain Dump',
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 40, top: 5, right: 16),
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(1.0),
                              child: TextField(
                                maxLines: 6, //or null
                                textInputAction: TextInputAction.done,

                                decoration: InputDecoration(
                                    hintText:
                                        'User will type here and save and view in this same box.',
                                    hintStyle: TextStyle(fontSize: 14.0),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 0.5,
                                            color: ColorsTheme.txtDescColor))),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            width: orientation == Orientation.portrait
                                ? width * 0.85
                                : width * 0.94,
                            margin: EdgeInsets.only(left: 28.0, top: 30.0),
                            height: 48.0,
                            child: TextButton(
                              onPressed: () async {},
                              style: ButtonStyle(
                                  alignment: Alignment.center,
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0))),
                                  backgroundColor: MaterialStateProperty.all(
                                      ColorsTheme.btnColor)),
                              child: AutoSizeText(
                                'Save',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(left: 40.0, right: 15.0, top: 39),
                          child: Table(
                            columnWidths: {
                              0: FractionColumnWidth(.35),
                              1: FractionColumnWidth(.65)
                            },
                            border: TableBorder(
                              verticalInside: BorderSide(
                                color: ColorsTheme.txtDescColor,
                              ),
                              bottom: BorderSide(
                                color: ColorsTheme.txtDescColor,
                              ),
                            ),
                            children: [
                              TableRow(
                                  decoration: BoxDecoration(
                                      // borderRadius: BorderRadius.circular(2.0),
                                      border: Border.all(
                                          color: ColorsTheme.txtDescColor)),
                                  children: [
                                    Center(
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                top: 9, bottom: 8),
                                            child: AutoSizeText('Time'))),
                                    Center(
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                top: 9, bottom: 8),
                                            child: AutoSizeText('Task'))),
                                  ]),
                              TableRow(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: ColorsTheme.txtDescColor),
                                          right: BorderSide(
                                              color:
                                                  ColorsTheme.txtDescColor))),
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 13.0, bottom: 10, top: 16.0),
                                        child: AutoSizeText('8:00 AM')),
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 13.0, top: 16.0),
                                        child: AutoSizeText(
                                          'Wake up',
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400),
                                        )),
                                  ]),
                              TableRow(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: ColorsTheme.txtDescColor),
                                          right: BorderSide(
                                              color:
                                                  ColorsTheme.txtDescColor))),
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 13.0, bottom: 10),
                                        child: AutoSizeText('9:00 AM')),
                                    Container(
                                        margin: EdgeInsets.only(left: 13.0),
                                        child: AutoSizeText('Check logs')),
                                  ]),
                              TableRow(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: ColorsTheme.txtDescColor),
                                          right: BorderSide(
                                              color:
                                                  ColorsTheme.txtDescColor))),
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 13.0, bottom: 10.0),
                                        child: AutoSizeText('10:00 AM')),
                                    Container(
                                        margin: EdgeInsets.only(left: 13.0),
                                        child: AutoSizeText('Check logs')),
                                  ]),
                              TableRow(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: ColorsTheme.txtDescColor),
                                          right: BorderSide(
                                              color:
                                                  ColorsTheme.txtDescColor))),
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(
                                          left: 13.0,
                                        ),
                                        child: AutoSizeText('11:00 AM')),
                                    Container(
                                        margin: EdgeInsets.only(left: 13.0),
                                        child: AutoSizeText(
                                            'Lorem ipsum dolor sit ')),
                                  ]),
                              TableRow(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: ColorsTheme.txtDescColor),
                                          right: BorderSide(
                                              color:
                                                  ColorsTheme.txtDescColor))),
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 13.0, bottom: 10.0),
                                        child: AutoSizeText('12:00 PM')),
                                    Container(
                                        margin: EdgeInsets.only(left: 13.0),
                                        child: AutoSizeText(
                                            'Lorem ipsum dolor sit ')),
                                  ]),
                              TableRow(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: ColorsTheme.txtDescColor),
                                          right: BorderSide(
                                              color:
                                                  ColorsTheme.txtDescColor))),
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 13.0, bottom: 10.0),
                                        child: AutoSizeText('01:00 PM')),
                                    Container(
                                        margin: EdgeInsets.only(left: 13.0),
                                        child: AutoSizeText('Lunch time')),
                                  ]),
                              TableRow(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: ColorsTheme.txtDescColor),
                                          right: BorderSide(
                                              color:
                                                  ColorsTheme.txtDescColor))),
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 13.0, bottom: 10.0),
                                        child: AutoSizeText('02:00 PM')),
                                    Container(
                                        margin: EdgeInsets.only(left: 13.0),
                                        child: AutoSizeText(
                                            'Lorem ipsum dolor sit ')),
                                  ]),
                              TableRow(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: ColorsTheme.txtDescColor),
                                          right: BorderSide(
                                              color:
                                                  ColorsTheme.txtDescColor))),
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 13.0, bottom: 10.0),
                                        child: AutoSizeText('03:00 PM')),
                                    Container(
                                        margin: EdgeInsets.only(left: 13.0),
                                        child: AutoSizeText(
                                            'Lorem ipsum dolor sit ')),
                                  ]),
                              TableRow(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: ColorsTheme.txtDescColor),
                                          right: BorderSide(
                                              color:
                                                  ColorsTheme.txtDescColor))),
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 13.0, bottom: 10.0),
                                        child: AutoSizeText('04:00 PM')),
                                    Container(
                                        margin: EdgeInsets.only(left: 13.0),
                                        child: AutoSizeText(
                                            'Lorem ipsum dolor sit ')),
                                  ]),
                              TableRow(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: ColorsTheme.txtDescColor),
                                          right: BorderSide(
                                              color:
                                                  ColorsTheme.txtDescColor))),
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 13.0, bottom: 10.0),
                                        child: AutoSizeText('05:00 PM')),
                                    Container(
                                        margin: EdgeInsets.only(left: 13.0),
                                        child: AutoSizeText(
                                            'Lorem ipsum dolor sit ')),
                                  ]),
                              TableRow(
                                  decoration: BoxDecoration(
                                      border: Border(
                                    left: BorderSide(
                                        color: ColorsTheme.txtDescColor),
                                    right: BorderSide(
                                      color: ColorsTheme.txtDescColor,
                                    ),
                                  )),
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 13.0, bottom: 10.0),
                                        child: AutoSizeText('06:00 PM')),
                                    Container(
                                        margin: EdgeInsets.only(left: 13.0),
                                        child: AutoSizeText(
                                            'Lorem ipsum dolor sit ')),
                                  ]),
                            ],
                          ),
                        ),
                      ]),
                ),
                // if (is_loading == true && user.isEmpty)
                //   Container(
                //     alignment: Alignment.topCenter,
                //     // margin: EdgeInsets.only(to),
                //     child: CircularProgressIndicator(
                //       valueColor:
                //           AlwaysStoppedAnimation<Color>(ColorsTheme.btnColor),
                //     ),
                //   ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
