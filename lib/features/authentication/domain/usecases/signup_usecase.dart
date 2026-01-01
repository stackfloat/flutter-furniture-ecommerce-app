import 'package:furniture_ecommerce_app/core/domain/usecases/usecase.dart';
import 'package:furniture_ecommerce_app/core/utils/typedef.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/repositories/auth_repository.dart';

class SignupUseCase implements UseCase<void, SignupParams> {
  final AuthRepository repository;

  SignupUseCase(this.repository);
  
  @override
  ResultFuture<void> call(SignupParams params) async {
    return repository.signup(params.name, params.email, params.password);
  }
}

class SignupParams {
  final String name;
  final String email;
  final String password;
  
  const SignupParams({
    required this.name,
    required this.email,
    required this.password,
  });
}

