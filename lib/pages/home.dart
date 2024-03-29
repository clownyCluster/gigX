import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:gigX/api.dart';
import 'package:gigX/colors.dart';
import 'package:gigX/constant/constants.dart';
import 'package:gigX/home.dart';
import 'package:gigX/login.dart';
import 'package:gigX/pages/projectdetails.dart';
import 'package:gigX/utils/notification_service.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class HomeTab extends StatelessWidget {
//   const HomeTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Home Tab',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//           primarySwatch: Colors.blue,
//           fontFamily: 'Poppins',
//           scaffoldBackgroundColor: ColorsTheme.bgColor),
//       home: const HomeTabPage(),
//     );
//   }
// }

var height, width;

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  SharedPreferences? preferences;
  bool _is_loading = false;
  bool is_search_visible = true;
  bool keyboardVisible = false;
  bool notification_shown = false;
  var projects = [];
  var notifications = [];
  List list = [];
  Map<String, dynamic> user = new Map<String, dynamic>();
  String? user_id = "";
  int current_max = 4;
  late ScrollController controller;
  XFile? image; //this is the state variable
  bool picked = false, duration_selected = false;
  String txtProjectName = "", txtProjectDesc = "";
  TextEditingController txtProjectNameController = new TextEditingController();
  TextEditingController txtProjectDescController = new TextEditingController();
  String? access_token;
  String search_query = "";
  AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsFlutterBinding.ensureInitialized();

    super.initState();

    KeyboardVisibilityController().onChange.listen((isVisible) {
      setState(() {
        keyboardVisible = isVisible;
      });
    });
    controller = ScrollController();

    list = List.generate(4, (index) => null);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserProfile();
      getProjects();
    });

    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() {
          getMoreProjects();
        }); // if add this, Reload your futurebuilder and load more data
      }
    });

    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_logo');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.initialize(initializationSettings,
            onDidReceiveNotificationResponse: (details) {
          setNotificationAsRead(message.data['id']);
        });
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_logo',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        print('Tapped');

        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });

    init();

    getNotifications();
    // sendNotification();
  }

  init() async {
    String deviceToken = await getDeviceToken();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      String? title = remoteMessage.notification!.title;
      String? description = remoteMessage.notification!.body;
      String id = remoteMessage.data['id'];
      setNotificationAsRead(id);
    });
  }

  Future<void> getNotifications() async {
    final _dio = Dio();
    String? access_token;
    DateTime? formatted_updated_at;
    int count = 0;

    DateFormat format = DateFormat("yyyy-MM-dd hh:mm:ss");

    this.preferences = await SharedPreferences.getInstance();
    setState(() {
      access_token = this.preferences?.getString('access_token');
      count++;
    });

    this.preferences?.setInt('count', 0);

    try {
      Response response = await _dio.get(API.base_url + 'my/todo-notifications',
          options: Options(headers: {"authorization": "Bearer $access_token"}));
      Map result = response.data;

      if (response.statusCode == 200) {
        setState(() {
          notifications = response.data['data'];

          notifications
              .where((element) => element['is_read'] == 0)
              .forEach((element) {
            formatted_updated_at = format.parse(element['updated_at']);
            // final difference = formatted_updated_at
            //     ?.difference(DateTime.now())
            //     .inMinutes
            //     .abs();
            // print('The difference is ' + difference.toString());
            // if (difference! < 700) {
            // sendNotification(element['id'], element['notification']);
            // }
          });
        });
      }

      return null;
    } on DioError catch (e) {
      return null;
    }
  }

  Future<void> getUserProfile() async {
    final _dio = new Dio();
    this.preferences = await SharedPreferences.getInstance();
    setState(() {
      access_token = this.preferences?.getString('access_token');
    });
    try {
      Response response = await _dio.get(API.base_url + 'me',
          options: Options(headers: {"authorization": "Bearer $access_token"}));

      if (response.statusCode == 200) {
        this.preferences?.setBool('someoneLoggedIn', false);
        setState(() {
          user = response.data;
          user_id = user['id'].toString();
          saveDeviceID(user_id);
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

  Future<bool> saveDeviceID(String? userID) async {
    final _dio = new Dio();
    Map<String, dynamic> result = Map<String, dynamic>();

    setState(() {
      access_token = this.preferences?.getString('access_token');
    });

    try {
      final formData = FormData.fromMap({
        'user_id': userID,
        'device_token': await getDeviceToken(),
        'device_type': Platform.isIOS == true ? 'apple' : 'android'
      });
      Response response = await _dio.post(API.base_url + 'todo-user-token',
          data: formData,
          options: Options(headers: {
            "Content-type": "multipart/form-data",
            "authorization": "Bearer " + access_token.toString()
          }));
      print(response.data);
      if (response.statusCode == 200) {
        return true;
      } else
        return false;
    } on DioError catch (e) {
      print(e);
      return false;
    }
  }

  // Future<void> sendNotification(int id, String notification) async {
  //   var postUrl = "https://fcm.googleapis.com/fcm/send";

  //   var token = await getDeviceToken();

  //   final data = {
  //     "notification": {"body": "Tap to view details", "title": notification},
  //     "priority": "high",
  //     "data": {
  //       "click_action": "FLUTTER_NOTIFICATION_CLICK",
  //       "id": id,
  //       "status": "done"
  //     },
  //     "to": "$token"
  //   };

  //   final headers = {
  //     'content-type': 'application/json',
  //     'Authorization':
  //         'key=AAAASM8sfCA:APA91bFHBZYV2O1Xix8vA4XYVtUCeJbqNRoNypN2IWeXNcrulxJngCUDNWwGeVniEjy9ET9DQDJDdFuIh6VOTJpnDRXdvbM9lo59dYTiloqOwdOfhvZBy99VNiIz0ntQ7Mwc95-6VuXH'
  //   };

  //   BaseOptions options = new BaseOptions(
  //     connectTimeout: 5000,
  //     receiveTimeout: 3000,
  //     headers: headers,
  //   );

  //   try {
  //     final response = await Dio(options).post(postUrl, data: data);

  //     if (response.statusCode == 200) {
  //       // Fluttertoast.showToast(msg: 'Request Sent To Driver');
  //     } else {
  //       print('notification sending failed');
  //       // on failure do sth
  //     }
  //   } catch (e) {
  //     print('exception $e');
  //   }
  // }

  //get device token to use for push notification
  Future getDeviceToken() async {
    //request user permission for push notification
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging _firebaseMessage = FirebaseMessaging.instance;
    String? deviceToken = await _firebaseMessage.getToken();
    return (deviceToken == null) ? "" : deviceToken;
  }

  Future<void> getProjects() async {
    final _dio = Dio();
    _is_loading = true;

    this.preferences = await SharedPreferences.getInstance();
    setState(() {
      access_token = this.preferences?.getString('access_token');
    });

    try {
      Response response = await _dio.get(API.base_url + 'todo-projects',
          options: Options(headers: {"authorization": "Bearer $access_token"}));
      Map result = response.data;
      print('Status Code ' + response.statusCode.toString());

      if (response.statusCode == 200) {
        this.preferences?.setBool('someoneLoggedIn', false);
        setState(() {
          projects = response.data['data'];
          _is_loading = false;
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

  Future<void> getProjectsFromSearch(String search) async {
    final _dio = Dio();

    // Map<St  Future<void> getVehicles(String type) asyn2 {ring, dynamic> arrayTest;

    this.preferences = await SharedPreferences.getInstance();
    setState(() {
      access_token = this.preferences?.getString('access_token');
    });

    print('Access Token' + access_token.toString());
    try {
      Response response = await _dio.get(API.base_url + 'todo-projects',
          options: Options(headers: {"authorization": "Bearer $access_token"}));
      Map result = response.data;
      print('Status Code ' + response.statusCode.toString());

      if (response.statusCode == 200) {
        this.preferences?.setBool('someoneLoggedIn', false);
        setState(() {
          projects = response.data['data'];
          setSearchResults(search);
        });
        print(projects);
      }

      return null;
    } on DioError catch (e) {
      return null;
    }
  }

  Future<void> setNotificationAsRead(String notification_id) async {
    final _dio = new Dio();

    try {
      final formData = FormData.fromMap({
        'is_read': 1,
      });
      Response response =
          await _dio.post(API.base_url + 'todo-notification/$notification_id',
              data: formData,
              options: Options(headers: {
                "Content-type": "multipart/form-data",
                "authorization": "Bearer " + access_token.toString()
              }));
      print(response.data);
      if (response.statusCode == 200) {
        // BottomNavigationBar navigationBar =
        //     bottomWidgetKey.currentWidget as BottomNavigationBar;
        // navigationBar.onTap!(2);
      }
    } on DioError catch (e) {
      print(e);
      return null;
    }
  }

  getMoreProjects() {
    for (int i = current_max; i < current_max + 4; i++) {
      list.add(i + 2);
    }

    setState(() {
      current_max = current_max + 4;
    });
  }

  show_loading() async {
    setState(() {
      _is_loading = true;
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (this.mounted)
        setState(() {
          _is_loading = false;
        });
    });
  }

  Future _pickOrDeleteImage() async {
    final ImagePicker _picker = ImagePicker();
    final img = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = img;
    });
    if (img != null)
      setState(() {
        picked = true;
      });
    else
      setState(() {
        picked = false;
      });
    _addProjectModalBottomSheet(context);
    print(picked);
  }

  Future<bool> saveProject() async {
    final _dio = new Dio();

    final path = image!.path;
    var fileName = (image!.path.split('/').last);

    final bytes = await File(path).readAsBytesSync();

    // print('before ' + bytes.length.toString());
    final compressed_bytes = await FlutterImageCompress.compressWithList(
        bytes.buffer.asUint8List(),
        quality: 85,
        minWidth: 800,
        minHeight: 500);

    try {
      final formData = FormData.fromMap({
        'title': txtProjectName,
        'description': txtProjectDesc,
        'start_date': formatted_start_date,
        'end_date': formatted_end_date,
        'color_code': '#FFF',
        'logo':
            await MultipartFile.fromBytes(compressed_bytes, filename: fileName),
      });
      Response response = await _dio.post(API.base_url + 'todo-projects',
          data: formData,
          options: Options(headers: {
            "Content-type": "multipart/form-data",
            "authorization": "Bearer " + access_token.toString()
          }));
      print(response.data);
      if (response.statusCode == 200) {
        return true;
      } else
        return false;
    } on DioError catch (e) {
      print(e);
      return false;
    }
  }

  void setSearchResults(String query) {
    setState(() {
      _is_loading = true;
      projects = projects
          .where((elem) =>
              elem['title']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              elem['description']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
      _is_loading = false;
    });
  }

  void _addProjectModalBottomSheet(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
        builder: (context) {
          return StatefulBuilder(builder:
              (BuildContext context, void Function(void Function()) setState) {
            return Container(
              height: 600.0,
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      'PROJECT NAME',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0),
                    ),
                  ),
                  Container(
                    child: TextField(
                      controller: txtProjectNameController,
                      onChanged: (value) {
                        setState(() {
                          txtProjectName = value.toString();
                        });
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
                        if (picked == false)
                          Container(
                            padding: EdgeInsets.only(right: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                _pickOrDeleteImage();
                              },
                              child: Image(
                                image:
                                    AssetImage('assets/plus_add_project.png'),
                              ),
                            ),
                          ),
                        if (picked == true)
                          Container(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Image.file(
                              File(image!.path),
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                            ),
                          ),

                        // Container(
                        //   padding: EdgeInsets.only(right: 20.0),
                        //   child: image != null
                        //       ? Image.file(
                        //           File(image!.path),
                        //           width: 50.0,
                        //           height: 50.0,
                        //           fit: BoxFit.cover,
                        //         )
                        //       : GestureDetector(
                        //           onTap: () {
                        //             _pickOrDeleteImage();
                        //           },
                        //           child: Image(
                        //             image: AssetImage(
                        //                 'assets/plus_add_project.png'),
                        //           ),
                        //         ),
                        // ),
                        image != null
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    image = null;
                                    picked = false;
                                  });
                                },
                                icon: Icon(Icons.delete))
                            : AutoSizeText('Add Project Thumbnail')
                      ],
                    ),
                  ),
                  Container(
                    child: Text(
                      'Description',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0),
                    ),
                  ),
                  Container(
                    child: TextField(
                      controller: txtProjectDescController,
                      onChanged: (value) {
                        setState(() {
                          txtProjectDesc = value.toString();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Description',
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      'Duration',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0),
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
                            DateTimeRangePicker(
                                startText: "From",
                                endText: "To",
                                doneText: "Yes",
                                cancelText: "Cancel",
                                interval: 5,
                                initialStartTime: DateTime.now(),
                                initialEndTime:
                                    DateTime.now().add(Duration(days: 20)),
                                mode: DateTimeRangePickerMode.dateAndTime,
                                minimumTime:
                                    DateTime.now().subtract(Duration(days: 5)),
                                maximumTime:
                                    DateTime.now().add(Duration(days: 365)),
                                use24hFormat: false,
                                onConfirm: (start, end) {
                                  formatted_start_date =
                                      DateFormat('dd/MM/yyyy HH:mm')
                                          .format(start);
                                  formatted_end_date =
                                      DateFormat('dd/MM/yyyy HH:mm')
                                          .format(end);

                                  setState(() {
                                    duration_selected = true;
                                    print(formatted_end_date);
                                  });
                                }).showPicker(context);
                            print(formatted_end_date);
                            print(formatted_start_date);
                          },
                          child: Container(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Image(
                              image: AssetImage('assets/due_date_icon.png'),
                            ),
                          ),
                        ),
                        duration_selected
                            ? AutoSizeText(formatted_end_date!)
                            : AutoSizeText('Select Duration')
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      width: width * 0.3,
                      height: 38.0,
                      child: TextButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            side: BorderSide(color: ColorsTheme.txtDescColor),
                            borderRadius: BorderRadius.circular(14.0),
                          )),
                          foregroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered) ||
                                states.contains(MaterialState.focused))
                              return Colors.white;
                            return Colors.white;
                          }),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                            if (states.contains(MaterialState.hovered) ||
                                states.contains(MaterialState.focused))
                              return ColorsTheme.btnColor;

                            return ColorsTheme.btnColor;
                          }),
                        ),
                        child: Text('Create'),
                        onPressed: () async {
                          bool result = false;
                          if (txtProjectDesc.isNotEmpty &&
                              txtProjectName.isNotEmpty &&
                              picked &&
                              duration_selected) {
                            result = await saveProject();
                            if (result == true) {
                              Navigator.of(context).pop();
                              Fluttertoast.showToast(
                                  msg: "Project Added!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: ColorsTheme.btnColor,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              getProjects();
                            } else
                              Fluttertoast.showToast(
                                  msg: "Something went wrong!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: ColorsTheme.dangerColor,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                          } else
                            Fluttertoast.showToast(
                                msg: "Any field is missing!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: ColorsTheme.dangerColor,
                                textColor: Colors.white,
                                fontSize: 16.0);
                        },
                      ),
                    ),
                  )
                ],
              ),
            );
          });
        });
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
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: false,
          elevation: 0,
          // title: Column(
          //   children: [
          //     Text(
          //       'MFA Projects',
          //       style:
          //           kkBoldTextStyle().copyWith(fontSize: 24, color: darkGrey),
          //     ),
          //     Text(
          //       '${projects.length} Projects',
          //       style: kkTextStyle().copyWith(color: Colors.grey),
          //     ),
          //   ],
          // ),
          // actions: [
          //   GestureDetector(
          //     onTap: () {
          //       if (this.mounted)
          //         setState(() {
          //           if (is_search_visible == true)
          //             setState(() {
          //               is_search_visible = false;
          //             });
          //         });
          //     },
          //     child: Container(
          //       child: Image(image: AssetImage('assets/icon_search.png')),
          //     ),
          //   )
          // ],
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

                            child: new RichText(
                                text: new TextSpan(children: [
                              new TextSpan(
                                  text: 'MFA Projects \n',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600)),
                              new TextSpan(
                                  text: '${projects.length} Projects',
                                  style: TextStyle(
                                      color: ColorsTheme.txtDescColor))
                            ])),
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
                                    getProjectsFromSearch(search_query);
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

        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            // height: orientation == Orientation.portrait
            //     ? height * 0.9
            //     : height * 2.6,
            width: width,
            child: Column(children: <Widget>[
              // is_search_visible == true
              //     ? Container(
              //         padding: EdgeInsets.only(
              //             left: 30, right: 30, top: 40, bottom: 10),
              //         margin: EdgeInsets.only(top: 40.0),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: <Widget>[
              //             Container(
              //               // padding: EdgeInsets.all(50.0),

              //               child: new RichText(
              //                   text: new TextSpan(children: [
              //                 new TextSpan(
              //                     text: 'MFA Projects \n',
              //                     style: TextStyle(
              //                         color: Colors.black,
              //                         fontSize: 20.0,
              //                         fontWeight: FontWeight.w600)),
              //                 new TextSpan(
              //                     text: '${projects.length} Projects',
              //                     style: TextStyle(
              //                         color: ColorsTheme.txtDescColor))
              //               ])),
              //             ),
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
              //                     image:
              //                         AssetImage('assets/icon_search.png')),
              //               ),
              //             )
              //           ],
              //         ),
              //       )
              //     : Container(
              //         padding: EdgeInsets.all(40.0),
              //         margin: EdgeInsets.only(top: 20.0),
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
              //                       getProjectsFromSearch(search_query);
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
              //                 print(search_query);
              //               },
              //               child: Container(
              //                 child: Image(
              //                     image:
              //                         AssetImage('assets/icon_search.png')),
              //               ),
              //             )
              //           ],
              //         ),
              //       ),
              if (projects.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(10.0),
                  height: height,
                  child: ListView.builder(
                      // controller: controller,
                      itemCount: projects.length,
                      // shrinkWrap: true,
                      // itemExtent: 105.0,
                      itemBuilder: (BuildContext context, index) {
                        if (index == list.length && _is_loading == true)
                          return Center(
                              child: CircularProgressIndicator(
                            color: ColorsTheme.btnColor,
                          ));
                        return GestureDetector(
                          onTap: () async {
                            this.preferences =
                                await SharedPreferences.getInstance();
                            this
                                .preferences
                                ?.setInt('project_id', projects[index]['id']);
                            this.preferences?.setString(
                                'logo_url', projects[index]['logo_url']);
                            this.preferences?.setString(
                                'project_title', projects[index]['title']);

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProjectDetails()));
                          },
                          child: ListTile(
                            title: Container(
                              padding: EdgeInsets.only(right: 20),
                              // height: 90.0,
                              width: double.infinity,
                              // width: width * 0.85,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                      color: Color.fromARGB(255, 207, 205, 205),
                                      width: 1.0)),
                              child: Row(
                                // crossAxisAlignment:
                                //     CrossAxisAlignment.center,
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          width: 60,
                                          height: 40,
                                          child: projects[index]['logo_url'] ==
                                                  ''
                                              ? Image.asset(
                                                  'assets/sample_logo.png')
                                              : Image.network(
                                                  projects[index]['logo_url'],
                                                  fit: BoxFit.fill,
                                                ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(10.0),
                                            margin: EdgeInsets.only(top: 15.0),
                                            width: width * 0.4,
                                            // width: double.infinity,
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    projects[index]['title'],
                                                    maxLines: 1,
                                                    style: kkBoldTextStyle()
                                                        .copyWith(fontSize: 20),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  AutoSizeText(
                                                    projects[index]
                                                        ['description'],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.0),
                                                  ),
                                                ]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  maxWidthSpan(),
                                  // SizedBox(
                                  //   width: orientation ==
                                  //           Orientation.portrait
                                  //       ? width * 0.18
                                  //       : width * 0.3,
                                  // ),
                                  InkWell(
                                    onTap: () {},
                                    child: Image(
                                      image: AssetImage(
                                          'assets/arrow_details.png'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),

              if (_is_loading == true && projects.isEmpty)
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(top: height * 0.3),
                  // margin: EdgeInsets.only(to),
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(ColorsTheme.btnColor),
                  ),
                ),
              if (_is_loading == false && projects.length == 0)
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(top: height * 0.3),
                  // margin: EdgeInsets.only(to),
                  child: Text(
                    'No Project Found',
                  ),
                ),
            ]),
          ),
        ),

        // floatingActionButton: Visibility(
        //   visible: !keyboardVisible,
        //   child: GestureDetector(
        //     onTap: () {
        //       _addProjectModalBottomSheet(context);
        //     },
        //     child: Container(
        //       // margin: EdgeInsets.only(bottom: 40.0),
        //       height: 100,
        //       width: 100,
        //       decoration: BoxDecoration(
        //           image: DecorationImage(
        //               image: AssetImage('assets/tasks_floating_button.png'))),
        //     ),
        //   ),
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
            backgroundColor: blueColor,
            child: Image.asset('assets/add_project.png'),
            onPressed: () {
              _addProjectModalBottomSheet(context);
            }),
      ),
    );
  }
}
