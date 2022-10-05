import 'package:efleet_project_tree/colors.dart';
import 'package:efleet_project_tree/pages/projectdetails.dart';
import 'package:efleet_project_tree/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Tab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: ColorsTheme.bgColor),
      home: const HomeTabPage(),
    );
  }
}

var height, width;

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: OrientationBuilder(builder: (context, orientation) {
        return SingleChildScrollView(
          child: Container(
            height: orientation == Orientation.portrait ? height : height * 2.6,
            width: width,
            child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.all(40.0),
                margin: EdgeInsets.only(top: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      // padding: EdgeInsets.all(50.0),

                      child: new RichText(
                          text: new TextSpan(children: [
                        new TextSpan(
                            text: 'MFA Projects \n',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600)),
                        new TextSpan(
                            text: '6 Projects',
                            style: TextStyle(color: ColorsTheme.txtDescColor))
                      ])),
                    ),
                    Container(
                      child: Image(image: AssetImage('assets/icon_search.png')),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                height: height * 0.8,
                child: ListView.builder(
                    itemCount: 4,
                    shrinkWrap: true,
                    itemExtent: 120.0,
                    itemBuilder: (BuildContext context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProjectDetails()));
                          setState(() {
                            is_pressed_project_details = true;
                          });
                        },
                        child: ListTile(
                          title: Container(
                            height: 89.0,
                            width: width * 0.85,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.0),
                                border: Border.all(
                                    color: ColorsTheme.txtDescColor)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Image(
                                      image:
                                          AssetImage('assets/sample_logo.png')),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  margin: EdgeInsets.only(top: 15.0),
                                  child: new RichText(
                                      text: new TextSpan(children: [
                                    new TextSpan(
                                        text: 'eFleetPass \n',
                                        style: TextStyle(color: Colors.black)),
                                    new TextSpan(
                                        text: '6 Members \n',
                                        style: TextStyle(color: Colors.black)),
                                  ])),
                                ),
                                SizedBox(
                                  width: orientation == Orientation.portrait
                                      ? width * 0.3
                                      : width * 0.6,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Image(
                                    image:
                                        AssetImage('assets/arrow_details.png'),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ]),
          ),
        );
      }),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 40.0),
        height: 90,
        width: 90,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/addtask_floating_button.png'),
                fit: BoxFit.fill)),
      ),
    );
  }
}
