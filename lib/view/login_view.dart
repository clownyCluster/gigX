import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigX/appRoute/routeName.dart';
import 'package:gigX/service/local_storage_service.dart';
import 'package:gigX/view_model/login_view_model.dart';

import '../colors.dart';
import '../constant/constants.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final state = Get.put(LoginViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    state.emailController.value.text =
        LocalStorageService().read(LocalStorageKeys.email) ?? '';
    state.passwordController.value.text =
        LocalStorageService().read(LocalStorageKeys.password) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return SingleChildScrollView(
          child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 50.0),
              width: Get.width * 0.8,
              height: 120,
              alignment: Alignment.bottomCenter,
              child: Image(
                image: AssetImage('assets/logo_title.png'),
                fit: BoxFit.contain,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 60.0,
                  ),
                  AutoSizeText(
                    'EMAIL',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                  kSizedBox(),
                  TextField(
                    controller: state.emailController.value,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Enter your email',
                    ),
                    onChanged: (value) {
                      setState(() {
                        // email = value.toString();
                      });
                    },
                  ),
                  LSizedBox(),
                  AutoSizeText(
                    'PASSWORD',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                  kSizedBox(),
                  Obx(
                    () => TextField(
                        controller: state.passwordController.value,
                        obscureText: state.isPasswordVisible.value,
                        keyboardType: TextInputType.visiblePassword,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                            labelText: 'Enter your password',
                            isDense: true,
                            suffixIcon: IconButton(
                              iconSize: 20.0,
                              onPressed: () {
                                state.onVIsibilityChanged();
                              },
                              icon: state.isPasswordVisible.value
                                  ? Icon(
                                      Icons.visibility,
                                      color: Colors.grey,
                                    )
                                  : Icon(Icons.visibility_off),
                            ))),
                  ),
                  Row(
                    mainAxisAlignment: orientation == Orientation.portrait
                        ? MainAxisAlignment.spaceAround
                        : MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Obx(
                              () => Container(
                                child: Checkbox(
                                  value: state.stayLoggedIn.value,
                                  onChanged: (value) async {
                                    // this.preferences =
                                    //     await SharedPreferences.getInstance();
                                    // setState(() {
                                    //   stay_logged_in = value!;
                                    // });

                                    // this.preferences?.setBool(
                                    //     'stay_logged_in', stay_logged_in);
                                    state.onStayLoggedInChanged(value);
                                  },
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                'Stay Logged In?',
                                style: TextStyle(fontSize: 12.0),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: AutoSizeText(
                            'Forgot Password?',
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                      )
                    ],
                  ),
                  LSizedBox(), // ya bata suru gareko
                  Obx(() => ElevatedButton(
                        onPressed: () async {
                          state.login();
                        },
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(vertical: 15)),
                            alignment: Alignment.center,
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
                            backgroundColor:
                                MaterialStateProperty.all(state.isLoading.value
                                    ? Get.isDarkMode
                                        ? buttonColor.withOpacity(0.5)
                                        : ColorsTheme.btnColor.withOpacity(0.5)
                                    : Get.isDarkMode
                                        ? buttonColor
                                        : ColorsTheme.btnColor)),
                        child: Center(
                          child: state.isLoading.value
                              ? CircularProgressIndicator(
                                  color: whiteColor,
                                )
                              : AutoSizeText(
                                  'Sign In',
                                  style: TextStyle(
                                      color: Get.isDarkMode
                                          ? Colors.grey[700]
                                          : Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                ),
                        ),
                        // :
                      )),
                  LSizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account yet? ',
                        style: TextStyle().copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.toNamed(RouteName.registerScreen);
                        },
                        child: Text(
                          'Register here',
                          style: kTextStyle().copyWith(
                              color: state.isDark.value
                                  ? Color.fromARGB(255, 196, 210, 217)
                                  : ColorsTheme.btnColor,
                              decoration: TextDecoration.underline),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  LSizedBox(),
                  Row(
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
                                fontSize: 13.0, fontWeight: FontWeight.w400),
                          ),
                        ),
                        Container(
                          child:
                              Image(image: AssetImage('assets/login_line.png')),
                        )
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          state.authenticateFaceID();
                        },
                        child: ImageIcon(
                          AssetImage(
                            'assets/face_id_icon.png',
                          ),
                          size: 200,
                          color: Get.isDarkMode ? whiteColor : primaryColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ]),
        );
      }),
    );
  }
}
