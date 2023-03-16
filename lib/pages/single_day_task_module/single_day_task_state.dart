import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api.dart';
import '../../apiModels/myTodosModel.dart';
import '../../login.dart';

var date;

class SingleDayTaskState extends ChangeNotifier {
  // String date;
  SingleDayTaskState(context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      date = args;
      notifyListeners();
    }
    print(date);
    getUserTasks(context);
  }
  MyTodos myTodosResponse = MyTodos();
  bool isLoading = false;
  SharedPreferences? preferences;
  setLoading(val) {
    isLoading = val;
    notifyListeners();
  }

  bool isPressed = false;
  onPressed() {
    isPressed = !isPressed;
    notifyListeners();
    print(isPressed);
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

  getUserTasks(context) async {
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
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const Login();
            },
          ),
          (_) => false,
        );
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        this.preferences?.setBool('someoneLoggedIn', true);
        await this.preferences?.remove('access_token');
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const Login();
            },
          ),
          (_) => false,
        );
      }
    }
    setLoading(false);
  }
}
