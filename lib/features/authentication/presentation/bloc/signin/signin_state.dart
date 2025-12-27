part of 'signin_bloc.dart';

enum SigninStatus { initial, success, failure }

class SigninState {
  final String email;
  final String password;

  final Map<String, String?> errors;
  final SigninStatus status;
  final bool formSubmitted;

  const SigninState({
    this.email = '',
    this.password = '',
    this.errors = const {},
    this.status = SigninStatus.initial,
    this.formSubmitted = false,
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
  }) {
    return SigninState(
      email: email ?? this.email,
      password: password ?? this.password,
      errors: errors ?? this.errors,
      status: status ?? this.status,
      formSubmitted: formSubmitted ?? this.formSubmitted,
    );
  }
}
