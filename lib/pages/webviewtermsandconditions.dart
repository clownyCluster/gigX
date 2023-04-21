import 'dart:io';
import 'package:gigX/colors.dart';
import 'package:gigX/constant/constants.dart';
import 'package:gigX/home.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsConditions extends StatefulWidget {
  @override
  TermsConditionsState createState() => TermsConditionsState();
}

class TermsConditionsState extends State<TermsConditions> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          
          iconTheme: IconThemeData(color: Colors.grey[800]),
          actionsIconTheme: IconThemeData(color: Colors.grey[800]),
          title: Text('Terms & Conditions', style: kkBoldTextStyle().copyWith(fontSize: 20, color: Colors.grey[800]),),
          centerTitle: true,
          backgroundColor: whiteColor,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.refresh,
                // color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => super.widget));
                // do something
              },
            )
          ],
          leading: InkWell(
            onTap: () {
              Navigator.of(context, rootNavigator: false).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const HomePage(
                      initialPage: 3,
                    );
                  },
                ),
                (_) => false,
              );
              BottomNavigationBar navigationBar =
                  bottomWidgetKey.currentWidget as BottomNavigationBar;
              navigationBar.onTap!(3);
            },
            child: Icon(
              Icons.arrow_back,
              // color: Colors.white,
            ),
          ),
        ),
        body: WebView(
          initialUrl: 'https://gigxcoin.net/terms-conditions',
        ),
      ),
    );
  }
}
