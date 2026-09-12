import 'dart:developer';

import 'package:dio/dio.dart';

class CustomDioException implements Exception {
  late String errorMessage;
  String? responseCode;

  CustomDioException.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        errorMessage = "Request to server was canceled";
        break;
      case DioExceptionType.connectionError ||
          DioExceptionType.sendTimeout ||
          DioExceptionType.receiveTimeout ||
          DioExceptionType.connectionTimeout:
        errorMessage =
            "A connection error occured. Please check your internet and try again";
      case DioExceptionType.unknown:
        errorMessage = 'Unexpected error occurred.';
        break;
      default:
       
        errorMessage =
            "Oops. Something went wrong. It's not your fault";
        break;
    }
    log("Error message ===> $errorMessage");
  }

  @override
  String toString() => errorMessage;
}
