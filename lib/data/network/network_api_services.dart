import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:gigX/appRoute/routeName.dart';
import 'package:gigX/service/local_storage_service.dart';
import 'package:gigX/service/toastService.dart';

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
      if (response.statusCode == 200) {
        jsonResponse = returnResponse(response);
      }
    } on DioError catch (e) {
      _handleApiException(e);
      rethrow;
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
    } on DioError catch (e) {
      if (e.response?.statusCode == 400) {
        final responseData = e.response?.data ?? {};
        final errorMessage = responseData['message'] ?? 'Validation error';
        throw BadRequestException(errorMessage);
      }
      _handleApiException(e); // Handle other exceptions
      rethrow;
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
    } on DioError catch (e) {
      _handleApiException(e);
      rethrow;
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
    } on DioError catch (e) {
      _handleApiException(e);
      rethrow;
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
    } on DioError catch (e) {
      _handleApiException(e);
      rethrow;
    }
    return jsonResponse;
  }

  void _handleApiException(DioError e) {
    if (e.type == DioErrorType.connectTimeout ||
        e.type == DioErrorType.receiveTimeout ||
        e.type == DioErrorType.sendTimeout) {
      throw RequestTimeOutException();
    } else if (e.type == DioErrorType.response) {
      final statusCode = e.response!.statusCode;
      final responseData = e.response!.data;

      switch (statusCode) {
        case 400:
          throw BadRequestException(responseData['message']);
        case 401:
          Get.offNamedUntil(RouteName.loginScreen, (route) => false);
          throw UnauthorizedException(responseData['message']);

        case 403:
          throw ForbiddenException(responseData['message']);
        case 404:
          throw NotFoundException(responseData['message']);
        case 500:
          throw ServerException(responseData['message']);
        default:
          throw DefaultException(responseData['message']);
      }
    } else {
      throw InternetException();
    }
  }

  dynamic returnResponse(dynamic response) {
    final statusCode = response.statusCode;
    final responseData = response.data;

    switch (statusCode) {
      case 200:
        // Successful response
        return responseData;
      case 400:
        throw BadRequestException('Bad request: ${responseData['message']}');
      case 401:
        throw UnauthorizedException('Unauthorized: ${responseData['message']}');
      case 403:
        throw ForbiddenException('Forbidden: ${responseData['message']}');
      case 404:
        throw NotFoundException('Not found: ${responseData['message']}');
      case 500:
        throw ServerException(
            'Internal server error: ${responseData['message']}');
      default:
        throw DefaultException('An error occurred: ${responseData['message']}');
    }
  }
}
