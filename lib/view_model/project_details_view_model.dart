import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gigX/api.dart';
import 'package:gigX/data/api_model/taskModel.dart';
import 'package:gigX/data/network/network_api_services.dart';
import 'package:gigX/service/local_storage_service.dart';
import 'package:gigX/service/toastService.dart';
import 'package:intl/intl.dart';

import '../data/api_model/projectModel.dart';
import '../data/api_model/taskModels.dart';
import '../data/api_model/userModel.dart';
import 'package:dio/dio.dart' as dio;

class ProjectDetailsViewModel extends GetxController {
  // @override
  // void onInit() {
  //   super.onInit();
  //   getTask(selectedProjectId)
  // }

  ProjectDetailsViewModel() {
    // isDark.value = LocalStorageService().readBool(LocalStorageKeys.isDark) ?? false;
    if (Get.arguments != null) {
      selectedProjectId = Get.arguments;
      projectId.value = selectedProjectId;
    }
    print('state ko constructor chalyo haii');
    getTask();
  }

  // RxBool isDark = false.obs;
  var selectedProjectId;

  RxString projectStatus = 'InCompleted Tasks'.obs;
  onProjectStatusChanged(val) {
    projectStatus.value = val;
    if (projectStatus.value == 'InCompleted Tasks') {
      print('chaleko thiyo haii');
      taskResponse = taskResponse!.data!
          .where((element) => element.category == 0)
          .toList() as TaskModel;
    } else if (projectStatus.value == 'Completed Tasks') {
      taskResponse = taskResponse!.data!
          .where((element) => element.category == 1)
          .toList() as TaskModel;
    } else if (projectStatus.value == 'Inprogress') {
      taskResponse = taskResponse!.data!
          .where((element) => element.category == 2)
          .toList() as TaskModel;
    }
  }

  TaskModel? taskResponse;

  RxBool isLoading = false.obs;
  setLoading(val) {
    isLoading.value = val;
  }

  Future getTask() async {
    setLoading(true);
    final _apiServices = NetworkApiServices();
    try {
      var response = await _apiServices
          .getAPI('${API.base_url}todos/$selectedProjectId/0');
      getUsers();
      print(response);

      taskResponse = TaskModel.fromJson(response);
      print(taskResponse!.data!.first.title);
    } catch (e) {
      print(e);
    }
    setLoading(false);
  }

  RxString taskStatus = 'Todo'.obs;
  onTaskStatusChanged(val) {
    taskStatus.value = val;
    taskStatus.value == 'Todo'
        ? statusId.value = 0
        : taskStatus.value == 'Inprogress'
            ? statusId.value = 1
            : taskStatus.value == 'Incomplete'
                ? statusId.value = 2
                : statusId.value = 3;
  }

  RxInt priorityId = 0.obs;
  RxInt statusId = 0.obs;
  RxString taskUrgency = 'Low'.obs;
  onTaskUrgencyChanged(val) {
    taskUrgency.value = val;
    taskUrgency.value == 'Low'
        ? priorityId.value = 0
        : taskUrgency.value == 'High'
            ? priorityId.value = 1
            : priorityId.value = 2;
  }

  final titleController = TextEditingController().obs;
  final descriptionController = TextEditingController().obs;
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);
  RxString stringStartDate = ''.obs;
  RxString stringEndDate = ''.obs;
  onStartAndEndDateTimeChanged(start, end) {
    startDate.value = start;
    endDate.value = end;
    stringEndDate.value = DateFormat('dd/MM/yyyy hh:mm').format(endDate.value!);
    stringStartDate.value =
        DateFormat('dd/MM/yyyy hh:mm').format(startDate.value!);
    print(stringEndDate);
  }

  RxDouble percent = 0.0.obs;
  onPercentChanged(val) {
    percent.value = val;
  }

  UserModel? userResponse;

  getUsers() async {
    final _apiServices = NetworkApiServices();
    try {
      var response = await _apiServices.getAPI('${API.base_url}users/select2');
      await getProjects();
      print('User ko data : $response');
      userResponse = UserModel.fromJson(response);
      userId.value = userResponse!.data!.first.id ?? 0;
    } catch (e) {
      print(e);
    }
    print('Is loading : $isLoading');
    // setLoading(false);
  }

  ProjectModels? projectResponse;
  Future getProjects() async {
    // setLoading(true);
    final _apiServices = NetworkApiServices();
    try {
      var response = await _apiServices.getAPI('${API.base_url}/todo-projects');
      await getTasks();
      print(response.toString());
      projectResponse = ProjectModels.fromJson(response);

      // setLoading(false);
    } catch (e) {
      print(e);
      // setLoading(false);
    }
    print('Is loading ko value : ${isLoading.value}');
  }

  RxInt selectedUser = 0.obs;
  RxInt userId = 0.obs;

  RxBool showUser = false.obs;

  onUserChanged(index, val) {
    selectedUser.value = index;
    userId.value = val;
    print(userId.value);
    showUser.value = true;
  }

  TodoModels? todoResponse;

  getTasks() async {
    final _apiServices = NetworkApiServices();
    try {
      var response = await _apiServices.getAPI('${API.base_url}/my/todos');
      print('YO get task ko error dekhauda ko error ho: $response');
      // todoResponse = TodoModels.fromJson(response);
    } on dio.DioError catch (e) {
      print('Get task ko error data : ${e.response}');
      print(e.response);
    }
  }

  RxInt selectedProject = 0.obs;
  RxInt projectId = 0.obs;
  RxBool showProject = false.obs;
  onProjectChanged(index, val) {
    selectedProject.value = index;
    projectId.value = val;
    showProject.value = true;
  }

  Future createTask() async {
    EasyLoading.show();
    final _apiServices = NetworkApiServices();
    final formData = dio.FormData.fromMap({
      'title': titleController.value.text,
      'description': descriptionController.value.text,
      'start_date': stringStartDate.value,
      'end_date': stringEndDate.value,
      'percent_done': percent.value,
      'project_id': projectId.value,
      'priority': priorityId.value,
      'category': statusId.value,
      'assign_to': userId.value
    });
    print(formData.fields.toString());
    try {
      var response =
          await _apiServices.postAPI('${API.base_url}/todos', formData);
      ToastService().s('Created Successfully');

      await getTask();

      titleController.value.clear();
      descriptionController.value.clear();
      showProject.value = false;
      showUser.value = false;
      Get.back();
      print(response);
    } catch (e) {
      print(e);
    }
    EasyLoading.dismiss();
  }
}
