import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:furniture_ecommerce_app/core/errors/exceptions.dart';
import 'package:furniture_ecommerce_app/core/errors/failure.dart';
import 'package:furniture_ecommerce_app/core/services/storage/secure_storage_service.dart';
import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/entities/user.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorageService secureStorageService;

  AuthRepositoryImpl(this.remoteDataSource, this.secureStorageService);

  @override
  ResultFuture<User> signup(String name, String email, String password) async {
    try {
      final userModel = await remoteDataSource.signup(name, email, password);

      // Save auth session (token and user data) including user ID
      await secureStorageService.saveAuthSession(
        accessToken: userModel.token,
        refreshToken:
            userModel.token, // Use same token if no separate refresh token
        userJson: jsonEncode(userModel.toJson()),
        userId: userModel.id,
      );

      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(
        ApiFailure(
          message: e.message ?? 'An error occurred',
          statusCode: e.statusCode ?? 500,
          errors: e.errors,
        ),
      );
    } catch (e) {
      return Left(
        ApiFailure(
          message: 'An unexpected error occurred: ${e.toString()}',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  ResultFuture<User> login(String email, String password) async {
    try {
      final userModel = await remoteDataSource.login(email, password);

      // Save auth session (token and user data) including user ID
      await secureStorageService.saveAuthSession(
        accessToken: userModel.token,
        refreshToken:
            userModel.token, // Use same token if no separate refresh token
        userJson: jsonEncode(userModel.toJson()),
        userId: userModel.id,
      );

      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(
        ApiFailure(
          message: e.message ?? 'An error occurred',
          statusCode: e.statusCode ?? 500,
          errors: e.errors,
        ),
      );
    } catch (e) {
      return Left(
        ApiFailure(
          message: 'An unexpected error occurred: ${e.toString()}',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  ResultFuture<void> logout() async {
    try {
      //await remoteDataSource.logout();
      // Clear all auth data including user ID
      await secureStorageService.clearAuthData();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ApiFailure(
          message: e.message ?? 'An error occurred',
          statusCode: e.statusCode ?? 500,
        ),
      );
    } catch (e) {
      return Left(
        ApiFailure(
          message: 'An unexpected error occurred: ${e.toString()}',
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<User?> getUser() async {
    final userJson = await secureStorageService.getUser();
    if (userJson == null) return null;

    try {
      final decoded = jsonDecode(userJson);
      if (decoded is Map<String, dynamic> &&
          decoded['id'] is int &&
          decoded['email'] is String &&
          decoded['name'] is String) {
        return User.fromJson(decoded);
      }
    } catch (_) {
      // ignore or log
    }

    // Optional: clear bad data
    await secureStorageService.deleteUser();
    return null;
  }
}
