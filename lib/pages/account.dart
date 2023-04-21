import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:gigX/api.dart';
import 'package:gigX/colors.dart';
import 'package:gigX/login.dart';
import 'package:gigX/pages/disclaimer.dart';
import 'package:gigX/pages/timebox_module/time_box.dart';
import 'package:gigX/pages/timebox_module/time_box_state.dart';
import 'package:gigX/pages/webviewprivacypolicy.dart';
import 'package:gigX/pages/webviewtermsandconditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/constants.dart';
import '../service/toastService.dart';

class AccountTab extends StatelessWidget {
  const AccountTab({super.key});

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        title: 'Account Tab Page',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: ColorsTheme.bgColor),
        home: const AccountTabPage(),
        routes: {
          '/time_box': (context) => ChangeNotifierProvider(
              create: (_) => TimeBoxState(), child: TimeBoxPage()),
        },
      ),
    );
  }
}

var height, width;
Map<String, dynamic> user = new Map<String, dynamic>();
String? access_token = "";
String userEmail = "", userName = "", profileUrl = "";

class AccountTabPage extends StatefulWidget {
  const AccountTabPage({super.key});

  @override
  State<AccountTabPage> createState() => _AccountTabPageState();
}

class _AccountTabPageState extends State<AccountTabPage> {
  SharedPreferences? preferences;
  bool is_loading = false;
  final storage = FlutterSecureStorage();
  String? access_token;
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserProfile();
    });
  }

  Future<void> changePassword() async {
    this.preferences = await SharedPreferences.getInstance();

    access_token = preferences?.getString('access_token').toString();
    Dio dio = Dio();

    var data = {
      "password": newPasswordController.text,
      "current_password": passwordController.text,
      "confirm_password": confirmPasswordController.text
    };
    print(data);
    try {
      Response response = await dio.put(
          'https://api.efleetpass.com.au/update/password',
          data: data,
          options: Options(headers: {"authorization": "Bearer $access_token"}));
      print(response);
      ToastService().s('Password Changed Successfully');
    } on DioError catch (e) {
      ToastService().e(e.response!.data['error'].toString(),
          duration: Duration(seconds: 6));
      print(e.response!.data['error'].toString());
    }
  }

  showChangePasswordDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.all(Radius.circular(10.0))),
                // insetPadding: EdgeInsets.zero,
                title: Text('Change Password!', style: kBoldTextStyle()),
                // content: const Text('Are you sure you want to logout?', style:TextStyle(
                //   fontFamily: 'Barlow',
                //   fontSize: 15
                // ),),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Pasword',
                        style: kBoldTextStyle(),
                      ),
                      sSizedBox(),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                ))),
                      ),
                      kSizedBox(),
                      Text(
                        'New Pasword',
                        style: kBoldTextStyle(),
                      ),
                      sSizedBox(),
                      TextFormField(
                        controller: newPasswordController,
                        decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                ))),
                      ),
                      kSizedBox(),
                      Text(
                        'Confirm Pasword',
                        style: kBoldTextStyle(),
                      ),
                      sSizedBox(),
                      TextFormField(
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                ))),
                      )
                    ],
                  ),
                ),

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
                        'Update',
                        style: kTextStyle().copyWith(color: primaryColor),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        changePassword();

                        //   userResponse.remove('userResponse');
                        // Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => false,);
                      }),
                ],
              );
            },
          );
        });
  }

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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LoginPage(is_logged_out: true)));
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

  Future<void> getUserProfile() async {
    final _dio = new Dio();
    this.preferences = await SharedPreferences.getInstance();
    setState(() {
      access_token = this.preferences?.getString('access_token');
      is_loading = true;
    });
    try {
      Response response = await _dio.get(API.base_url + 'me',
          options: Options(headers: {"authorization": "Bearer $access_token"}));

      if (response.statusCode == 200) {
        this.preferences?.setBool('someoneLoggedIn', false);
        setState(() {
          is_loading = false;
          user = response.data;
          userName = user['username'];
          userEmail = user['email'];
          profileUrl = user['ProfilePic'];

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

  Future _pickProfileImageFromGallery() async {
    final profileimg;
    final ImagePicker _picker;
    _picker = ImagePicker();
    profileimg = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      access_token = this.preferences?.getString('access_token');
      is_loading = true;
    });
    try {
      final _dio = Dio();
      var base_url = API.base_url;
      final path = profileimg.path;
      var fileName = (profileimg.path.split('/').last);

      final bytes = await File(path).readAsBytesSync();

      print('before ' + bytes.length.toString());
      final compressed_bytes = await FlutterImageCompress.compressWithList(
          bytes.buffer.asUint8List(),
          quality: 85,
          minWidth: 500,
          minHeight: 500);
      final formData = FormData.fromMap({
        'profile_image':
            await MultipartFile.fromBytes(compressed_bytes, filename: fileName),
      });
      Response response = await _dio.post(base_url + 'profile/image',
          data: formData,
          options: Options(headers: {
            "Content-type": "multipart/form-data",
            "authorization": "Bearer $access_token"
          }));

      setState(() {
        is_loading = false;
      });

      Fluttertoast.showToast(
          msg: "Profile Image Uploaded Successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: ColorsTheme.btnColor,
          textColor: Colors.white,
          fontSize: 16.0);
      getUserProfile();
    } on DioError catch (error) {
      print(error.response);
    }
  }

  Future _pickProfileImageFromCamera() async {
    final profileimg;
    final ImagePicker _picker;
    _picker = ImagePicker();
    profileimg = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      access_token = this.preferences?.getString('access_token');
      is_loading = true;
    });
    try {
      final _dio = Dio();
      var base_url = API.base_url;
      final path = profileimg.path;
      var fileName = (profileimg.path.split('/').last);

      final bytes = await File(path).readAsBytesSync();

      print('before ' + bytes.length.toString());
      final compressed_bytes = await FlutterImageCompress.compressWithList(
          bytes.buffer.asUint8List(),
          quality: 85,
          minWidth: 500,
          minHeight: 500);
      final formData = FormData.fromMap({
        'profile_image':
            await MultipartFile.fromBytes(compressed_bytes, filename: fileName),
      });
      Response response = await _dio.post(base_url + 'profile/image',
          data: formData,
          options: Options(headers: {
            "Content-type": "multipart/form-data",
            "authorization": "Bearer $access_token"
          }));

      setState(() {
        is_loading = false;
      });

      Fluttertoast.showToast(
          msg: "Profile Image Uploaded Successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: ColorsTheme.btnColor,
          textColor: Colors.white,
          fontSize: 16.0);
      getUserProfile();
    } on DioError catch (error) {
      print(error.response);
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
          // ListTile(
          //   leading: Image.asset('assets/language_icon.png'),
          //   title: new RichText(
          //       text: TextSpan(children: [
          //     new TextSpan(
          //         text: 'Language \n',
          //         style: TextStyle(
          //             fontSize: 20.0,
          //             fontWeight: FontWeight.w600,
          //             color: Colors.black)),
          //     new TextSpan(
          //         text: 'English',
          //         style: TextStyle(
          //             color: ColorsTheme.txtDescColor,
          //             fontWeight: FontWeight.w400,
          //             fontSize: 14.0)),
          //   ])),
          //   trailing: Image.asset('assets/arrow_right.png'),
          // ),
          InkWell(
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => const TimeBox()));
              Navigator.pushNamed(context, '/time_box');
            },
            child: ListTile(
              leading: Icon(
                Icons.timer,
                color: ColorsTheme.btnColor,
              ),
              title: Text(
                'Time Box',
                style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0),
              ),
              trailing: Image.asset('assets/arrow_right.png'),
            ),
          ),
          Divider(),
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
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0),
              ),
              trailing: Image.asset('assets/arrow_right.png'),
            ),
          ),
          Divider(),

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
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0),
              ),
              trailing: Image.asset('assets/arrow_right.png'),
            ),
          ),
          Divider(),

          ListTile(
            onTap: () {
              showChangePasswordDialog(context);
            },
            leading: Image(
              image: AssetImage('assets/change_password_icon.png'),
            ),
            title: Text(
              'Change Password',
              style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0),
            ),
            trailing: Image.asset('assets/arrow_right.png'),
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
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          'Account',
          style:
              kkBoldTextStyle().copyWith(fontSize: 20, color: Colors.grey[800]),
        ),
        centerTitle: false,
        backgroundColor: whiteColor,
        elevation: 0,
      ),
      // body: OrientationBuilder(builder: (context, orientation) {
      //   return SingleChildScrollView(
      //     child: Stack(
      //       alignment: Alignment.center,
      //       children: [
      //         Container(
      //           width: width,
      //           height: orientation == Orientation.portrait && height < 820
      //               ? height * 0.87
      //               : orientation == Orientation.portrait && height > 820
      //                   ? height * 0.75
      //                   : height * 2.2,
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 // Container(
      //                 //   padding: EdgeInsets.all(40.0),
      //                 //   margin: EdgeInsets.only(top: 10.0),
      //                 //   child: AutoSizeText(
      //                 //     'Account',
      //                 //     style: TextStyle(
      //                 //         color: Colors.black,
      //                 //         fontWeight: FontWeight.w600,
      //                 //         fontSize: 20.0),
      //                 //   ),
      //                 // ),
      //                 Column(
      //                   children: [
      //                     Container(
      //                   padding:
      //                       EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       Row(
      //                         mainAxisAlignment: MainAxisAlignment.start,
      //                         children: [
      //                           InkWell(
      //                             onTap: () {
      //                               showDialog(
      //                                 context: context,
      //                                 builder: (BuildContext context) {
      //                                   return AlertDialog(
      //                                     title: Text(
      //                                         'Pick Image From Gallery Or Camera'),
      //                                     actions: [
      //                                       TextButton(
      //                                         onPressed: () {
      //                                           _pickProfileImageFromGallery();
      //                                           Navigator.pop(context);
      //                                         },
      //                                         child: Text(
      //                                           'Gallery',
      //                                           style: TextStyle(
      //                                               color: Colors.black),
      //                                         ),
      //                                       ),
      //                                       TextButton(
      //                                         onPressed: () {
      //                                           _pickProfileImageFromCamera();
      //                                           Navigator.pop(context);
      //                                         },
      //                                         child: Text(
      //                                           'Camera',
      //                                           style: TextStyle(
      //                                               color: Colors.black),
      //                                         ),
      //                                       ),
      //                                     ],
      //                                   );
      //                                 },
      //                               );
      //                             },
      //                             child: CircleAvatar(
      //                               radius: 30.0,
      //                               backgroundImage:
      //                                   NetworkImage(profileUrl.toString()),
      //                             ),
      //                           ),
      //                           Container(
      //                             // width: width * 0.512,
      //                             margin: EdgeInsets.only(left: 10.0),
      //                             child: new Column(
      //                                 crossAxisAlignment:
      //                                     CrossAxisAlignment.start,
      //                                 children: [
      //                                   new AutoSizeText('$userName',
      //                                       maxLines: 2,
      //                                       style: TextStyle(
      //                                           color: Colors.black,
      //                                           fontWeight: FontWeight.w600,
      //                                           fontSize: 16.0)),
      //                                   new AutoSizeText(userEmail,
      //                                       maxLines: 2,
      //                                       style: TextStyle(
      //                                           color: ColorsTheme.txtColor,
      //                                           fontWeight: FontWeight.w400,
      //                                           letterSpacing: -0.9,
      //                                           fontSize: 6.0)),
      //                                 ]),
      //                           ),
      //                         ],
      //                       ),
      //                       // Container(
      //                       //     child: Image.asset('assets/arrow_right.png'))
      //                     ],
      //                   ),
      //                 ),
      //                 if (orientation == Orientation.landscape)
      //                   Container(
      //                     alignment: Alignment.center,
      //                     child: Container(
      //                       height: 235,
      //                       width: double.infinity,
      //                       decoration: BoxDecoration(
      //                           color: Colors.grey[100],
      //                           borderRadius: BorderRadius.circular(14.0)),
      //                       child: showAccountListItems(context),
      //                     ),
      //                   ),
      //                 if (orientation == Orientation.portrait)
      //                   Container(
      //                     // padding: kStandardPadding(),
      //                     padding: EdgeInsets.all(20),
      //                     child: Container(
      //                       padding: kPadding(),
      //                         height: 300,
      //                         // width: width * 0.82,
      //                         width: double.infinity,
      //                         decoration: BoxDecoration(
      //                             color: Colors.grey[100],
      //                             borderRadius: BorderRadius.circular(14.0)),
      //                         child: showAccountListItems(context)),
      //                   ),
      //                   ],
      //                 ),
      //                 Container(
      //                   margin: EdgeInsets.only(top: 10.0),
      //                   // padding: EdgeInsets.only(left: 40.0),
      //                   padding: kStandardPadding(),
      //                   child: SizedBox(
      //                     width: orientation == Orientation.portrait
      //                         ? double.infinity
      //                         : double.infinity,
      //                     height: 58.0,
      //                     child: TextButton(
      //                       onPressed: () async {
      //                         showLogoutConfirmationDialog(context);
      //                         // Navigator.of(context, rootNavigator: true)
      //                         //     .pushAndRemoveUntil(
      //                         //   MaterialPageRoute(
      //                         //     builder: (BuildContext context) {
      //                         //       return LoginPage(
      //                         //         is_logged_out: true,
      //                         //       );
      //                         //     },
      //                         //   ),
      //                         //   (_) => false,
      //                         // );
      //                       },
      //                       style: ButtonStyle(
      //                         shape: MaterialStateProperty.all(
      //                             RoundedRectangleBorder(
      //                           borderRadius: BorderRadius.circular(14.0),
      //                         )),
      //                         foregroundColor:
      //                             MaterialStateProperty.resolveWith<Color>(
      //                                 (Set<MaterialState> states) {
      //                           if (states.contains(MaterialState.hovered) ||
      //                               states.contains(MaterialState.focused))
      //                             return Colors.grey.withOpacity(0.1);
      //                           return Colors.grey.withOpacity(0.1);
      //                         }),
      //                         backgroundColor:
      //                             MaterialStateProperty.resolveWith<Color>(
      //                                 (Set<MaterialState> states) {
      //                           if (states.contains(MaterialState.hovered) ||
      //                               states.contains(MaterialState.focused))
      //                             return Colors.grey.withOpacity(0.1);

      //                           return Colors.grey.withOpacity(0.1);
      //                         }),
      //                       ),
      //                       child: Text(
      //                         'Logout',
      //                         style: TextStyle(
      //                             color: ColorsTheme.dangerColor,
      //                             fontWeight: FontWeight.w600,
      //                             fontSize: 16.0),
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ]),
      //         ),
      //         if (is_loading == true && user.isEmpty)
      //           Container(
      //             alignment: Alignment.topCenter,
      //             // margin: EdgeInsets.only(to),
      //             child: CircularProgressIndicator(
      //               valueColor:
      //                   AlwaysStoppedAnimation<Color>(ColorsTheme.btnColor),
      //             ),
      //           ),
      //       ],
      //     ),
      //   );
      // }),

      ///////        New One        //////////
      ///
      body: Container(
        padding: kStandardPadding(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Pick Image From Gallery Or Camera'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        _pickProfileImageFromGallery();
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Gallery',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _pickProfileImageFromCamera();
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Camera',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(profileUrl.toString()),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            // width: width * 0.512,
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
                        ),
                      ],
                    ),
                    LSizedBox(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[100],
                          
                      ),
                      padding: kPadding(),
                      child: Column(
                        children: [
                          InkWell(
                      onTap: () {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => const TimeBox()));
                        Navigator.pushNamed(context, '/time_box');
                      },
                      child: ListTile(
                        leading: Icon(
                          Icons.timer,
                          color: ColorsTheme.btnColor,
                        ),
                        title: Text(
                          'Time Box',
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0),
                        ),
                        trailing: Image.asset('assets/arrow_right.png'),
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PrivacyPolicy()));
                      },
                      child: ListTile(
                        leading: Image.asset('assets/privacy_policy_icon.png'),
                        title: Text(
                          'Privacy Policy',
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0),
                        ),
                        trailing: Image.asset('assets/arrow_right.png'),
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TermsConditions()));
                      },
                      child: ListTile(
                        leading: Image.asset('assets/terms_conditions_icon.png'),
                        title: Text(
                          'Terms & Conditions',
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0),
                        ),
                        trailing: Image.asset('assets/arrow_right.png'),
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DisclaimerScreen()));
                      },
                      child: ListTile(
                        leading: Image.asset('assets/terms_conditions_icon.png'),
                        title: Text(
                          'Disclaimer',
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0),
                        ),
                        trailing: Image.asset('assets/arrow_right.png'),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      onTap: () {
                        showChangePasswordDialog(context);
                      },
                      leading: Image(
                        image: AssetImage('assets/change_password_icon.png'),
                      ),
                      title: Text(
                        'Change Password',
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0),
                      ),
                      trailing: Image.asset('assets/arrow_right.png'),
                    ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),

            //////// Log out  ///////////
            Container(
              // margin: EdgeInsets.only(top: 10.0),
              width: double.infinity,
              // padding: EdgeInsets.only(left: 40.0),
              padding: kVerticalPadding(),
              child: TextButton(
                onPressed: () async {
                  showLogoutConfirmationDialog(context);
                  
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  )),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered) ||
                        states.contains(MaterialState.focused))
                      return Colors.grey.withOpacity(0.1);
                    return Colors.grey.withOpacity(0.1);
                  }),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered) ||
                        states.contains(MaterialState.focused))
                      return Colors.grey.withOpacity(0.1);

                    return Colors.grey.withOpacity(0.1);
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
          ],
        ),
      ),
    );
  }
}
