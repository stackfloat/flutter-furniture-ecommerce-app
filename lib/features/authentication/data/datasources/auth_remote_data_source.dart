import 'package:furniture_ecommerce_app/core/services/network/dio_client.dart';
import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  ResultFuture<User> signup(String name, String email, String password);

  ResultFuture<User> login(String email, String password);

  ResultFuture<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl(this.dioClient);

  @override
  ResultFuture<User> login(String email, String password) {
  
    throw UnimplementedError();
  }

  @override
  ResultFuture<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  ResultFuture<User> signup(String name, String email, String password) {
    // TODO: implement signup
    throw UnimplementedError();
  }
}
