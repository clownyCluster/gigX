import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:efleet_project_tree/api.dart';
import 'package:efleet_project_tree/colors.dart';
import 'package:efleet_project_tree/login.dart';
import 'package:efleet_project_tree/pages/webviewprivacypolicy.dart';
import 'package:efleet_project_tree/pages/webviewtermsandconditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountTab extends StatelessWidget {
  const AccountTab({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Tab Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: ColorsTheme.bgColor),
      home: const AccountTabPage(),
    );
  }
}

var height, width;
Map<String, dynamic> user = new Map<String, dynamic>();
String? access_token = "";
String userEmail = "", userName = "";

class AccountTabPage extends StatefulWidget {
  const AccountTabPage({super.key});

  @override
  State<AccountTabPage> createState() => _AccountTabPageState();
}

class _AccountTabPageState extends State<AccountTabPage> {
  SharedPreferences? preferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserProfile();
    });
  }

  Future<void> getUserProfile() async {
    final _dio = new Dio();
    this.preferences = await SharedPreferences.getInstance();
    setState(() {
      access_token = this.preferences?.getString('access_token');
    });
    try {
      Response response = await _dio.get(API.base_url + 'me',
          options: Options(headers: {"authorization": "Bearer $access_token"}));

      if (response.statusCode == 200) {
        this.preferences?.setBool('someoneLoggedIn', false);
        setState(() {
          user = response.data;
          userName = user['username'];
          userEmail = user['email'];

          // user.forEach((element) {
          //   userName = element['username'];
          //   userEmail = element['email'];
          // });
        });
      } else if (response.statusCode == 401) {
        await this.preferences?.remove('access_token');
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const Login();
            },
          ),
          (_) => false,
        );
      }
    } on DioError catch (e) {
      print(e);
      if (e.response?.statusCode == 401) {
        this.preferences?.setBool('someoneLoggedIn', true);
        await this.preferences?.remove('access_token');
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const Login();
            },
          ),
          (_) => false,
        );
      }
    }
  }

  Widget showAccountListItems(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          ListTile(
            leading: Image.asset('assets/language_icon.png'),
            title: new RichText(
                text: TextSpan(children: [
              new TextSpan(
                  text: 'Language \n',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
              new TextSpan(
                  text: 'English',
                  style: TextStyle(
                      color: ColorsTheme.txtDescColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0)),
            ])),
            trailing: Image.asset('assets/arrow_right.png'),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PrivacyPolicy()));
            },
            child: ListTile(
              leading: Image.asset('assets/privacy_policy_icon.png'),
              title: Text(
                'Privacy Policy',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0),
              ),
              trailing: Image.asset('assets/arrow_right.png'),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TermsConditions()));
            },
            child: ListTile(
              leading: Image.asset('assets/terms_conditions_icon.png'),
              title: Text(
                'Terms & Conditions',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0),
              ),
              trailing: Image.asset('assets/arrow_right.png'),
            ),
          ),
          ListTile(
            leading: Image(
              image: AssetImage('assets/change_password_icon.png'),
            ),
            title: Text(
              'Change Password',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0),
            ),
            trailing: GestureDetector(
                onTap: () {}, child: Image.asset('assets/arrow_right.png')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return SingleChildScrollView(
          child: Container(
            width: width,
            height: orientation == Orientation.portrait ? height : height * 2.2,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: EdgeInsets.all(40.0),
                margin: EdgeInsets.only(top: 20.0),
                child: AutoSizeText(
                  'Account',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0),
                ),
              ),
              Container(
                padding: EdgeInsets.all(40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30.0,
                          backgroundImage: AssetImage('assets/profile.png'),
                        ),
                        Container(
                          width: width * 0.40,
                          margin: EdgeInsets.only(left: 10.0),
                          child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new AutoSizeText('$userName',
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0)),
                                new AutoSizeText(userEmail,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: ColorsTheme.txtColor,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: -0.9,
                                        fontSize: 6.0)),
                              ]),
                        ),
                      ],
                    ),
                    Container(child: Image.asset('assets/arrow_right.png'))
                  ],
                ),
              ),
              if (orientation == Orientation.landscape)
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    height: 235,
                    width: width * 0.90,
                    decoration: BoxDecoration(
                        color: Color(0xffD3D3D3),
                        borderRadius: BorderRadius.circular(14.0)),
                    child: showAccountListItems(context),
                  ),
                ),
              if (orientation == Orientation.portrait)
                Container(
                  padding: EdgeInsets.only(left: 40.0),
                  child: Container(
                      height: 226,
                      width: width * 0.82,
                      decoration: BoxDecoration(
                          color: Color(0xffD3D3D3),
                          borderRadius: BorderRadius.circular(14.0)),
                      child: showAccountListItems(context)),
                ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
                padding: EdgeInsets.only(left: 40.0),
                child: SizedBox(
                  width: orientation == Orientation.portrait
                      ? width * 0.82
                      : width * 0.90,
                  height: 58.0,
                  child: TextButton(
                    onPressed: () async {
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return LoginPage(
                              is_logged_out: true,
                            );
                          },
                        ),
                        (_) => false,
                      );
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      )),
                      foregroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered) ||
                            states.contains(MaterialState.focused))
                          return ColorsTheme.lightGrey;
                        return ColorsTheme.lightGrey;
                      }),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered) ||
                            states.contains(MaterialState.focused))
                          return ColorsTheme.lightGrey;

                        return ColorsTheme.lightGrey;
                      }),
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                          color: ColorsTheme.dangerColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0),
                    ),
                  ),
                ),
              )
            ]),
          ),
        );
      }),
    );
  }
}
