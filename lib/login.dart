import 'dart:developer';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:efleet_project_tree/api.dart';
import 'package:efleet_project_tree/colors.dart';
import 'package:efleet_project_tree/home.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: ColorsTheme.bgColor),
      home: LoginPage(
        is_logged_out: false,
      ),
    );
  }
}

var height, width;
bool stay_logged_in = false, is_password_hidden = true;
var email, password;
bool is_logged_in = false;
bool? is_logged_out = false;

class LoginPage extends StatefulWidget {
  bool is_logged_out;
  LoginPage({required this.is_logged_out, super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  SharedPreferences? preferences;
  final textFieldFocusNode = FocusNode();
  TextEditingController txtEmailController = new TextEditingController();
  TextEditingController txtPasswordController = new TextEditingController();
  final storage = new FlutterSecureStorage();
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializePrefs();
      checkIfOtherLoggedIn();
      checkIfLoggedIn();
    });
  }

  Future<bool> login() async {
    this.preferences = await SharedPreferences.getInstance();
    await storage.write(key: 'email', value: txtEmailController.text);
    await storage.write(key: 'password', value: txtPasswordController.text);
    var base_url = API.base_url;
    String access_token;
    final _dio = new Dio();

    try {
      var map = new Map<String, dynamic>();
      map['grant_type'] = 'password';
      // map['client_id'] = '14';
      // map['client_secret'] = 'PYZTnOaDfJWM0X9eyIUlXZMJU1z6ZKkAEtLHlbiI';
      map['client_id'] = '20';
      map['client_secret'] = 'VDt8JhTzNdBrCWoKTwWNGOw0SQ5bPg99J2HI2BLL';
      // email = 'leonardo@myfleetmanager.com.au';
      // password = 'Efleet@02dev';
      map['username'] = email;
      map['password'] = password;

      Response response = await _dio.post(
        base_url + 'oauth/token',
        data: map,
      );
      Map result = response.data;
      access_token = result['access_token'];

      this.preferences?.setString('access_token', access_token);

      return (response.statusCode == 200) ? true : false;
    } catch (error) {
      if (txtEmailController.text.isEmpty &&
          txtPasswordController.text.isEmpty) {
        Fluttertoast.showToast(
            msg: "Email or password can't be empty",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: ColorsTheme.btnColor,
            textColor: Colors.white,
            fontSize: 16.0);
        return false;
      } else
        Fluttertoast.showToast(
            msg: "Invalid Credentials",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: ColorsTheme.btnColor,
            textColor: Colors.white,
            fontSize: 16.0);
      print(error.toString());
      return false;
    }
  }

  Future<void> initializePrefs() async {
    this.preferences = await SharedPreferences.getInstance();
    is_logged_out = this.preferences?.getBool('is_logged_out');
    email = await storage.read(key: 'email') ?? '';
    password = await storage.read(key: 'password') ?? '';

    txtEmailController = new TextEditingController(text: email);
    txtPasswordController = new TextEditingController(text: password);
    print(email);
  }

  Future<void> checkIfOtherLoggedIn() async {
    bool? some_one_logged_in = false;
    this.preferences = await SharedPreferences.getInstance();
    some_one_logged_in = this.preferences?.getBool('someoneLoggedIn');
    if (some_one_logged_in == true) {
      this.preferences?.setBool('someoneLoggedIn', false);

      Fluttertoast.showToast(
          msg:
              'You are trying to login into an account that is currently in used!',
          gravity: ToastGravity.CENTER,
          backgroundColor: ColorsTheme.btnColor,
          timeInSecForIosWeb: 3,
          textColor: Colors.white);
    }
  }

  Future<void> checkIfLoggedIn() async {
    print(this.preferences?.getBool('stay_logged_in'));

    if (this.preferences?.getBool('stay_logged_in') == true &&
        widget.is_logged_out == false) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Home(), fullscreenDialog: true));
    }
  }

  Future<void> authenticateFaceID() async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    bool isBiometricSupported = await auth.isDeviceSupported();

    bool canCheckBiometrics = await auth.canCheckBiometrics;

    try {
      if (isBiometricSupported) {
        print(isBiometricSupported);
        print(canCheckBiometrics);

        if (Platform.isIOS) {
          bool pass = await auth.authenticate(
              localizedReason: 'Authenticate with fingerprint',
              options: AuthenticationOptions(
                  biometricOnly: true,
                  stickyAuth: true,
                  useErrorDialogs: true));

          if (pass) {
            bool result;

            result = await login();

            if (result == true) {
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const Home();
                  },
                ),
                (_) => false,
              );
            } else
              Fluttertoast.showToast(
                  msg: "Something went wrong!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: ColorsTheme.dangerColor,
                  textColor: Colors.white,
                  fontSize: 16.0);
          }
        } else {
          bool pass = await auth.authenticate(
              localizedReason: 'Authenticate with fingerprint/face',
              options: AuthenticationOptions(
                  biometricOnly: true,
                  stickyAuth: true,
                  useErrorDialogs: true));
          if (pass) {
            bool result;

            txtEmailController.text = await storage.read(key: 'email') ?? '';
            txtPasswordController.text =
                await storage.read(key: 'password') ?? '';

            result = await login();

            print(result);

            if (result == true) {
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const Home();
                  },
                ),
                (_) => false,
              );
            }
          } else {
            Fluttertoast.showToast(
                msg: "Something went wrong!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: ColorsTheme.dangerColor,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
      } else {
        Fluttertoast.showToast(
            msg: "Sorry! your device doesn't support face id",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: ColorsTheme.dangerColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on PlatformException catch (e) {
      print('denied');
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
            height: orientation == Orientation.portrait ? height : height * 2.6,
            width: width,
            child: Column(children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 80.0),
                width: width * 0.8,
                height: 120,
                alignment: Alignment.bottomCenter,
                child: Image(
                  image: AssetImage('assets/logo_title.jpg'),
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 60.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 40.0, right: 40.0),
                      child: AutoSizeText(
                        'EMAIL',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 40.0, right: 40.0),
                      child: TextField(
                        controller: txtEmailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Enter your email',
                        ),
                        onChanged: (value) {
                          setState(() {
                            email = value.toString();
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 40.0, right: 40.0),
                      margin: EdgeInsets.only(top: 50.0),
                      child: AutoSizeText(
                        'PASSWORD',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 40.0, right: 40.0),
                      child: TextField(
                          controller: txtPasswordController,
                          obscureText: is_password_hidden,
                          keyboardType: TextInputType.visiblePassword,
                          onChanged: (value) {
                            setState(() {
                              password = value.toString();
                            });
                          },
                          decoration: InputDecoration(
                              labelText: 'Enter your password',
                              isDense: true,
                              suffixIcon: IconButton(
                                iconSize: 40.0,
                                onPressed: () {
                                  setState(() {
                                    is_password_hidden = !is_password_hidden;
                                  });
                                },
                                icon: Icon(is_password_hidden == true
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ))),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: orientation == Orientation.portrait
                            ? MainAxisAlignment.spaceAround
                            : MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Checkbox(
                                    value: stay_logged_in,
                                    onChanged: (value) async {
                                      this.preferences =
                                          await SharedPreferences.getInstance();
                                      setState(() {
                                        stay_logged_in = value!;
                                      });

                                      this.preferences?.setBool(
                                          'stay_logged_in', stay_logged_in);
                                    },
                                  ),
                                ),
                                Container(
                                  child: AutoSizeText(
                                    'Stay Logged In?',
                                    style: TextStyle(
                                        color: ColorsTheme.txtDescColor,
                                        fontSize: 12.0),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: AutoSizeText(
                              'Forgot Password?',
                              style: TextStyle(
                                  color: ColorsTheme.txtDescColor,
                                  fontSize: 12.0),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: orientation == Orientation.portrait
                    ? width * 0.82
                    : width * 0.91,
                height: 48.0,
                child: TextButton(
                  onPressed: () async {
                    is_logged_in = await login();

                    if (is_logged_in) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Home(),
                          fullscreenDialog: true));
                    }
                  },
                  style: ButtonStyle(
                      alignment: Alignment.center,
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0))),
                      backgroundColor:
                          MaterialStateProperty.all(ColorsTheme.btnColor)),
                  child: AutoSizeText(
                    'Sign In',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 20.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child:
                            Image(image: AssetImage('assets/login_line.png')),
                      ),
                      Container(
                        child: AutoSizeText(
                          'Or login with',
                          style: TextStyle(
                              color: ColorsTheme.txtDescColor,
                              fontSize: 13.0,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Container(
                        child:
                            Image(image: AssetImage('assets/login_line.png')),
                      )
                    ]),
              ),
              GestureDetector(
                onTap: () {
                  authenticateFaceID();
                },
                child: Center(
                  child: Image(image: AssetImage('assets/face_id_icon.png')),
                ),
              )
            ]),
          ),
        );
      }),
    );
  }
}
