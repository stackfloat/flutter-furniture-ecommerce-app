import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashlyticsInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final crashlytics = FirebaseCrashlytics.instance;

    // ❌ Do not log anything if crashlytics is disabled or app is in debug
    // ❗ NOTE: isCrashlyticsCollectionEnabled is a GETTER, not a function
    if (kDebugMode || !(crashlytics.isCrashlyticsCollectionEnabled)) {
      return handler.next(err);
    }

    final request = err.requestOptions;

    try {
      // --------------------
      // Log Request details
      // --------------------
      await crashlytics.log('API Error');
      await crashlytics.log('URL: ${request.uri}');
      await crashlytics.log('METHOD: ${request.method}');
      await crashlytics.log('HEADERS: ${_sanitizeHeaders(request.headers)}');
      await crashlytics.log('BODY: ${_sanitize(request.data)}');

      // --------------------
      // Log Response details
      // --------------------
      if (err.response != null) {
        await crashlytics.log('STATUS CODE: ${err.response?.statusCode}');
        await crashlytics.log('RESPONSE: ${_sanitize(err.response?.data)}');
      }

      // --------------------
      // Record actual error
      // --------------------
      await crashlytics.recordError(
        err,
        err.stackTrace,
        fatal: false,
        reason: 'API Call failed: ${request.uri}',
      );
    } catch (_) {
      // NEVER allow interceptor to break calls
    }

    return handler.next(err);
  }

  // --------------------
  // Sanitize request body
  // --------------------
  String _sanitize(dynamic data) {
    if (data == null) return 'null';

    if (data is Map) {
      final sanitized = Map<String, dynamic>.from(data);

      // Remove secrets
      final blacklist = [
        'password',
        'token',
        'access_token',
        'refresh_token',
        'authorization'
      ];
      for (final key in blacklist) {
        sanitized.remove(key);
      }

      return sanitized.toString();
    }

    if (data is String) {
      final lower = data.toLowerCase();
      if (lower.contains('password') ||
          lower.contains('token') ||
          lower.contains('authorization')) {
        return '[REDACTED]';
      }
    }

    return data.toString();
  }

  // --------------------
  // Sanitize headers
  // --------------------
  String _sanitizeHeaders(Map<String, dynamic> headers) {
    final sanitized = Map<String, dynamic>.from(headers);

    sanitized.remove('Authorization');
    sanitized.remove('authorization');
    sanitized.remove('Cookie');
    sanitized.remove('cookie');

    return sanitized.toString();
  }
}
