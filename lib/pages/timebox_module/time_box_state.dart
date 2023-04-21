import 'package:calendar_view/calendar_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gigX/apiModels/timeBox.dart';
import 'package:gigX/service/toastService.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../api.dart';
import '../../models/meeting.dart';

class TimeBoxState extends ChangeNotifier {
  CalendarController calendarController = CalendarController();
  TimeBoxState() {
    print(DateTime.now());
    var vartime = DateFormat('dd/MM/yyyy').format(DateTime.now());
    print('yo var time ho: $vartime');
    getTimeBoxDetails(vartime);
    // getTimeBoxDetails('05/05/2023');

    // calendarController.selectedDate = DateTime(2022, 02, 05);
    // calendarController.displayDate = DateTime(2022, 02, 05);
  }

  List events = [];
  SharedPreferences? preferences;
  String? access_token;
  TimeBoxModel? timeBoxResponse;

  TextEditingController prioritiesController = TextEditingController();
  TextEditingController brainDumpController = TextEditingController();
  TextEditingController taskController = TextEditingController();

  String? taskData;
  onTaskDataChanged(val) {
    taskData = val;
    notifyListeners();
  }

  List time_list = [];
  List task_list = [];

  saveTimeBox(timebox_date) async {
    final _dio = new Dio();
    preferences = await SharedPreferences.getInstance();
    task_list.add(taskData);
    time_list.add(timebox_date);

    access_token = preferences?.getString('access_token');

    Map<String, dynamic> timeboxMap = {
      // 'timebox_date':
      //     DateFormat('dd/MM/yyyy').format(DateTime.parse(timebox_date)),
      'timebox_date': timebox_date,
      'top_priorities': prioritiesController.text,
      'brain_dump': brainDumpController.text,
      'task_time[]': time_list,
      'task_list[]': task_list
    };

    print(timeboxMap);

    // try {
    //   final formData = FormData.fromMap(timeboxMap);
    //   Response response = await _dio.post(API.base_url + 'todo-timebox',
    //       data: formData,
    //       options: Options(headers: {
    //         "Content-type": "multipart/form-data",
    //         "authorization": "Bearer " + access_token.toString()
    //       }));
    // } on DioError catch (e) {
    //   print(e.message);
    // }
  }

  bool isLoading = false;
  setLoading(val) {
    isLoading = val;
    notifyListeners();
  }

  getTimeBoxDetails(timebox_date) async {
    setLoading(true);
    Dio _dio = Dio();
    // var taskList = [];

    preferences = await SharedPreferences.getInstance();

    access_token = preferences?.getString('access_token');

    // print(DateFormat('dd/MM/yyyy').format(DateTime.parse(timebox_date)));
    try {
      Response response = await _dio.get(
          API.base_url + 'todo-timebox?timebox_date=$timebox_date',
          options: Options(headers: {"authorization": "Bearer $access_token"}));
      // Map result = response.data;
      timeBoxResponse = TimeBoxModel.fromJson(response.data);
      // events = timeBoxResponse!.data!.tasklist!;
      notifyListeners();

      // timeBoxResponse!.data!.tasklist!.forEach((el) {
      //   task_list.add(el.task);
      // });

      // timeBoxResponse!.data!.tasklist!.forEach((el) {
      //   time_list.add(el.time);
      // });

      // print(timeBoxResponse!.data!.tasklist!.first.fulltime as DateTime);
      // var varTime =
      //     DateTime.parse(timeBoxResponse!.data!.tasklist!.first.fulltime!);
      // print(varTime);
      // print(varTime.runtimeType);
      // timeBoxResponse?.data?.taskList == [] ||
      //         timeBoxResponse?.data?.taskList == null
      //     ? ToastService().i('No events available for today!')
      //     : timeBoxResponse!.data!.tasklist!.forEach((element) {
      //         eventList.add(CalendarEventData(
      //             title: element.task!,
      //             startTime: DateTime.parse(element.fulltime!),
      //             date:
      //                 DateTime.parse(timeBoxResponse!.data!.timeboxFulltime!)));
      //       });
      print(time_list);
      await getDataSource();
      notifyListeners();

      print(' error ho yo : ${response.data}');
    } on DioError catch (e) {
      print('🤯 dyam dyam');
      print(e.response);
      // if (e.response?.statusCode == 401) {
      //   preferences?.setBool('someoneLoggedIn', true);
      //   await preferences?.remove('access_token');
      //   // Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      //   //   MaterialPageRoute(
      //   //     builder: (BuildContext context) {
      //   //       return const Login();
      //   //     },
      //   //   ),
      //   //   (_) => false,
      //   // );
      // }
    }
    setLoading(false);
  }

  final event = [
    CalendarEventData(
      date: DateTime.now(),
      event: "Event 1",
      title: 'New title',
    )
  ];
  List<CalendarEventData> eventList = [];

  List<Meeting> getDataSource() {
    print('eta vitra xirey haii..');
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    if (timeBoxResponse!.data != null)
      timeBoxResponse!.data!.tasklist!.forEach((el) {
        var fullTime = DateTime.parse(el.fulltime!);
        var aarkoTime = DateTime(
            fullTime.year, fullTime.month, fullTime.day, fullTime.hour);
        print('aarko time: $aarkoTime');
        // print(
        //     '${fullTime.year}, ${fullTime.month}, ${fullTime.day}, ${fullTime.hour}');
        meetings.add(Meeting(
            el.task!,
            DateTime(
                fullTime.year, fullTime.month, fullTime.day, fullTime.hour),
            DateTime(
                fullTime.year, fullTime.month, fullTime.day, fullTime.hour + 1),
            Colors.green,
            false));
      });

    return meetings;
  }
}
