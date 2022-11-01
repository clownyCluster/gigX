import 'package:efleet_project_tree/colors.dart';
import 'package:efleet_project_tree/utils/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationTab extends StatelessWidget {
  const NotificationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Tab Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: ColorsTheme.bgColor),
      home: const NotificationTabPage(),
    );
  }
}

var height, width;

class NotificationTabPage extends StatefulWidget {
  const NotificationTabPage({super.key});

  @override
  State<NotificationTabPage> createState() => _NotificationTabPageState();
}

class _NotificationTabPageState extends State<NotificationTabPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tz.initializeTimeZones();

  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return SingleChildScrollView(
          child: Container(
            height: orientation == Orientation.portrait ? height : height * 2.0,
            width: width,
            child: Column(children: [
              Container(
                padding: EdgeInsets.all(40.0),
                margin: EdgeInsets.only(top: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        // padding: EdgeInsets.all(50.0),

                        child: Text(
                      'Messages',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0,
                          color: Colors.black),
                    )),
                    Container(
                      child: Image(image: AssetImage('assets/icon_search.png')),
                    )
                  ],
                ),
              ),
              Container(
                height: orientation == Orientation.portrait
                    ? height * 0.68
                    : height * 1.2,
                padding: orientation == Orientation.portrait
                    ? EdgeInsets.all(10.0)
                    : EdgeInsets.all(20.0),
                child: ListView.builder(
                    itemCount: 8,
                    shrinkWrap: true,
                    itemExtent: 100.0,
                    itemBuilder: (BuildContext context, index) {
                      return Container(
                        padding: EdgeInsets.only(left: 10.0, top: 10.0),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.black26))),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30.0,
                            backgroundImage: AssetImage('assets/profile.png'),
                          ),
                          title: new RichText(
                            text: TextSpan(children: [
                              new TextSpan(
                                  text:
                                      'Leonardo De La Vega created this task \n',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.0,
                                      color: Colors.black)),
                              new TextSpan(
                                  text: 'Yesterday at 01:23 PM',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: ColorsTheme.txtDescColor)),
                            ]),
                          ),
                        ),
                      );
                    }),
              )
            ]),
          ),
        );
      }),
    );
  }
}
