import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageKeys {
  static const accessToken = "access_token";
  static const isFirstTime = "isFirstTime";
  static const isDark = 'isDark';
  // static const bookingId = 'bookingId';
  // static const chargerData = 'chargerData';
  static const email = 'email';
  static const password = 'password';
}

class LocalStorageService {
  final _box = GetStorage();

  static Future<void> init() {
    return GetStorage.init();
  }

  String? read(key) {
    return _box.read(key);
  }

  

  bool? readBool(key) {
    return _box.read(key);
  }

  Future<void> write(String key, dynamic value) {
    print('write vayo haii token');
    print('key wala token $value');
    return _box.write(key, value);
  }

  Future<void> clear(String key) {
    return _box.remove(key);
  }

  bool isEmpty(String key) {
    return _box.read(key) == null;
  }

  bool isNotEmpty(String key) {
    return _box.read(key) != null;
  }
}
