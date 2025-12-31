import 'package:fpdart/fpdart.dart';
import 'package:furniture_ecommerce_app/core/errors/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
