import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:gigX/data/api_model/commentModels.dart';

import '../api.dart';
import '../data/api_model/taskModel.dart';
import '../data/network/network_api_services.dart';

class ProjectDetailsEditViewModel extends GetxController {
  ProjectDetailsEditViewModel() {
    if (Get.arguments != null) {
      taskData = Get.arguments;
      print('Yo task Data ho: ${taskData.toString()}');
    }
    getComments();
  }
  TaskModel? taskResponse;

  TaskData? taskData;

  RxBool isLoading = false.obs;
  setLoading(val) {
    isLoading.value = val;
  }

  CommentModels? commentResponse;

  Future getComments() async {
    setLoading(true);
    final _apiServices = NetworkApiServices();

    try {
      var response = await _apiServices
          .getAPI('${API.base_url}/todo-comment/${taskData!.projectId}/0');
      commentResponse = CommentModels.fromJson(response);
      print('Yo comment ho :${response.toString()}');
    } on DioError catch (e) {
      print(e.response);
    }
    setLoading(false);
  }
}
