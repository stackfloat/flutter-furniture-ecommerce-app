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
  ResultFuture<User> login(String email, String password) {
    return remoteDataSource.login(email, password);
  }

  @override
  ResultFuture<User> signup(String name, String email, String password) {
    return remoteDataSource.signup(name, email, password);
  }

  @override
  ResultFuture<void> logout() {
    return remoteDataSource.logout();
  }
}
