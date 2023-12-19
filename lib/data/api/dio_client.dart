import 'package:dio/dio.dart';
import 'package:flutter_app_sale_25042023/common/app_constants.dart';
import 'package:flutter_app_sale_25042023/data/local/app_sharepreference.dart';

class DioClient {
  // Singleton pattern
  static Dio? _instance;

  static Dio getInstance() => _instance ??= createDio();

  static Dio createDio() {
    Dio dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        baseUrl: AppConstants.BASE_URL
    ));

    dio.interceptors.add(LogInterceptor());
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      String token = AppSharePreference.getString(AppConstants.KEY_TOKEN);
      options.headers["Authorization"] = "Bearer $token";
      return handler.next(options);
    }));
    return dio;
  }
}