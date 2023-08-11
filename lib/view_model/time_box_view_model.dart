import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TimeBoxViewModel extends GetxController {
  List colors = [
    'Red',
    'Blue',
    'Green',
    'Yellow',
    'Purple',
    'Pink',
    'Orange',
    'Brown',
    'Black'
        'White',
    'Gray',
  ];

  RxString selectedColor = 'red'.obs;
  RxBool isColorPicked = false.obs;

  // onSelectedColorsChanged(val) {
  //   selectedColor.value = val;
  //   print(selectedColor.value);
  //   print(isColorPicked.value);
  // }

  Rx<Color> pickerColor = Color.fromARGB(255, 230, 50, 53).obs;
  Rx<Color> changeColor = Colors.green.obs;

  onColorChanged(val) {
    pickerColor.value = val;
    isColorPicked.value = true;

    print(pickerColor.value);
  }
}
