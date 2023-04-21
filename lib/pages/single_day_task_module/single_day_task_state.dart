import 'package:calendar_builder/calendar_builder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gigX/service/toastService.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../api.dart';
import '../../apiModels/myTodosModel.dart';
import '../../login.dart';

class SingleDayTaskState extends ChangeNotifier {
  // String date;
  var date;
  SingleDayTaskState(context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      date = args;
      notifyListeners();
    }
    
    print(date);
    getUserTasks();
  }
  MyTodos myTodosResponse = MyTodos();
  bool isLoading = false;
  SharedPreferences? preferences;
  setLoading(val) {
    isLoading = val;
    notifyListeners();
  }

  DateTime focusedDate = DateTime.now();

  bool isPressed = false;
  onPressed() {
    isPressed = !isPressed;
    notifyListeners();
    print(isPressed);
  }

  onDateChanged(val, tempFocusedDay) {
    focusedDate = tempFocusedDay;
    date = val;
    notifyListeners();
    // print(focusedDate);
    // print(date);
    getUserTasks();
  }

  onHolidayChanged(day) {
    if (day == DateTime.saturday && day == DateTime.sunday) {
      return true;
    }
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;

  onFormatChanged(format) {
    if (_calendarFormat != format) {
      // Call `setState()` when updating calendar format

      _calendarFormat = format;
      notifyListeners();
      print(_calendarFormat);
    }
  }

  Map<String, dynamic> commentMap = {};

  onCommentChanged(String val) {
    if (commentMap[val] == null) {
      commentMap[val] = true;
      notifyListeners();
    } else if (commentMap[val] == true) {
      commentMap[val] = false;
      notifyListeners();
    } else if (commentMap[val] == false) {
      commentMap[val] = true;
      notifyListeners();
    }
    print(commentMap[val]);
  }

  getUserTasks() async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    setLoading(true);
    final _dio = Dio();
    String? access_token;
    this.preferences = await SharedPreferences.getInstance();
    access_token = this.preferences?.getString('access_token');
    notifyListeners();

    try {
      Response response = await _dio.get(
          '${API.base_url}my/todos?today=$formattedDate',
          options: Options(headers: {"authorization": "Bearer $access_token"}));
      print(formattedDate);
      if (response.statusCode == 200) {
        this.preferences?.setBool('someoneLoggedIn', false);
        myTodosResponse = MyTodos.fromJson(response.data);
        print(response.data);
      } else if (response.statusCode == 401) {
        await this.preferences?.remove('access_token');
        ToastService().e('Session Expired, Proceed to login');
        // Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        //   MaterialPageRoute(
        //     builder: (BuildContext context) {
        //       return const Login();
        //     },
        //   ),
        //   (_) => false,
        // );
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        this.preferences?.setBool('someoneLoggedIn', true);
        await this.preferences?.remove('access_token');
        ToastService().e('Session Expired, Proceed to login');

        // Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        //   MaterialPageRoute(
        //     builder: (BuildContext context) {
        //       return const Login();
        //     },
        //   ),
        //   (_) => false,
        // );
      }
    }
    setLoading(false);
  }
}
