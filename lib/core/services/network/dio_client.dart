import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fpdart/fpdart.dart';
import 'package:furniture_ecommerce_app/core/errors/failure.dart';
import 'package:furniture_ecommerce_app/core/services/network/interceptors/dio_interceptor.dart';
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
/// - Built-in error handling with automatic conversion to Failure objects
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
    dio.interceptors.add(DioInterceptor(_secureStorage));

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

  /// Executes an API call and handles errors automatically.
  /// 
  /// Usage:
  /// ```dart
  /// return _dioClient.handleApiCall<UserModel>(
  ///   () => _dioClient.dio.post('/auth/signup', data: {...}),
  ///   (response) => UserModel.fromJson(response.data),
  /// );
  /// ```
  Future<Either<Failure, T>> handleApiCall<T>(
    Future<Response> Function() apiCall,
    T Function(Response response) onSuccess,
  ) async {
    try {
      final response = await apiCall();
      return Right(onSuccess(response));
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(_handleUnexpectedException(e));
    }
  }

  /// POST request with automatic error handling.
  /// 
  /// Usage:
  /// ```dart
  /// return _dioClient.post<UserModel>(
  ///   '/auth/signup',
  ///   data: {'name': name, 'email': email},
  ///   parser: (data) => UserModel.fromJson(data),
  /// );
  /// ```
  Future<Either<Failure, T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return Right(parser(response.data));
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(_handleUnexpectedException(e));
    }
  }

  /// GET request with automatic error handling.
  Future<Either<Failure, T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return Right(parser(response.data));
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(_handleUnexpectedException(e));
    }
  }

  /// PUT request with automatic error handling.
  Future<Either<Failure, T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return Right(parser(response.data));
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(_handleUnexpectedException(e));
    }
  }

  /// PATCH request with automatic error handling.
  Future<Either<Failure, T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return Right(parser(response.data));
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(_handleUnexpectedException(e));
    }
  }

  /// DELETE request with automatic error handling.
  Future<Either<Failure, T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return Right(parser(response.data));
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(_handleUnexpectedException(e));
    }
  }

  /// Handles DioException and converts it to ApiFailure.
  ApiFailure _handleDioException(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;
      final statusCode = e.response!.statusCode ?? 500;

      // Extract message from server response
      final message = _extractMessage(data);

      // Extract field-specific errors from server response
      final errors = _extractErrors(data);

      return ApiFailure(
        message: message,
        statusCode: statusCode,
        errors: errors,
      );
    }

    // Handle network/connection errors (no response)
    return ApiFailure(
      message: _getNetworkErrorMessage(e.type),
      statusCode: 0,
    );
  }

  /// Extracts the error message from server response.
  String _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ?? 'An error occurred';
    }
    return 'An error occurred';
  }

  /// Extracts field-specific errors from server response.
  Map<String, List<String>>? _extractErrors(dynamic data) {
    if (data is Map<String, dynamic> && data['errors'] != null) {
      try {
        return (data['errors'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
            key,
            (value as List).map((e) => e.toString()).toList(),
          ),
        );
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// Gets a user-friendly message for network errors.
  String _getNetworkErrorMessage(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Request timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server is taking too long to respond.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      default:
        return 'Network error occurred. Please try again.';
    }
  }

  /// Handles unexpected (non-Dio) exceptions.
  ApiFailure _handleUnexpectedException(Object e) {
    return ApiFailure(
      message: 'An unexpected error occurred: ${e.toString()}',
      statusCode: 0,
    );
  }
}
