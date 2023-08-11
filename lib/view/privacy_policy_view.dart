import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constant/constants.dart';

class PriavcyPolicyView extends StatefulWidget {
  const PriavcyPolicyView({super.key});

  @override
  State<PriavcyPolicyView> createState() => _PriavcyPolicyViewState();
}

class _PriavcyPolicyViewState extends State<PriavcyPolicyView> {
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
          iconTheme: IconThemeData(color: Colors.grey[800]),
          actionsIconTheme: IconThemeData(color: Colors.grey[800]),
          title: Text(
            'Privacy Policy',
            style: kkBoldTextStyle()
                .copyWith(fontSize: 20, color: Colors.grey[800]),
          ),
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
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              // color: Colors.white,
            ),
          ),
        ),
        body: WebView(
          initialUrl: 'https://gigxcoin.net/privacy-policy',
        ),
      ),
    );
  }
}
