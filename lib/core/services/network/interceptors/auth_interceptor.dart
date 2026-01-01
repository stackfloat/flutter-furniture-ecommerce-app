import 'package:dio/dio.dart';
import 'package:furniture_ecommerce_app/core/services/storage/secure_storage_service.dart';

/// Interceptor that automatically adds authentication tokens to requests
/// and handles 401 Unauthorized responses.
class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.getAccessToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // TODO: Implement token refresh logic here
      // For now, just clear auth data and let the error propagate
      await _secureStorage.clearAuthData();
      // You might want to add navigation logic here to redirect to login
    }

    return handler.next(err);
  }
}
