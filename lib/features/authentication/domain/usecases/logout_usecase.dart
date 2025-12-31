import 'package:furniture_ecommerce_app/core/domain/usecases/usecase.dart';
import 'package:furniture_ecommerce_app/core/utils/typedef.dart';

class LogoutUseCase implements UseCase<void, NoParams> {
  // final AuthRepository repository;
  
  // LogoutUseCase(this.repository);
  
  @override
  ResultFuture<void> call(NoParams params) async {
    // TODO: Implement logout logic
    throw UnimplementedError();
  }
}

class NoParams {
  const NoParams();
}

