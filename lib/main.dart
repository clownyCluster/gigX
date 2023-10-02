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
    bool isDark =
        LocalStorageService().readBool(LocalStorageKeys.isDark) ?? false;
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
  hintColor: primaryColor,
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
    bodyLarge:
        TextStyle(color: Colors.grey[800], fontSize: 14), // Body text color
    bodyMedium: TextStyle(color: Colors.grey[700], fontSize: 12),
    bodySmall: TextStyle(color: Colors.grey, fontSize: 10),
    titleSmall: TextStyle(color: Colors.grey[700], fontSize: 10),
    titleMedium:
        TextStyle(color: Colors.grey[800], fontSize: 12), // Subtitle color
    titleLarge: TextStyle(color: Colors.grey, fontSize: 14),
    labelMedium: TextStyle(
        color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(color: Colors.grey, fontSize: 10),

    labelLarge: TextStyle(color: Colors.grey[800], fontSize: 14),
    // Button text color
  ),
  // inputDecorationTheme: InputDecorationTheme(
  //   // Change the border color for all InputDecorations
  //   isDense: true,
  //   labelStyle: TextStyle(color: blueColor),
  //   border: OutlineInputBorder(
  //     borderRadius: BorderRadius.circular(10),
  //   ),
  //   focusedBorder: OutlineInputBorder(
  //     borderRadius: BorderRadius.circular(10),
  //     borderSide: BorderSide(
  //       color: primaryColor, // Change this color to the desired color
  //       width: 1.0, // Change the border width if needed
  //     ),
  //   ),
  // ),

  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(color: primaryColor),
    // Change the border color for all InputDecorations
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey,
          width: 1,
        )),
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
        )),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: buttonColor, // Change this color to the desired color
        width: 1.0, // Change the border width if needed
      ),
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white, fontSize: 14), // Body text color
    bodyMedium: TextStyle(color: Colors.white, fontSize: 12),
    bodySmall: TextStyle(color: Colors.white, fontSize: 10),
    titleMedium: TextStyle(color: Colors.white, fontSize: 12), // Subtitle color
    titleSmall: TextStyle(color: Colors.white, fontSize: 10),
    titleLarge: TextStyle(color: Colors.white, fontSize: 14),
    labelMedium: TextStyle(
        color: Colors.grey[800], fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(color: Colors.white, fontSize: 10),

    labelLarge:
        TextStyle(color: Colors.white, fontSize: 14), // Button text color
  ),
);
