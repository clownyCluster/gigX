import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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

import '../data/api_model/getUsersModel.dart';

class LoginViewModel extends GetxController {
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;

  LoginViewModel() {
    isDark.value =
        LocalStorageService().readBool(LocalStorageKeys.isDark) ?? false;
  }
  RxBool isDark = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  GetUserModels? getUserModels;
  Future getUserProfile(token) async {
    print('get user chalyathiyo login ma');
    Dio dio = Dio();
    try {
      var response = await dio.get('${API.base_url}me',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      print(response.data);
      getUserModels = GetUserModels.fromJson(response.data);
    } catch (e) {
    
    }
  }

  // Future<bool> login() async {
  //   setLoading(true);
  //   var data = {
  //     "grant_type": "password",
  //     "client_id": API.clientId,
  //     "client_secret": API.clientSecret,
  //     "username": emailController.value.text,
  //     "password": passwordController.value.text
  //   };
  //   print(data);
  //   RxBool result = false.obs;

  //   final _apiServices = NetworkApiServices();

  //   await _apiServices
  //       .postAPI('${API.base_url}oauth/token', data)
  //       .then((value) async {
  //     await getUserProfile(value['access_token']);
  //     if (value != null) {
  //       ToastService().s('Login Successful');
  //       // setLoading(false);
  //       Get.offNamedUntil(RouteName.homeScreen, (route) => false);
  //       LocalStorageService()
  //           .write(LocalStorageKeys.email, emailController.value.text);
  //       LocalStorageService()
  //           .write(LocalStorageKeys.password, passwordController.value.text);
  //       LocalStorageService()
  //           .write(LocalStorageKeys.accessToken, value['access_token']);

  //       LocalStorageService()
  //           .write(LocalStorageKeys.email, getUserModels!.email);
  //       LocalStorageService().write(LocalStorageKeys.userId, getUserModels!.id);

  //       await _firestore
  //           .collection('users')
  //           .doc(getUserModels!.id.toString())
  //           .set({
  //         'uid': getUserModels!.id,
  //         'email': getUserModels!.email,
  //         'name': getUserModels!.username,
  //         'profilePic': getUserModels!.profilePic
  //       }, SetOptions(merge: true));
  //       result.value = true;
  //     } else {
  //       ToastService().e('Please enter correct credentials and try again.');
  //     }
  //     setLoading(false);
  //   }).onError((error, stackTrace) {
  //     setLoading(false);

  //     ToastService().e('The user credentials were incorrect');
  //     print('Yo error ho ${error.toString()}');
  //   });
  //   print('Result.value ho haii-    ------------------->   ${result.value}');
  //   return result.value;
  // }

  Future login() async {
    setLoading(true);
    var data = {
      "grant_type": "password",
      "client_id": API.clientId,
      "client_secret": API.clientSecret,
      "username": emailController.value.text,
      "password": passwordController.value.text
    };
    print(data);
    final _apiServices = NetworkApiServices();
    try {
      var response =
          await _apiServices.postAPI('${API.base_url}oauth/token', data);

      // print(response['access_token']);

      if (response['access_token'] != null) {
        print('Ya vitra chalyo haii');
        await getUserProfile(response['access_token']);
        ToastService().s('Login Successful');
        // setLoading(false);
        Get.offNamedUntil(RouteName.homeScreen, (route) => false);
        LocalStorageService()
            .write(LocalStorageKeys.email, emailController.value.text);
        LocalStorageService()
            .write(LocalStorageKeys.password, passwordController.value.text);
        LocalStorageService()
            .write(LocalStorageKeys.accessToken, response['access_token']);

        LocalStorageService()
            .write(LocalStorageKeys.email, getUserModels!.email);
        LocalStorageService().write(LocalStorageKeys.userId, getUserModels!.id);

        await _firestore
            .collection('users')
            .doc(getUserModels!.id.toString())
            .set({
          'uid': getUserModels!.id,
          'email': getUserModels!.email,
          'name': getUserModels!.username,
          'profilePic': getUserModels!.profilePic
        }, SetOptions(merge: true));
        print('Response null navayera if vitra chalyathiyo.');
      } else {
        setLoading(false);
        ToastService().e('Please enter correct credentials and try again.');
      }
      setLoading(false);
    } catch (e) {
      print(e);
      setLoading(false);
      ToastService().e(e.toString());
      print('Error response thiyo yo : ${e}');
    }
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
