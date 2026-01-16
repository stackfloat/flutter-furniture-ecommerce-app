import 'package:equatable/equatable.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/entities/user.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signup/signup_errors.dart';

enum SignupStatus { initial, loading, success, failure }

class SignupState extends Equatable {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final bool formSubmitted;
  final bool revealPassword;
  final bool revealConfirmPassword;
  final SignupErrors errors;
  final String? serverError;

  final SignupStatus status;
  final User? user;

  const SignupState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.formSubmitted = false,
    this.errors = SignupErrors.empty,
    this.status = SignupStatus.initial,
    this.revealPassword = false,
    this.revealConfirmPassword = false,
    this.user,
    this.serverError,
  });

  @override
  List<Object?> get props => [name, email, password, confirmPassword, formSubmitted, errors, status, revealPassword, revealConfirmPassword, user, serverError];

  // Helper getters for individual errors
  String? get nameError => errors.name;
  String? get emailError => errors.email;
  String? get passwordError => errors.password;
  String? get confirmPasswordError => errors.confirmPassword;

  SignupState copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    bool? formSubmitted,
    SignupErrors? errors,
    SignupStatus? status,
    bool? revealPassword,
    bool? revealConfirmPassword,
    User? user,
    Object? serverError = _unset,
  }) {
    return SignupState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      formSubmitted: formSubmitted ?? this.formSubmitted,
      errors: errors ?? this.errors,
      status: status ?? this.status,
      revealPassword: revealPassword ?? this.revealPassword,
      revealConfirmPassword: revealConfirmPassword ?? this.revealConfirmPassword,
      user: user ?? this.user,
      serverError: serverError == _unset
          ? this.serverError
          : serverError as String?,
    );
  }

  static const _unset = Object();
}
