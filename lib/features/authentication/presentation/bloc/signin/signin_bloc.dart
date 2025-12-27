import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  SigninBloc() : super(const SigninState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<SigninSubmitted>(_onSigninSubmitted);
  }

  void _onEmailChanged(EmailChanged event, Emitter<SigninState> emit) {
    emit(state.copyWith(
      email: event.email,
      errors: {
        ...state.errors,
        ..._validateEmail(event.email),
      },
    ));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<SigninState> emit) {
    emit(state.copyWith(
      password: event.password,
      errors: {
        ...state.errors,
        ..._validatePassword(event.password),
      },
    ));
  }

  void _onSigninSubmitted(SigninSubmitted event, Emitter<SigninState> emit) {
    // Perform all validations on submit
    emit(state.copyWith(
      formSubmitted: true,
      errors: {
        ...state.errors,
        ..._validateEmail(state.email),
        ..._validatePassword(state.password),
      },
    ));

    // Check if form is valid (all errors are null)
    final isValid = state.errors.values.every((error) => error == null);

    if (isValid) {
      emit(state.copyWith(status: SigninStatus.success));
    } else {
      emit(state.copyWith(status: SigninStatus.failure));
    }
  }

  // Validation methods
  Map<String, String?> _validateEmail(String email) {
    email = email.trim();

    if (email.isEmpty) {
      return {'email': 'Email is required'};
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return {'email': 'Invalid email'};
    }

    return {'email': null};
  }

  Map<String, String?> _validatePassword(String password) {
    password = password.trim();

    if (password.isEmpty) {
      return {'password': 'Password is required'};
    } 

    return {'password': null};
  }
}
