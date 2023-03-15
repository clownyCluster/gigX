import 'package:flutter/material.dart';

SizedBox kSizedBox() => SizedBox(
      height: 10,
    );
SizedBox MSizedBox() => SizedBox(
      height: 15,
    );
SizedBox LSizedBox() => SizedBox(
      height: 20,
    );

SizedBox sSizedBox() => SizedBox(
      height: 5,
    );
SizedBox minWidthSpan() => const SizedBox(
      width: 5,
    );
SizedBox maxWidthSpan() => const SizedBox(
      width: 10,
    );
SizedBox largeWidthSpan() => const SizedBox(
      width: 20,
    );

EdgeInsets kStandardPadding() =>
    const EdgeInsets.symmetric(horizontal: 20, vertical: 10);

EdgeInsets kPadding() => const EdgeInsets.all(10);
EdgeInsets kVerticalPadding() => const EdgeInsets.symmetric(vertical: 10);

showLogoutConfirmationDialog(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.all(Radius.circular(10.0))),
              // insetPadding: EdgeInsets.zero,
              title: Text('Log Out!', style: kBoldTextStyle()),
              content: const Text('Are you sure you want to logout?'),

              actions: <Widget>[
                TextButton(
                  child: Text(
                    "Cancel",
                    style: kTextStyle().copyWith(color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                    child: Text(
                      'Log Out',
                      style: kTextStyle().copyWith(color: primaryColor),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      // userResponse.remove('userResponse');
                      // Navigator.pushNamed(context, LoginScreen.id);
                      // Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => false,);
                    }),
              ],
            );
          },
        );
      });
}

AppBar defaultAppBar(String title) {
  return AppBar(
    elevation: 0,
    centerTitle: true,
    title: Text(
      title,
      style: kkWhiteBoldTextStyle(),
    ),
    backgroundColor: primaryColor,
  );
}

TextStyle kTextStyle() => TextStyle(
      fontFamily: 'QuickSand',
      fontSize: 14,
      color: Colors.grey[700],
      fontWeight: FontWeight.w300,
    );

TextStyle kkTextStyle() => TextStyle(
      // color: Colors.grey[800],
      fontFamily: 'QuickSand',
      fontSize: 16,
    );

TextStyle sTextStyle() => TextStyle(
      color: Colors.grey[600],
      fontFamily: 'QuickSand',
      fontSize: 11,
    );
TextStyle sWhiteTextStyle() => TextStyle(
      color: Colors.white,
      fontFamily: 'QuickSand',
      fontSize: 11,
    );

TextStyle kBoldTextStyle() => TextStyle(
      // color: Colors.grey[800],
      fontFamily: 'QuickSand',
      fontSize: 14,
      fontWeight: FontWeight.w700,
    );

TextStyle kWhiteBoldTextStyle() => TextStyle(
      color: Colors.white,
      fontFamily: 'QuickSand',
      fontSize: 14,
      fontWeight: FontWeight.w700,
    );

TextStyle kkBoldTextStyle() => TextStyle(
      // color: Colors.grey[800],
      fontFamily: 'QuickSand',
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

TextStyle kkWhiteBoldTextStyle() => TextStyle(
      color: Colors.white,
      fontFamily: 'QuickSand',
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    TextStyle kkWhiteTextStyle() => TextStyle(
      color: Colors.white,
      fontFamily: 'QuickSand',
      fontSize: 18,
      fontWeight: FontWeight.w400,
    );

    TextStyle kWhiteTextStyle() => TextStyle(
      color: Colors.white,
      fontFamily: 'QuickSand',
      fontSize: 14,
      fontWeight: FontWeight.w300,
    );

TextStyle tabsTextStyle() => TextStyle(
      color: Colors.white,
      fontFamily: 'QuickSand',
      fontSize: 15,
      fontWeight: FontWeight.w500,
    );

TextStyle sBoldTextStyle() => TextStyle(
      color: Colors.white,
      fontFamily: 'QuickSand',
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );

Color primaryColor = Color(0xFFC83030).withOpacity(0.96);
Color blueColor = Color(0xff1A469D);
Color darkGrey = Color.fromARGB(255, 14, 14, 15);
Color yellowColor = Color(0xffFFCF01);
Color errorColor = Colors.red;

Color successColor = Colors.green;

const kBottomContainerHeight = 80.0;
const kActiveCardColour = Color.fromARGB(255, 70, 72, 107);
const kInactiveCardColour = Color(0xFF111328);
const kBottomContainerColour = Color(0xFFEB1555);

const kLabelTextStyle = TextStyle(
  fontSize: 18.0,
  color: Color.fromARGB(255, 42, 42, 44),
);

const kNumberTextStyle = TextStyle(
  fontSize: 40.0,
  fontWeight: FontWeight.w900,
);

const kLargeButtonTextStyle = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
);

const kTitleTextStyle = TextStyle(
  fontSize: 50.0,
  fontWeight: FontWeight.bold,
);

const kResultTextStyle = TextStyle(
  color: Color(0xFF24D876),
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
);

const kBMITextStyle = TextStyle(
  fontSize: 100.0,
  fontWeight: FontWeight.bold,
);

const kBodyTextStyle = TextStyle(
  fontSize: 22.0,
);

class kText extends StatelessWidget {
  String? txt;
  TextStyle ? style;
   kText({
    this.txt,
    super.key,
    this.style
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            txt ?? '',
            style: style,
          ),
        ),
      ],
    );
  }
}
