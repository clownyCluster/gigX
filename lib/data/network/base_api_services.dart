abstract class BaseApiServices {
  Future<dynamic> getAPI(String url) async {}
  Future<dynamic> postAPI(String url, dynamic data) async {}
  Future<dynamic> patchAPI(String url, dynamic data) async {}
  Future<dynamic> deleteAPI(String url, dynamic data) async {}


}
