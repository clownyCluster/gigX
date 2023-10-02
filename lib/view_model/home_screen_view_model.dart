import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:gigX/api.dart';
import 'package:gigX/data/network/network_api_services.dart';
import 'package:gigX/service/local_storage_service.dart';
import 'package:gigX/service/toastService.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:get/get_connect/http/src/multipart/multipart_file.dart' as multipart;
import 'package:dio/dio.dart' as dio;
import 'package:intl/intl.dart';

import '../models/debouncer.dart';

class HomeScreenViewModel extends GetxController {
  RxBool isLoading = false.obs;
  setLoading(val) {
    isLoading.value = val;
  }

  // RxBool isDark = false.obs;
  HomeScreenViewModel() {
    // isDark.value = LocalStorageService().readBool(LocalStorageKeys.isDark) ?? false;
  }

  Rx<Color> pickerColor = Color.fromARGB(255, 230, 50, 53).obs;
  Rx<Color> changeColor = Colors.green.obs;
  RxBool isColorPicked = false.obs;

  onColorChanged(val) {
    pickerColor.value = val;
    isColorPicked.value = true;

    print(pickerColor.value);
  }

  Future getDeviceToken() async {
    //request user permission for push notification
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging _firebaseMessage = FirebaseMessaging.instance;
    String? deviceToken = await _firebaseMessage.getToken();
    print('This is device token : $deviceToken');
    return (deviceToken == null) ? "" : deviceToken;
  }

  Map<String, dynamic> productList = {};
  // ProjectModels? projectResponse;
  Future getProjects() async {
    setLoading(true);
    final _apiServices = NetworkApiServices();
    await _apiServices.getAPI('${API.base_url}/todo-projects').then((value) {
      productList = value;
      projects = value['data'];
      print('avalue ho: ${value['data']}');
      setLoading(false);
    }).onError((error, stackTrace) {
      print(error.toString());
      setLoading(false);
    });
    print('Is loading ko value : ${isLoading.value}');
  }

  var projects = [];

  Future<void> getProjectsFromSearch(String search) async {
    // final _dio = Dio();
    // setLoading(true);

    // // Map<St  Future<void> getVehicles(String type) asyn2 {ring, dynamic> arrayTest;

    // var access_token = LocalStorageService().read(LocalStorageKeys.accessToken);
    // print('Access Token' + access_token.toString());
    // try {
    //   dio.Response response = await _dio.get(API.base_url + 'todo-projects',
    //       options: Options(headers: {"authorization": "Bearer $access_token"}));
    //   Map result = response.data;
    //   print('Status Code ' + response.statusCode.toString());

    //   if (response.statusCode == 200) {
    //     projects = response.data['data'];
    //     setSearchResults(search);

    //     print(projects);
    //   }
    //   setLoading(false);

    //   return null;
    // } on DioError catch (e) {
    //   setLoading(false);
    //   return null;
    // }
    final _apiServices = NetworkApiServices();
    try {
      var response = await _apiServices.getAPI('${API.base_url}/todo-projects');
      projects = response['data'];
      setSearchResults(search);
    } catch (e) {}
  }

  void setSearchResults(String query) {
    isLoading.value = true;
    projects = projects
        .where((elem) =>
            elem['title']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            elem['description']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();
    isLoading.value = false;
  }

  RxBool isSearchVisible = true.obs;
  changeSearchStatus(val) {
    isSearchVisible.value = val;
  }

  TextEditingController searchController = TextEditingController();

  String keySearch = '';
  late Debouncer<String> searchQuery = Debouncer(Duration(seconds: 1), (query) {
    keySearch = query;
    getProjects();
    // searchProducts();
  }, '');

  final titleController = TextEditingController().obs;
  final descriptionController = TextEditingController().obs;
  // Rx<DateTime> startDate = DateTime.now().obs;
  // Rx<DateTime> endDate = DateTime.now().obs;
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  onStartAndEndDateTimeChanged(start, end) {
    startDate.value = start;
    endDate.value = end;
    print(startDate.value);
    print(endDate.value);
  }

  // Rx<File> galleryImage = Rx<File?>(null);
  File? image1;
  final Rx<File?> galleryImage = Rx<File?>(null);
  RxString fileName = ''.obs;
  RxString bytes = ''.obs;
  Rx<Uint8List> byteArray = Uint8List(0).obs;
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
      );
      if (image == null) return null;
      final path = image.path;
      galleryImage.value = File(image.path);
      image1 = File(image.path);
      print(image1!.path);

      fileName.value = (image.path.split('/').last);

      byteArray.value = await File(path).readAsBytesSync();
      // cropImage();
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  createProjects() async {
    EasyLoading.show();
    var formData = dio.FormData.fromMap({
      'title': titleController.value.text,
      'description': descriptionController.value.text,
      'start_date': DateFormat('dd/MM/yyyy HH:mm').format(startDate.value!),
      'end_date': DateFormat('dd/MM/yyyy HH:mm').format(endDate.value!),
      'color_code': '#FFF',
      'logo': await dio.MultipartFile.fromBytes(byteArray.value,
          filename: fileName.value),
    });
    print(formData);

    final _apiService = NetworkApiServices();
    await _apiService
        .postAPI('${API.base_url}/todo-projects', formData)
        .then((value) {
      if (value != null) {
        ToastService().s('Project created!');
        titleController.value.clear();
        descriptionController.value.clear();
        startDate.value = null;
        image1 = null;
        Get.back();
        getProjects();
      } else {
        ToastService().e('Something went wrong!');
      }
      print(value);
    }).onError((error, stackTrace) {
      print(error.toString());
    });
    EasyLoading.dismiss();
  }
}
