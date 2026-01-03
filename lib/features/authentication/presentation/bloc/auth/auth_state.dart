import 'package:furniture_ecommerce_app/features/authentication/domain/entities/user.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final User? user;

  const AuthState({
    required this.status,
    this.user,
  });

  factory AuthState.unknown() =>
      const AuthState(status: AuthStatus.unknown);

  factory AuthState.authenticated(User user) =>
      AuthState(status: AuthStatus.authenticated, user: user);

  factory AuthState.unauthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);
}
