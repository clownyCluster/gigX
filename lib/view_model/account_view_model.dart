import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigX/appRoute/routeName.dart';
import 'package:gigX/constant/constants.dart';
import 'package:gigX/data/network/network_api_services.dart';
import 'package:gigX/service/local_storage_service.dart';
import 'package:gigX/view/login_view.dart';

import '../service/toastService.dart';

class AccountViewModel extends GetxController {
  final passwordController = TextEditingController().obs;
  final confirmPasswordController = TextEditingController().obs;
  final newPasswordController = TextEditingController().obs;

  AccountViewModel() {
    if (LocalStorageService().readBool(LocalStorageKeys.isDark) != null) {
      isDark.value = LocalStorageService().readBool(LocalStorageKeys.isDark)!;
    }
  }

  Future changePassword() async {
    final _apiServices = NetworkApiServices();

    var data = {
      "password": newPasswordController.value.text,
      "current_password": passwordController.value.text,
      "confirm_password": confirmPasswordController.value.text
    };
    print(data);
    try {
      var response = await _apiServices.putAPI(
          'https://api.efleetpass.com.au/update/password', data);
      print(response);
      Get.back();
      ToastService().s('Password Changed Successfully');
    } on DioError catch (e) {
      ToastService().e(e.response!.data['error'].toString(),
          duration: Duration(seconds: 6));
      print(e.response!.data['error'].toString());
    }
  }

  RxBool isDark = false.obs;
  changeTheme() {
    isDark.value = !isDark.value;
    isDark.value == true
        ? Get.changeTheme(ThemeData.dark())
        : Get.changeTheme(ThemeData.light());
    LocalStorageService().write(LocalStorageKeys.isDark, isDark.value);
    Get.dialog(
        Container(
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 30),
              decoration: BoxDecoration(
                  color: whiteColor, borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Restart Device!',
                    style: TextStyle(
                        color: darkGrey,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  kSizedBox(),
                  Text(
                    'Please restart device to apply changes.',
                    style: kTextStyle(),
                  ),
                  LSizedBox(),
                  TextButton(
                      onPressed: 
                      
                      () {
                        if (kDebugMode) {
                          
                        }
                        // exit(0); // Exit the app
                      },
                      child: Text('OK'))
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false);
  }
}
