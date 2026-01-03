import 'package:furniture_ecommerce_app/features/authentication/domain/entities/user.dart';

enum SignupStatus { initial, loading, success, failure }

class SignupState {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final bool formSubmitted;
  final bool revealPassword;
  final bool revealConfirmPassword;
  final Map<String, String?> errors;

  final SignupStatus status;
  final User? user;

  const SignupState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.formSubmitted = false,
    this.errors = const {},
    this.status = SignupStatus.initial,
    this.revealPassword = false,
    this.revealConfirmPassword = false,
    this.user,
  });

  bool get isValid =>
      errors.isEmpty &&
      name.isNotEmpty &&
      email.isNotEmpty &&
      password.isNotEmpty &&
      confirmPassword.isNotEmpty;

  // Helper getters for individual errors
  String? get nameError => errors['name'];
  String? get emailError => errors['email'];
  String? get passwordError => errors['password'];
  String? get confirmPasswordError => errors['confirmPassword'];

  SignupState copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    bool? formSubmitted,
    Map<String, String?>? errors,
    SignupStatus? status,
    bool? revealPassword,
    bool? revealConfirmPassword,
    User? user,
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
    );
  }
}
