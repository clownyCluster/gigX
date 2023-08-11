import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gigX/api.dart';
import 'package:gigX/data/api_model/projectModel.dart';
import 'package:gigX/data/api_model/taskModel.dart';
import 'package:gigX/data/api_model/taskModels.dart';
import 'package:gigX/data/api_model/userModel.dart';
import 'package:gigX/data/network/network_api_services.dart';
import 'package:dio/dio.dart' as dio;
import 'package:gigX/service/local_storage_service.dart';
import 'package:gigX/view_model/home_view_model.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';

class TaskViewModel extends GetxController {
  TaskViewModel() {
    isDark.value = LocalStorageService().readBool(LocalStorageKeys.isDark)!;
    getUsers();
    events = {
      DateTime(2023, 8, 1): ['Event 1'],
      DateTime(2023, 8, 5): ['Event 2'],
      DateTime(2023, 8, 10): ['Event 3'],
    };
  }

  RxBool isDark = false.obs;
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
    setLoading(true);
    final _apiServices = NetworkApiServices();
    try {
      var response = await _apiServices.getAPI('${API.base_url}users/select2');
      await getProjects();
      print('User ko data : $response');
      userResponse = UserModel.fromJson(response);
      setLoading(false);
    } catch (e) {
      setLoading(false);
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
  RxBool isLoading = false.obs;

  setLoading(val) {
    isLoading.value = val;
  }

  onUserChanged(index, val) {
    selectedUser.value = index;
    userId.value = val;
  }

  TodoModels? todoResponse;

  getTasks() async {
    final _apiServices = NetworkApiServices();
    try {
      var response = await _apiServices.getAPI('${API.base_url}/my-todos');

      todoResponse = TodoModels.fromJson(response);
    } on DioError catch (e) {
      print('get task ko error');
      print(e);
      print(e.response);
    }
  }

  Map<DateTime, List>? events;

  final calendarController = CleanCalendarController(
    minDate: DateTime.now(),
    maxDate: DateTime.now().add(Duration(days: 365)),
    weekdayStart: DateTime.sunday,
    initialDateSelected: DateTime.now(),
  );

  RxInt selectedProject = 0.obs;
  RxInt projectId = 0.obs;
  onProjectChanged(index, val) {
    selectedProject.value = index;
    projectId.value = val;
  }

  Map<String, List> mySelectedEvents = {};

  List listOfEvents(DateTime dateTime) {
    if (mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)] != null) {
      return mySelectedEvents[DateFormat('yyyy-MM-dd').format(dateTime)]!;
    } else
      return [];
  }
  // onUserChanged(index, val) {
  //   if (selectedUser != null &&
  //       userResponse != null &&
  //       userResponse!.data != null) {
  //     selectedUser!.value = index;
  //     userId!.value = val;

  //     if (selectedUser!.value < userResponse!.data!.length) {
  //       print(userResponse!.data![selectedUser!.value].username);
  //     } else {
  //       print('Invalid selectedUser index');
  //     }
  //   } else {
  //     print('Data is not available or selectedUser is null');
  //   }
  // }

  Future createTask() async {
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
      print(response);
      getTasks();
    } catch (e) {
      print(e);
    }
  }
}
