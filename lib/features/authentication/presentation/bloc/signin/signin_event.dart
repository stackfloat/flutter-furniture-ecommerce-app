part of 'signin_bloc.dart';

@immutable
sealed class SigninEvent {}

final class EmailChanged extends SigninEvent {
  final String email;
  EmailChanged(this.email);
}

final class PasswordChanged extends SigninEvent {
  final String password;
  PasswordChanged(this.password);
}

final class SigninSubmitted extends SigninEvent {}
