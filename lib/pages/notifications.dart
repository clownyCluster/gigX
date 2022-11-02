import 'package:dio/dio.dart';
import 'package:efleet_project_tree/api.dart';
import 'package:efleet_project_tree/colors.dart';
import 'package:efleet_project_tree/login.dart';
import 'package:efleet_project_tree/utils/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';

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
  SharedPreferences? preferences;
  String? access_token = "";
  bool is_loading = false;
  var notifications = [];
  DateTime? formatted_updated_at;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tz.initializeTimeZones();
    pref();
    getNotifications();
  }

  Future<void> pref() async {
    this.preferences = await SharedPreferences.getInstance();

    access_token = this.preferences?.getString('access_token');
  }

  Future<void> getNotifications() async {
    final _dio = Dio();
    is_loading = true;
    String? access_token;
    DateFormat format = DateFormat("yyyy-MM-dd hh:mm:ss");

    this.preferences = await SharedPreferences.getInstance();
    setState(() {
      access_token = this.preferences?.getString('access_token');
    });

    try {
      Response response = await _dio.get(API.base_url + 'my/todo-notifications',
          options: Options(headers: {"authorization": "Bearer $access_token"}));
      Map result = response.data;

      if (response.statusCode == 200) {
        this.preferences?.setBool('someoneLoggedIn', false);
        setState(() {
          notifications = response.data['data'];
          is_loading = false;
          notifications.forEach((element) {
            formatted_updated_at = format.parse(element['updated_at']);

            element['updated_at'] =
                DateFormat('MMMM dd, yyyy hh:mm').format(formatted_updated_at!);

            // if (notifications.isNotEmpty == true)
            //   NotificationService().showNotification(element['todo_id'],
            //       element['notification'], 'Tap to view details', 10);
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
                    itemCount: notifications.length,
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
                                  text: notifications[index]['notification'] +
                                      '\n',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.0,
                                      color: Colors.black)),
                              new TextSpan(
                                  text: notifications[index]['updated_at'],
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
