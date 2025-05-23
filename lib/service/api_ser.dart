import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:finwise/service/exceptions.dart';
import 'package:flutter/material.dart';

class ApiService {
  final Dio _dio;

  ApiService({String? baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl ?? "http://192.168.8.18:4000",
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    /// Add interceptors if needed
    debugPrint("Base URL: $baseUrl");
    _dio.interceptors.add(
      LogInterceptor(
        responseBody: true,
        requestHeader: false,
        error: true,
        requestBody: true,
        responseHeader: false,
        request: true,
        logPrint: (object) => log(object.toString()),
      ),
    );

    /// Token blacklist interceptor
    // _dio.interceptors.add(AuthInterceptor(onTokenBlacklisted: () {
    //   BuildContext? context = navigatorKey.currentContext;
    //   if (context != null) {
    //     // publicProviderRef
    //     //     .read(userProvider.notifier)
    //     //     .logOut(serverLogout: false);
    //     context.goNamed(Routes.login.name);
    //   }
    // }));
  }

  /// Common function to build headers
  Map<String, String> _buildHeaders(
    bool isAuthorize,
    Map<String, String>? extraHeaders, {
    String? token,
  }) {
    Map<String, String> apiHeaders = {
      // 'devicemodel': deviceInfoService.safeDeviceName,
      // 'deviceuniqueid': deviceInfoService.safeDeviceID,
    };

    // if (isAuthorize) {
    //   apiHeaders['Authorization'] = "Bearer ${token ?? pref.getToken}";
    // }

    // if (extraHeaders != null) {
    //   apiHeaders.addAll(extraHeaders);
    // }

    return apiHeaders;
  }

  /// GET request
  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    bool isAuthorize = false,
    dynamic payload,
    Map<String, String>? headers,
  }) async {
    try {
      Map<String, String> apiHeaders = _buildHeaders(isAuthorize, headers);

      log(name: 'header', apiHeaders.toString());
      log(name: 'queryParameter', queryParameters.toString());

      return await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        data: payload,
        options: Options(headers: apiHeaders),
      );
    } on DioException catch (e) {
      throw ServerException(
        (e.response?.data as Map<String, dynamic>)['message'] ??
            'Something went wrong!',
      );
    }
  }

  /// POST request
  Future<Response> post(
    String endpoint, {
    dynamic payload,
    Map<String, dynamic>? queryParams,
    bool isAuthorize = false,
    String? token,
    Map<String, String>? headers,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      Map<String, String> apiHeaders = _buildHeaders(
        isAuthorize,
        headers,
        token: token,
      );

      // Detect and set content type
      final bool isMultipart = payload is FormData;
      final dioHeaders = {
        ...apiHeaders,
        'Content-Type':
            isMultipart ? 'multipart/form-data' : 'application/json',
      };

      log(name: 'header', dioHeaders.toString());
      log(name: 'body', payload.toString());

      return await _dio.post(
        endpoint,
        data: payload,
        queryParameters: queryParams,
        options: Options(headers: dioHeaders),
        onSendProgress: (count, total) {
          log(name: 'Progress', "$count/$total");
          if (onSendProgress != null) onSendProgress(count, total);
        },
      );
    } on DioException catch (e) {
      throw ServerException(
        (e.response?.data as Map<String, dynamic>)['message'] ??
            'Something went wrong!',
      );
    }
  }

  /// PUT request
  Future<Response> put(
    String endpoint, {
    dynamic data,
    bool isAuthorize = false,
    Map<String, String>? headers,
  }) async {
    try {
      Map<String, String> apiHeaders = _buildHeaders(isAuthorize, headers);

      log(name: 'header', apiHeaders.toString());
      log(name: 'body', data.toString());

      return await _dio.put(
        endpoint,
        data: data,
        options: Options(headers: apiHeaders),
      );
    } on DioException catch (e) {
      throw ServerException(
        (e.response?.data as Map<String, dynamic>)['message'] ??
            'Something went wrong!',
      );
    }
  }

  /// DELETE request
  Future<Response> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    bool isAuthorize = false,
    Map<String, String>? headers,
  }) async {
    try {
      Map<String, String> apiHeaders = _buildHeaders(isAuthorize, headers);

      log(name: 'header', apiHeaders.toString());
      log(name: 'queryParameter', queryParameters.toString());

      return await _dio.delete(
        endpoint,
        queryParameters: queryParameters,
        options: Options(headers: apiHeaders),
      );
    } on DioException catch (e) {
      throw ServerException(
        (e.response?.data as Map<String, dynamic>)['message'] ??
            'Something went wrong!',
      );
    }
  }

  /// PUT request with multipart/form-data (for file uploads)
  Future<Response> putMultipart(
    String endpoint, {
    required FormData formData,
    bool isAuthorize = false,
    String? token,
    Map<String, String>? headers,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      Map<String, String> apiHeaders = _buildHeaders(
        isAuthorize,
        headers,
        token: token,
      );

      final dioHeaders = {...apiHeaders, 'Content-Type': 'multipart/form-data'};

      log(name: 'PUT Multipart Headers', dioHeaders.toString());
      log(name: 'PUT Multipart FormData', formData.fields.toString());

      return await _dio.put(
        endpoint,
        data: formData,
        options: Options(headers: dioHeaders),
        onSendProgress: onSendProgress,
      );
    } on DioException catch (e) {
      throw ServerException(
        (e.response?.data as Map<String, dynamic>)['message'] ??
            'Something went wrong!',
      );
    }
  }
}
