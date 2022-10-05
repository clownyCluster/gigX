import 'package:auto_size_text/auto_size_text.dart';
import 'package:efleet_project_tree/colors.dart';
import 'package:efleet_project_tree/home.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
      home: const LoginPage(),
    );
  }
}

var height, width;
bool stay_logged_in = false, is_password_hidden = true;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final textFieldFocusNode = FocusNode();

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Container(
                    //   margin: EdgeInsets.only(top: 40.0),
                    //   padding: EdgeInsets.all(20.0),
                    //   child: IconButton(
                    //     onPressed: () {},
                    //     icon: Icon(
                    //       Icons.arrow_back,
                    //       color: Colors.black,
                    //     ),
                    //   ),
                    // ),
                    Container(
                      margin: EdgeInsets.only(top: 60.0),
                      alignment: Alignment.center,
                      child: Image(image: AssetImage('assets/logo_title.png')),
                    ),
                    SizedBox(
                      height: 90.0,
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
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Enter your email',
                        ),
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
                          obscureText: is_password_hidden,
                          keyboardType: TextInputType.visiblePassword,
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
                                    onChanged: (value) {
                                      setState(() {
                                        stay_logged_in = value!;
                                      });
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
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Home()));
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
                  padding: EdgeInsets.all(10.0),
                  child: new RichText(
                      maxLines: 1,
                      text: new TextSpan(children: [
                        new TextSpan(
                          text: 'Don’t have an account yet? Register ',
                          style: TextStyle(
                              color: Colors.black,
                              letterSpacing: -0.8,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400),
                        ),
                        new TextSpan(
                          text: 'here',
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () => print('Go to register'),
                          style: TextStyle(
                              color: ColorsTheme.btnColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400),
                        )
                      ]))),
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
              Center(
                child: Image(image: AssetImage('assets/face_id_icon.png')),
              )
            ]),
          ),
        );
      }),
    );
  }
}
