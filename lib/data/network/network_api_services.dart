import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:gigX/service/local_storage_service.dart';

import '../app_exceptions.dart';
import 'base_api_services.dart';

class NetworkApiServices extends BaseApiServices {
  Dio dio = Dio();
  @override
  Future<dynamic> getAPI(String url) async {
    final accessToken =
        LocalStorageService().read(LocalStorageKeys.accessToken);
    if (kDebugMode) {
      print(url);
    }
    dynamic jsonResponse;
    try {
      final response = await dio
          .get(url,
              options: Options(headers: {
                'Authorization': 'Bearer $accessToken',
              }))
          .timeout(
            Duration(seconds: 10),
          );
      jsonResponse = returnResponse(response);
    } on SocketException {
      throw InternetException('Please connect to the Internet');
    } on RequestTimeOutException {
      throw TimeoutException('Requested time out');
    }
    return jsonResponse;
  }

  Future<dynamic> postAPI(String url, var data) async {
    final accessToken =
        LocalStorageService().read(LocalStorageKeys.accessToken);
    if (kDebugMode) {
      print('Network service ko post api');

      print(url);
      print(data);
    }
    dynamic jsonResponse;
    try {
      final response = await dio
          .post(url,
              data: data,
              options: Options(headers: {
                'Authorization': 'Bearer $accessToken',
              }))
          .timeout(Duration(seconds: 10));
      jsonResponse = returnResponse(response);
    } on SocketException {
      throw InternetException('Please connect to the Internet');
    } on RequestTimeOutException {
      throw TimeoutException('Requested time out');
    } on DioError catch (e) {
      print(e);
      print(e.response);
    }
    return jsonResponse;
  }

  Future<dynamic> patchAPI(String url, var data) async {
    final accessToken =
        LocalStorageService().read(LocalStorageKeys.accessToken);
    if (kDebugMode) {
      print(url);
      print(data);
    }
    dynamic jsonResponse;
    try {
      final response = await dio
          .patch(url,
              data: data,
              options: Options(headers: {
                'Authorization': 'Bearer $accessToken',
              }))
          .timeout(Duration(seconds: 10));
      jsonResponse = returnResponse(response);
    } on SocketException {
      throw InternetException('Please connect to the Internet');
    } on RequestTimeOutException {
      throw TimeoutException('Requested time out');
    }
    return jsonResponse;
  }

  Future<dynamic> putAPI(String url, var data) async {
    final accessToken =
        LocalStorageService().read(LocalStorageKeys.accessToken);
    if (kDebugMode) {
      print(url);
      print(data);
    }
    dynamic jsonResponse;
    try {
      final response = await dio
          .put(url,
              data: data,
              options: Options(headers: {
                'Authorization': 'Bearer $accessToken',
              }))
          .timeout(Duration(seconds: 10));
      jsonResponse = returnResponse(response);
    } on SocketException {
      throw InternetException('Please connect to the Internet');
    } on RequestTimeOutException {
      throw TimeoutException('Requested time out');
    }
    return jsonResponse;
  }

  Future<dynamic> deleteAPI(String url, var data) async {
    final accessToken =
        LocalStorageService().read(LocalStorageKeys.accessToken);
    if (kDebugMode) {
      print(url);
      print(data);
    }
    dynamic jsonResponse;
    try {
      final response = await dio
          .delete(url,
              data: data,
              options: Options(headers: {
                'Authorization': 'Bearer $accessToken',
              }))
          .timeout(Duration(seconds: 10));
      jsonResponse = returnResponse(response);
    } on SocketException {
      throw InternetException('Please connect to the Internet');
    } on RequestTimeOutException {
      throw TimeoutException('Requested time out');
    }
    return jsonResponse;
  }

  dynamic returnResponse(dynamic response) {
    switch (response.statusCode) {
      case 200:
        // dynamic responseJson = jsonDecode(response);
        // return responseJson;
        print('Yo return respone ko response ho');

        return response.data;
      // case 400:
      //   throw NotFoundException('No data found');
      // case 500:
      //   throw ServerException('Error occured communicating with the server');
      default:
        // throw DefaultException('Issue');
        // dynamic responseJson = jsonDecode(response.data);
        return response.data;
    }
  }
}
