import 'dart:io';
import 'package:gigX/colors.dart';
import 'package:gigX/home.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  PrivacyPolicyState createState() => PrivacyPolicyState();
}

class PrivacyPolicyState extends State<PrivacyPolicy> {
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
        appBar: AppBar(
          title: Text('Privacy Policy'),
          centerTitle: true,
          backgroundColor: ColorsTheme.btnColor,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
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
              // BottomNavigationBar navigationBar =
              //     bottomWidgetKey.currentWidget as BottomNavigationBar;
              // navigationBar.onTap!(2);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: WebView(
          initialUrl: 'https://efleetpass.com.au/privacy-policy',
        ),
      ),
    );
  }
}
