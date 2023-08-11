import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gigX/appRoute/appRoute.dart';
import 'package:gigX/appRoute/routeName.dart';
import 'package:gigX/view_model/account_view_model.dart';

import '../colors.dart';
import '../constant/constants.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Get.put(AccountViewModel());

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
                  title: Text('Change Password!', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
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
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        sSizedBox(),
                        TextFormField(
                          controller: state.passwordController.value,
                          // decoration: InputDecoration(
                          //     isDense: true,
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //     focusedBorder: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(10),
                          //         borderSide: BorderSide(
                          //           // color: primaryColor,
                          //         ))),
                        ),
                        kSizedBox(),
                        Text(
                          'New Pasword',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        sSizedBox(),
                        TextFormField(
                          controller: state.newPasswordController.value,
                          // decoration: InputDecoration(
                          //     isDense: true,
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //     focusedBorder: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(10),
                          //         borderSide: BorderSide(
                          //           // color: primaryColor,
                          //         ))),
                        ),
                        kSizedBox(),
                        Text(
                          'Confirm Pasword',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        sSizedBox(),
                        TextFormField(
                          controller: state.confirmPasswordController.value,
                          // decoration: InputDecoration(
                          //     isDense: true,
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //     focusedBorder: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(10),
                          //         borderSide: BorderSide(
                          //           color: primaryColor,
                          //         ))),
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
                        Get.back();
                      },
                    ),
                    TextButton(
                        child: Text(
                          'Update',
                          style: kTextStyle().copyWith(
                              color: state.isDark.value
                                  ? Colors.white
                                  : primaryColor),
                        ),
                        onPressed: () async {
                          state.changePassword();
                          // changePassword();

                          //   userResponse.remove('userResponse');
                          // Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => false,);
                        }),
                  ],
                );
              },
            );
          });
    }

    Widget showAccountListItems(BuildContext context) {
      return Container(
        padding: kStandardPadding(),
        decoration: BoxDecoration(
            color: Get.isDarkMode ? Colors.grey[700] : Colors.grey[200],
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,

          // physics: NeverScrollableScrollPhysics(),
          children: [
            InkWell(
              onTap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => const TimeBox()));
                Get.toNamed(RouteName.timeBoxScreen);
              },
              child: ListTile(
                  // leading: Icon(
                  //   Icons.timer,
                  //   color: ColorsTheme.btnColor,
                  // ),
                  leading: Icon(
                    Icons.timer,
                    color: Get.isDarkMode ? buttonColor : primaryColor,
                  ),
                  title: Text(
                    'Time Box',
                  ),
                  trailing: Icon(Icons.arrow_forward_ios)),
            ),
            Divider(),
            InkWell(
              onTap: () {
                Get.toNamed(RouteName.privacyPolicyScreen);
              },
              child: ListTile(
                  leading: ImageIcon(
                    AssetImage('assets/privacy_policy_icon.png'),
                    color: Get.isDarkMode ? buttonColor : primaryColor,
                  ),
                  title: Text(
                    'Privacy Policy',
                  ),
                  trailing: Icon(Icons.arrow_forward_ios)),
            ),
            Divider(),
            InkWell(
              onTap: () {
                Get.toNamed(RouteName.termsAndConditionScreen);
              },
              child: ListTile(
                  leading: ImageIcon(
                    AssetImage('assets/terms_conditions_icon.png'),
                    color: Get.isDarkMode ? buttonColor : primaryColor,
                  ),
                  title: Text(
                    'Terms & Conditions',
                  ),
                  trailing: Icon(Icons.arrow_forward_ios)),
            ),
            Divider(),
            ListTile(
                onTap: () {
                  showChangePasswordDialog(context);
                },
                // leading: Image(
                //   image: AssetImage('assets/change_password_icon.png'),
                // ),
                leading: ImageIcon(
                  AssetImage('assets/change_password_icon.png'),
                  color: Get.isDarkMode ? buttonColor : primaryColor,
                ),
                title: Text(
                  'Change Password',
                ),
                trailing: Icon(Icons.arrow_forward_ios)),
            Divider(),
            ListTile(
                onTap: () {
                  // showChangePasswordDialog(context);
                },
                // leading: Icon(
                //   Icons.brightness_4_outlined,
                //   color: blueColor,
                // ),
                leading: Icon(
                  Icons.brightness_4_outlined,
                  color: Get.isDarkMode ? buttonColor : primaryColor,
                ),
                title: Text(
                  'Change Theme',
                ),
                subtitle: Text('Restart Required'),
                trailing: Obx(
                  () => Switch(
                      // activeColor: blueColor,
                      value: state.isDark.value,
                      onChanged: (val) {
                        state.changeTheme();
                      }),
                )),
          ],
        ),
      );
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
                          Get.offNamedUntil(
                              RouteName.loginScreen, (route) => false);
                        }),
                  ],
                );
              },
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: state.isDark.value ? greyColor : whiteColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Account',
        ),
      ),
      body: Container(
        padding: kStandardPadding(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            showAccountListItems(context),
            Container(
              decoration: BoxDecoration(
                color: Get.isDarkMode ? Colors.grey[700] : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                onTap: () {
                  showLogoutConfirmationDialog(context);
                },
                title: Center(
                  child: Text(
                    'Log Out',
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  TextStyle defaultTextStyle() {
    return TextStyle(
        color: Colors.grey[700], fontWeight: FontWeight.w600, fontSize: 16.0);
  }
}
