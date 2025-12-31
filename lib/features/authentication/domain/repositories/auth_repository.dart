
import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/entities/user.dart';

abstract class AuthRepository {

  ResultFuture<User> signup(String name, String email, String password){
    throw UnimplementedError();
  }

  ResultFuture<User> login(String email, String password){
    throw UnimplementedError();
  }

  ResultFuture<void> logout(){
    throw UnimplementedError();
  }
}