part of 'signin_bloc.dart';

enum SigninStatus { initial, loading, success, failure }

class SigninState extends Equatable {
  final String email;
  final String password;

  final SigninErrors errors;
  final SigninStatus status;
  final bool formSubmitted;
  final bool revealPassword;
  final User? user;
  final String? serverError;
  final String? authError;

  const SigninState({
    this.email = '',
    this.password = '',
    this.errors = const SigninErrors(),
    this.status = SigninStatus.initial,
    this.formSubmitted = false,
    this.revealPassword = false,
    this.user,
    this.serverError,
    this.authError,
  });

  // Helper getters for easy access to specific errors
  String? get emailError => errors.email;
  String? get passwordError => errors.password;

  SigninState copyWith({
    String? email,
    String? password,
    SigninErrors? errors,
    SigninStatus? status,
    bool? formSubmitted,
    bool? revealPassword,
    User? user,
    Object? serverError = _unset,
    Object? authError = _unset,
  }) {
    return SigninState(
      email: email ?? this.email,
      password: password ?? this.password,
      errors: errors ?? this.errors,
      status: status ?? this.status,
      formSubmitted: formSubmitted ?? this.formSubmitted,
      revealPassword: revealPassword ?? this.revealPassword,
      user: user ?? this.user,
      serverError: serverError == _unset ? this.serverError : serverError as String?,
      authError: authError == _unset ? this.authError : authError as String?,
    );
  }

  bool get hasErrors => serverError != null || authError != null;

  static const _unset = Object();

  @override
  List<Object?> get props => [email, password, errors, status, formSubmitted, revealPassword, user, serverError, authError];
}
