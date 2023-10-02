import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get/get.dart';
import 'package:gigX/service/local_storage_service.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }

  HomeController() {
    isDark = LocalStorageService().readBool(LocalStorageKeys.isDark) ?? false;
  }

  bool isDark = false;
}
