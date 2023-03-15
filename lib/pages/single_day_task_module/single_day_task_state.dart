import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api.dart';
import '../../apiModels/myTodosModel.dart';
import '../../login.dart';

class SingleDayTaskState extends ChangeNotifier {
  SingleDayTaskState(context) {
    getUserTasks(context);
  }
  MyTodos myTodosResponse = MyTodos();
  bool isLoading = false;
  SharedPreferences? preferences;
  setLoading(val) {
    isLoading = val;
    notifyListeners();
  }

  getUserTasks(context) async {
    setLoading(true);
    final _dio = Dio();
    String? access_token;
    this.preferences = await SharedPreferences.getInstance();
    access_token = this.preferences?.getString('access_token');
    notifyListeners();

    try {
      Response response = await _dio.get(API.base_url + 'my/todos',
          options: Options(headers: {"authorization": "Bearer $access_token"}));

      if (response.statusCode == 200) {
        this.preferences?.setBool('someoneLoggedIn', false);
        myTodosResponse = MyTodos.fromJson(response.data);
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
