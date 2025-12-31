import 'package:furniture_ecommerce_app/core/domain/usecases/usecase.dart';
import 'package:furniture_ecommerce_app/core/utils/typedef.dart';

class SigninUseCase implements UseCase<void, SigninParams> {
  // final AuthRepository repository;
  
  // SigninUseCase(this.repository);
  
  @override
  ResultFuture<void> call(SigninParams params) async {
    // TODO: Implement signin logic
    throw UnimplementedError();
  }
}

class SigninParams {
  final String email;
  final String password;
  
  const SigninParams({
    required this.email,
    required this.password,
  });
}

