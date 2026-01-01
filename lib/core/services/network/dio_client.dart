import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:furniture_ecommerce_app/core/services/network/interceptors/crashlytics_interceptor.dart';
import 'package:furniture_ecommerce_app/core/services/storage/secure_storage_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'interceptors/auth_interceptor.dart';

/// Provides a configured Dio instance for making HTTP requests.
/// 
/// Features:
/// - Singleton Dio instance for efficient reuse
/// - Environment-based base URL configuration
/// - Authentication via interceptor
/// - Crashlytics error logging
/// - Debug-only request/response logging
class DioClient {
  final SecureStorageService _secureStorage;
  late final Dio _dio;

  DioClient(this._secureStorage) {
    _dio = _createDio();
  }

  Dio get dio => _dio;

  Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000/api',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(AuthInterceptor(_secureStorage));
    dio.interceptors.add(CrashlyticsInterceptor());

    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: true,
      ));
    }

    return dio;
  }
}
