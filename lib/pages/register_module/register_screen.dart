import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gigX/colors.dart';
import 'package:gigX/constant/constants.dart';
import 'package:gigX/login.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: kStandardPadding(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.07,
            ),
            Text(
              'Create a new Account!',
              style: kkBoldTextStyle()
                  .copyWith(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            LSizedBox(),
            LSizedBox(),
            Text(
              'FULL NAME*',
              style: kBoldTextStyle(),
            ),
            sSizedBox(),
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Enter your name', focusColor: ColorsTheme.btnColor
                  // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: ColorsTheme.btnColor))
                  ),
            ),
            LSizedBox(),
            Text(
              'Email*',
              style: kBoldTextStyle(),
            ),
            sSizedBox(),
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Enter your email', focusColor: ColorsTheme.btnColor
                  // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: ColorsTheme.btnColor))
                  ),
            ),
            LSizedBox(),
            Text(
              'PHONE NUMBER*',
              style: kBoldTextStyle(),
            ),
            sSizedBox(),
            IntrinsicHeight(
              child: Row(
                children: [
                  Text(
                    '+67',
                    style: kTextStyle(),
                  ),
                  // minWidthSpan(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: VerticalDivider(color: Colors.black),
                  ),
                  // minWidthSpan(),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: '000 0000 0000',
                          focusColor: ColorsTheme.btnColor
                          // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: ColorsTheme.btnColor))
                          ),
                    ),
                  ),
                ],
              ),
            ),
            LSizedBox(),
            Text(
              'PASSWORD*',
              style: kBoldTextStyle(),
            ),
            sSizedBox(),
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Enter your password',
                  focusColor: ColorsTheme.btnColor
                  // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: ColorsTheme.btnColor))
                  ),
            ),
            LSizedBox(),
            Text(
              'CONFIRM PASSWORD*',
              style: kBoldTextStyle(),
            ),
            sSizedBox(),
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Re-enter your password',
                  focusColor: ColorsTheme.btnColor
                  // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: ColorsTheme.btnColor))
                  ),
            ),
            LSizedBox(),
            LSizedBox(),
            Container(
              // width: orientation == Orientation.portrait
              width: double.infinity,
              // : width * 0.91,
              height: 50.0,
              child: TextButton(
                onPressed: () async {
                  // is_logged_in = await login();

                  // if (is_logged_in) {
                  //   Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (context) => Home(),
                  //       fullscreenDialog: true));
                  // }
                },
                style: ButtonStyle(
                    alignment: Alignment.center,
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                    backgroundColor:
                        MaterialStateProperty.all(ColorsTheme.btnColor)),
                child: AutoSizeText(
                  'Register',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            LSizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account?',
                  style: kTextStyle().copyWith(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Text(
                    ' Login',
                    style: kTextStyle().copyWith(
                      color: ColorsTheme.btnColor,
                    ),
                  ),
                ),
              ],
            ),
            LSizedBox(),
            LSizedBox(),
            Center(
              child: Text(
                'By signing up, you are agreeing to our Terms\n & Conditions and Privacy Policy.',
                style: kTextStyle().copyWith(fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
