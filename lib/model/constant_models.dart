import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ConstantModels extends GetxController {
  RxBool isLoading = false.obs;
  setLoading(val) {
    isLoading.value = val;
  }
}
