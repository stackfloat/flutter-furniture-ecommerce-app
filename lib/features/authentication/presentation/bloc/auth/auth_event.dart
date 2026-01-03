import 'package:furniture_ecommerce_app/features/authentication/domain/entities/user.dart';

abstract class AuthEvent {}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final User user;
  LoggedIn(this.user);
}

class LoggedOut extends AuthEvent {}
