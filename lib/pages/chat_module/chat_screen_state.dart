import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gigX/data/network/network_api_services.dart';

import '../../appRoute/routeName.dart';
import '../../data/app_exceptions.dart';
import '../../service/toastService.dart';

class ChatScreenState extends ChangeNotifier {
  String selectedStatus = 'Chats';
  onSelectedStatusChanged(val) {
    selectedStatus = val;
    fetchData();
    notifyListeners();
  }

  Future<void> fetchData() async {
    final _apiServices = NetworkApiServices();
    try {
      final apiResponse = await _apiServices
          .getAPI('http://api.efleetpass.com.au/todo-projects');
    } catch (e) {
      ToastService().e(e.toString());
    }
  }
}
