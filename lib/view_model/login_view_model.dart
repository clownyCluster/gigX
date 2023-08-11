import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gigX/api.dart';
import 'package:gigX/appRoute/routeName.dart';
import 'package:gigX/data/network/network_api_services.dart';
import 'package:gigX/login.dart';
import 'package:gigX/service/local_storage_service.dart';
import 'package:gigX/service/toastService.dart';
import 'package:local_auth/local_auth.dart';

class LoginViewModel extends GetxController {
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;

  LoginViewModel() {
    isDark.value = LocalStorageService().readBool(LocalStorageKeys.isDark)!;
  }
  RxBool isDark = false.obs;

  Future<bool> login() async {
    setLoading(true);
    print('Login function chalyo');
    var data = {
      "grant_type": "password",
      "client_id": 18,
      "client_secret": "VDt8JhTzNdBrCWoKTwWNGOw0SQ5bPg99J2HI2BLL",
      "username": emailController.value.text,
      "password": passwordController.value.text
    };
    print(data);
    RxBool result = false.obs;

    final _apiServices = NetworkApiServices();
    await _apiServices
        .postAPI('${API.base_url}oauth/token', data)
        .then((value) {
      print('Value:" $value');

      if (value != null) {
        ToastService().s('Login Successful');
        // setLoading(false);
        Get.offNamedUntil(RouteName.homeScreen, (route) => false);
        LocalStorageService()
            .write(LocalStorageKeys.email, emailController.value.text);
        LocalStorageService()
            .write(LocalStorageKeys.password, passwordController.value.text);
        LocalStorageService()
            .write(LocalStorageKeys.accessToken, value['access_token']);
        result.value = true;
      } else {
        ToastService().e('Please enter correct credentials and try again.');
      }
      setLoading(false);
    }).onError((error, stackTrace) {
      setLoading(false);

      ToastService().e('The user credentials were incorrect');
      print('Yo error ho ${error.toString()}');
    });
    print('Result.value ho haii-    ------------------->   ${result.value}');
    return result.value;
  }

  RxBool isPasswordVisible = true.obs;
  RxBool stayLoggedIn = false.obs;
  RxBool isLoading = false.obs;
  setLoading(val) {
    isLoading.value = val;
  }

  onVIsibilityChanged() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  onStayLoggedInChanged(val) {
    stayLoggedIn.value = val;
  }

  final LocalAuthentication auth = LocalAuthentication();

  Future<void> authenticateFaceID() async {
    var emailCheck = LocalStorageService().read(LocalStorageKeys.email);
    var passwordCheck = LocalStorageService().read(LocalStorageKeys.password);

    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    bool isBiometricSupported = await auth.isDeviceSupported();

    bool canCheckBiometrics = await auth.canCheckBiometrics;
    if (emailCheck != null ||
        emailCheck!.isNotEmpty && passwordCheck != null ||
        passwordCheck!.isNotEmpty)
      try {
        if (isBiometricSupported) {
          print(isBiometricSupported);
          print(canCheckBiometrics);

          if (Platform.isIOS) {
            bool pass = await auth.authenticate(
                localizedReason: 'Authenticate with fingerprint',
                options: AuthenticationOptions(
                    biometricOnly: true,
                    stickyAuth: true,
                    useErrorDialogs: true));

            if (pass) {
              bool result;

              result = await login();

              if (result == true) {
                Get.offNamedUntil(RouteName.homeScreen, (route) => false);
              } else
                ToastService().e('Something went wrong');
            }
          } else {
            bool pass = await auth.authenticate(
                localizedReason: 'Authenticate with fingerprint/face',
                options: AuthenticationOptions(
                    biometricOnly: true,
                    stickyAuth: true,
                    useErrorDialogs: true));
            if (pass) {
              bool result;

              emailController.value.text =
                  LocalStorageService().read(LocalStorageKeys.email)!;
              passwordController.value.text =
                  LocalStorageService().read(LocalStorageKeys.password)!;

              result = await login();

              print(result);

              if (result == true) {
                Get.offNamedUntil(RouteName.homeScreen, (route) => false);
              }
            } else {
              ToastService().e('Something went wrong');
            }
          }
        } else {
          ToastService().e('Your device does\'t support face id');
        }
      } on PlatformException catch (e) {
        print(e);
        print('denied');
      }
  }
}
