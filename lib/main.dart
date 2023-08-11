import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gigX/appRoute/appRoute.dart';
import 'package:gigX/colors.dart';
import 'package:gigX/constant/constants.dart';
import 'package:gigX/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gigX/model/home_model.dart';
import 'package:gigX/service/local_storage_service.dart';
import 'package:gigX/view/login_view.dart';
import 'package:oktoast/oktoast.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // NotificationService().initNotification();
  // NotificationService().requestIOSPermissions();
  await LocalStorageService.init();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool isDark = LocalStorageService().readBool(LocalStorageKeys.isDark)!;
    return OKToast(
      child: GetMaterialApp(
        theme:
            isDark ? customDarkTheme : customLightTheme, // Default light theme
        darkTheme: customDarkTheme, // Default dark theme
        themeMode: ThemeMode.system,
        title: 'Main Page',
        debugShowCheckedModeBanner: false,

        // home: LoginPage(is_logged_out: false),
        home: LoginView(),
        getPages: AppRoute.getRoutes(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

final ThemeData customLightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  // hintColor: primaryColor,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    color: Colors.white, // Appbar color
    iconTheme: IconThemeData(color: Colors.grey[800]),
    // Icon color
    foregroundColor: Colors.black,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white, // BottomNavBar color
    selectedItemColor: ColorsTheme.btnColor, // Selected item color
    unselectedItemColor: Colors.grey, // Unselected item color
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: ColorsTheme.btnColor, // FAB color
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: ColorsTheme.btnColor, // Button color
    textTheme: ButtonTextTheme.primary,
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(color: Colors.grey[800]), // Body text color
    bodyText2: TextStyle(color: Colors.grey[800]),
    subtitle1: TextStyle(color: Colors.grey[800]), // Subtitle color
    subtitle2: TextStyle(color: Colors.grey[800]),
    button: TextStyle(color: Colors.white), // Button text color
  ),
  inputDecorationTheme: InputDecorationTheme(
    // Change the border color for all InputDecorations
    labelStyle: TextStyle(color: blueColor),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: primaryColor, // Change this color to the desired color
        width: 1.0, // Change the border width if needed
      ),
    ),
  ),
  
);

final ThemeData customDarkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: buttonColor,

  scaffoldBackgroundColor: Colors.grey[900], // Dark background color
  appBarTheme: AppBarTheme(
      color: Color(0xff303131), // Appbar color
      iconTheme: IconThemeData(color: Colors.white),
      foregroundColor: Colors.white // Icon color

      ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xff303131), // BottomNavBar color
    selectedItemColor: buttonColor, // Selected item color
    unselectedItemColor: Colors.grey[400], // Unselected item color
  ),
  floatingActionButtonTheme:
      FloatingActionButtonThemeData(backgroundColor: buttonColor // FAB color
          ),
  buttonTheme: ButtonThemeData(
    buttonColor: buttonColor, // Button color
    textTheme: ButtonTextTheme.primary,
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(color: buttonColor),
    // Change the border color for all InputDecorations
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Colors.white,
        width: 1,
      )
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: buttonColor, // Change this color to the desired color
        width: 1.0, // Change the border width if needed
      ),
    ),
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(color: Colors.white), // Body text color
    bodyText2: TextStyle(color: Colors.white),
    subtitle1: TextStyle(color: Colors.white), // Subtitle color
    subtitle2: TextStyle(color: Colors.white),
    button: TextStyle(color: Colors.white), // Button text color
  ),
);
