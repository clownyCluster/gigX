import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigX/api.dart';
import 'package:gigX/data/network/network_api_services.dart';

import '../models/debouncer.dart';

class NotificationViewModel extends GetxController {
  NotificationViewModel() {
    getNotifications();
  }
  RxBool isSearchVisible = true.obs;
  changeSearchStatus(val) {
    isSearchVisible.value = val;
  }

  TextEditingController searchController = TextEditingController();

  String keySearch = '';
  late Debouncer<String> searchQuery = Debouncer(Duration(seconds: 1), (query) {
    keySearch = query;
    // getProjects();
    // searchProducts();
  }, '');

  Future getNotifications() async {
    print('get Notification chalyo');
    final _apiServices = NetworkApiServices();
    try {
      var response =
          await _apiServices.getAPI('${API.base_url}my/todo-notifications');
      print(response);
    } catch (e) {
      print(e);
    }
  }
}
