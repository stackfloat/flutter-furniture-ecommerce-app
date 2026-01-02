import 'package:dio/dio.dart';
import 'package:furniture_ecommerce_app/core/errors/exceptions.dart';
import 'package:furniture_ecommerce_app/core/services/network/dio_client.dart';
import 'package:furniture_ecommerce_app/features/authentication/data/models/user_model.dart';

/// Remote data source for authentication operations.
///
/// Returns [UserModel] (data layer) which will be converted to [User] entity
/// by the repository (domain layer).
///
/// Throws [ServerException] on error.
abstract class AuthRemoteDataSource {
  /// Sign up a new user with name, email, and password.
  /// Returns [UserModel] with user data and auth token.
  /// Throws [ServerException] on error.
  Future<UserModel> signup(String name, String email, String password);

  /// Log in an existing user with email and password.
  /// Returns [UserModel] with user data and auth token.
  /// Throws [ServerException] on error.
  Future<UserModel> login(String email, String password);

  /// Log out the current user.
  /// Invalidates the auth token on the server.
  /// Throws [ServerException] on error.
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<UserModel> signup(String name, String email, String password) async {
    try {
      final response = await _dioClient.dio.post(
        '/register',
        data: {'name': name, 'email': email, 'password': password},
      );

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response!.data;
        throw ServerException(
          message: _extractMessage(data),
          statusCode: e.response!.statusCode ?? 500,
          errors: _extractErrors(data),
        );
      }
      throw ServerException(
        message: e.message ?? 'Network error occurred',
        statusCode: 0,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _dioClient.dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response!.data;
        throw ServerException(
          message: _extractMessage(data),
          statusCode: e.response!.statusCode ?? 500,
          errors: _extractErrors(data),
        );
      }
      throw ServerException(
        message: e.message ?? 'Network error occurred',
        statusCode: 0,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dioClient.dio.post('/auth/logout');
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response!.data;
        throw ServerException(
          message: _extractMessage(data),
          statusCode: e.response!.statusCode ?? 500,
        );
      }
      throw ServerException(
        message: e.message ?? 'Network error occurred',
        statusCode: 0,
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: e.toString(), statusCode: 500);
    }
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
          (key, value) =>
              MapEntry(key, (value as List).map((e) => e.toString()).toList()),
        );
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
