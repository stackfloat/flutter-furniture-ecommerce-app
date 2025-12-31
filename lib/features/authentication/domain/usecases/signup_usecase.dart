import 'package:furniture_ecommerce_app/core/domain/usecases/usecase.dart';
import 'package:furniture_ecommerce_app/core/utils/typedef.dart';

class SignupUseCase implements UseCase<void, SignupParams> {
  // final AuthRepository repository;
  
  // SignupUseCase(this.repository);
  
  @override
  ResultFuture<void> call(SignupParams params) async {
    // TODO: Implement signup logic
    throw UnimplementedError();
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

