import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pulse/api/endpoints.dart';
import 'package:pulse/api/logging_interceptor.dart';

void setupServices() {
  GetIt getIt = GetIt.instance;

  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Endpoints.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        responseType: ResponseType.json,
        contentType: Headers.jsonContentType,
      ),
    );

    dio.interceptors.add(LoggingInterceptor());
    return dio;
  });
}
