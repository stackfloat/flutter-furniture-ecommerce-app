part of 'signin_bloc.dart';

enum SigninStatus { initial, loading, success, failure }

class SigninState {
  final String email;
  final String password;

  final Map<String, String?> errors;
  final SigninStatus status;
  final bool formSubmitted;
  final bool revealPassword;
  final User? user;

  const SigninState({
    this.email = '',
    this.password = '',
    this.errors = const {},
    this.status = SigninStatus.initial,
    this.formSubmitted = false,
    this.revealPassword = false,
    this.user,
  });

  // Helper getters for easy access to specific errors
  String? get emailError => errors['email'];
  String? get passwordError => errors['password'];

  bool get isValid =>
      errors.values.every((error) => error == null) &&
      email.isNotEmpty &&
      password.isNotEmpty;

  SigninState copyWith({
    String? email,
    String? password,
    Map<String, String?>? errors,
    SigninStatus? status,
    bool? formSubmitted,
    bool? revealPassword,
    User? user,
  }) {
    return SigninState(
      email: email ?? this.email,
      password: password ?? this.password,
      errors: errors ?? this.errors,
      status: status ?? this.status,
      formSubmitted: formSubmitted ?? this.formSubmitted,
      revealPassword: revealPassword ?? this.revealPassword,
      user: user ?? this.user,
    );
  }
}
