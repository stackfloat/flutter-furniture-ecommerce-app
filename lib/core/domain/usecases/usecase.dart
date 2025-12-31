import 'package:furniture_ecommerce_app/core/utils/typedef.dart';

abstract class UseCase<T, Params> {
  ResultFuture<T> call(Params params);
}
