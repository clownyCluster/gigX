import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gigX/data/api_model/commentModels.dart';
import 'package:gigX/service/toastService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api.dart';
import '../data/api_model/taskModel.dart';
import '../data/network/network_api_services.dart';

class ProjectDetailsEditViewModel extends GetxController {
  ProjectDetailsEditViewModel() {
    if (Get.arguments != null) {
      taskData = Get.arguments;
      print('Yo task Data ho: ${taskData.toString()}');
    }
    getComments(true);
  }
  TaskModel? taskResponse;

  TaskData? taskData;

  RxBool isLoading = false.obs;
  setLoading(val) {
    isLoading.value = val;
  }

  CommentModels? commentResponse;

  Future getComments(bool? val) async {
    setLoading(val);
    final _apiServices = NetworkApiServices();

    try {
      var response = await _apiServices
          .getAPI('${API.base_url}/todo-comment/${taskData!.id}/0');
      commentResponse = CommentModels.fromJson(response);
      print('Yo comment ho :${response.toString()}');
    } on DioError catch (e) {
      print(e.response);
    }
    setLoading(false);
  }

  // Future<bool> saveComment() async {
  //   final _dio = new Dio();
  //   Map<String, dynamic> result = Map<String, dynamic>();
  //   final bytes;
  //   final compressed_bytes;

  //   final path = pickedFile?.path ?? '';
  //   var fileName = (pickedFile?.path.split('/').last) ?? '';

  //   if (path.isNotEmpty) {
  //     bytes = await File(path).readAsBytesSync();
  //     compressed_bytes = await FlutterImageCompress.compressWithList(
  //         bytes.buffer.asUint8List(),
  //         quality: 85,
  //         minWidth: 500,
  //         minHeight: 500);
  //   } else
  //     compressed_bytes = '';
  //   setState(() {
  //     access_token = this.preferences?.getString('access_token');
  //   });

  //   try {
  //     final formData = FormData.fromMap({
  //       'todo_id': taskData!.id,
  //       'parent_id': 0,
  //       'comment': comment,
  //       'percent_done': formatted_end_date,
  //       'status': category_id,
  //       'assign_to': assign_to_id,
  //       'attachment': compressed_bytes != ''
  //           ? await MultipartFile.fromBytes(compressed_bytes,
  //               filename: fileName)
  //           : null,
  //     });
  //     Response response = await _dio.post(API.base_url + 'todo-comment',
  //         data: formData,
  //         options: Options(headers: {
  //           "Content-type": "multipart/form-data",
  //           "authorization": "Bearer " + access_token.toString()
  //         }));
  //     print(response.data);
  //     if (response.statusCode == 200) {
  //       return true;
  //     } else
  //       return false;
  //   } on DioError catch (e) {
  //     print(e.message);
  //     return false;
  //   }
  // }

  RxString comment = ''.obs;
  onCommentChanged(val) {
    comment.value = val;
  }

  Future postComment() async {
    EasyLoading.show();
    var data = {
      'todo_id': taskData!.id,
      'parent_id': 0,
      'comment': comment.value,
      'percent_done': taskData!.percentDone,
      'status': taskData!.category,
      'assign_to': taskData!.assignTo,
    };
    final _apiServices = NetworkApiServices();
    print(data);
    try {
      var response =
          await _apiServices.postAPI('${API.base_url}/todo-comment', data);
      print(response);
      getComments(false);

      comment.value = '';
      // ToastService().s('Comment posted successfully!');
    } catch (e) {
      ToastService().e(e.toString());
      print(e);
    }
    EasyLoading.dismiss();
  }
}
