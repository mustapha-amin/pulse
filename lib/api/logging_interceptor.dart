import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('➡️ [REQUEST] ${options.method} ${options.headers} ${options.uri}');
    if (kDebugMode) {
      log('Data: ${options.data}');
      log('Headers: ${options.headers}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
      '✅ [RESPONSE] ${response.statusCode} ${response.requestOptions.uri}',
    );
    if (kDebugMode) {
      log('Data: ${response.data}');
      log('Headers: ${response.headers}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log(
      '❌ [ERROR] ${err.response?.statusCode ?? "No status"} ${err.requestOptions.uri}',
    );
    if (kDebugMode) {
      log('Error: ${err.response?.data ?? err.message}');
    }
    handler.next(err);
  }
}
