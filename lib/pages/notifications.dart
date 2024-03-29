import 'package:dio/dio.dart';
import 'package:gigX/api.dart';
import 'package:gigX/colors.dart';
import 'package:gigX/constant/constants.dart';
import 'package:gigX/login.dart';
import 'package:gigX/utils/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';

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
  late Map notificationsMap;
  DateTime? formatted_updated_at;
  bool is_search_visible = true;
  String search_query = "";
  Map<String, dynamic> user = new Map<String, dynamic>();
  String profileUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tz.initializeTimeZones();
    pref();
    getNotifications();
    getUserProfile();
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

  Future<void> getUserProfile() async {
    final _dio = new Dio();
    this.preferences = await SharedPreferences.getInstance();
    setState(() {
      access_token = this.preferences?.getString('access_token');
      is_loading = true;
    });
    try {
      Response response = await _dio.get(API.base_url + 'me',
          options: Options(headers: {"authorization": "Bearer $access_token"}));

      if (response.statusCode == 200) {
        this.preferences?.setBool('someoneLoggedIn', false);
        setState(() {
          is_loading = false;
          user = response.data;
          profileUrl = user['ProfilePic'];
          print(profileUrl);
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
    } on DioError catch (e) {
      print(e);
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
    }
  }

  Future<void> getNotificationsFromSearch(String search) async {
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

            setSearchResults(search);

            // if (notifications.isNotEmpty == true)
            //   NotificationService().showNotification(element['todo_id'],
            //       element['notification'], 'Tap to view details', 10);
          });
        });
      }

      return null;
    } on DioError catch (e) {
      return null;
    }
  }

  void setSearchResults(String query) {
    setState(() {
      is_loading = true;
      notifications = notifications
          .where((elem) => elem['notification']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
      is_loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: whiteColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        
        
        title: Column(
          children: [
            is_search_visible == true
                ? Container(
                    // padding: EdgeInsets.only(
                    //     left: 30, right: 30, top: 40, bottom: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    // margin: EdgeInsets.only(top: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          // padding: EdgeInsets.all(50.0),

                          child: Text(
                            'Notifications',
                            style: kkBoldTextStyle().copyWith(
                                fontSize: 20, color: Colors.grey[800]),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (this.mounted)
                              setState(() {
                                if (is_search_visible == true)
                                  setState(() {
                                    is_search_visible = false;
                                  });
                              });
                          },
                          child: Container(
                            child: Image(
                                image: AssetImage('assets/icon_search.png')),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(
                    // padding: EdgeInsets.all(40.0),
                    // margin: EdgeInsets.only(top: 20.0),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            decoration:
                                InputDecoration(hintText: 'Search here'),
                            onChanged: (value) {
                              if (this.mounted)
                                setState(() {
                                  search_query = value.toString();
                                  getNotificationsFromSearch(search_query);
                                });
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (this.mounted)
                              setState(() {
                                is_search_visible = true;
                              });
                            print(search_query);
                          },
                          child: Container(
                            child: Image(
                                image: AssetImage('assets/icon_search.png')),
                          ),
                        )
                      ],
                    ),
                  ),
          ],
        ),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return SingleChildScrollView(
          child: Container(
            height: orientation == Orientation.portrait ? height : height * 2.0,
            width: width,
            child: Column(children: [
              // is_search_visible == true
              //     ? Container(
              //         padding: EdgeInsets.all(40.0),
              //         margin: EdgeInsets.only(top: 40.0),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: <Widget>[
              //             Container(
              //                 // padding: EdgeInsets.all(50.0),

              //                 child: Text(
              //               'Messages',
              //               style: TextStyle(
              //                   fontWeight: FontWeight.w600,
              //                   fontSize: 20.0,
              //                   color: Colors.black),
              //             )),
              //             GestureDetector(
              //               onTap: () {
              //                 if (this.mounted)
              //                   setState(() {
              //                     if (is_search_visible == true)
              //                       setState(() {
              //                         is_search_visible = false;
              //                       });
              //                   });
              //               },
              //               child: Container(
              //                 child: Image(
              //                     image: AssetImage('assets/icon_search.png')),
              //               ),
              //             )
              //           ],
              //         ),
              //       )
              //     : Container(
              //         padding: EdgeInsets.all(40.0),
              //         margin: EdgeInsets.only(top: 40.0),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.start,
              //           crossAxisAlignment: CrossAxisAlignment.center,
              //           children: [
              //             SizedBox(
              //               width: width * 0.7,
              //               height: 60,
              //               child: TextField(
              //                 decoration:
              //                     InputDecoration(hintText: 'Search here'),
              //                 onChanged: (value) {
              //                   if (this.mounted)
              //                     setState(() {
              //                       search_query = value.toString();
              //                       getNotificationsFromSearch(search_query);
              //                     });
              //                 },
              //               ),
              //             ),
              //             GestureDetector(
              //               onTap: () {
              //                 if (this.mounted)
              //                   setState(() {
              //                     is_search_visible = true;
              //                   });
              //               },
              //               child: Container(
              //                 child: Image(
              //                     image: AssetImage('assets/icon_search.png')),
              //               ),
              //             )
              //           ],
              //         ),
              //       ),
              if (notifications.isNotEmpty)
                Container(
                  height: orientation == Orientation.portrait
                      ? height * 0.68
                      : height * 1.2,
                  padding: orientation == Orientation.portrait
                      ? EdgeInsets.all(10.0)
                      : EdgeInsets.all(20.0),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
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
                                backgroundImage:
                                    NetworkImage(profileUrl.toString()),
                              ),
                              title: new RichText(
                                text: TextSpan(children: [
                                  new TextSpan(
                                      text: notifications[index]
                                              ['notification'] +
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
                  ),
                ),
              if (is_loading == true && notifications.isEmpty)
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(top: height * 0.3),
                  // margin: EdgeInsets.only(to),
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(ColorsTheme.btnColor),
                  ),
                ),
              if (is_loading == false && notifications.length == 0)
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(top: height * 0.3),
                  // margin: EdgeInsets.only(to),
                  child: Text(
                    'No Notifications Found!',
                  ),
                ),
            ]),
          ),
        );
      }),
    );
  }
}
