import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_ecommerce_app/core/errors/failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/errors/validation_exception.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/failures/auth_failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/failures/email_already_exists_failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/failures/username_already_exists_failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/usecases/signup_params.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/usecases/signup_usecase.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/value_objects/confirmed_password.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/value_objects/email.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/value_objects/name.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signup/signup_errors.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUseCase signupUseCase;

  SignupBloc(this.signupUseCase) : super(const SignupState()) {
    on<NameChanged>(_onNameChanged);
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<SignupSubmitted>(_onSignupSubmitted);
    on<RevealPassword>(_onRevealPassword);
    on<RevealConfirmPassword>(_onRevealConfirmPassword);
  }

  void _onRevealPassword(RevealPassword event, Emitter<SignupState> emit) {
    emit(state.copyWith(revealPassword: event.revealPassword));
  }

  void _onRevealConfirmPassword(
    RevealConfirmPassword event,
    Emitter<SignupState> emit,
  ) {
    emit(state.copyWith(revealConfirmPassword: event.revealConfirmPassword));
  }

  void _onNameChanged(NameChanged event, Emitter<SignupState> emit) {
    emit(
      state.copyWith(
        name: event.name,
        errors: state.formSubmitted
            ? state.errors.copyWith(name: _nameUxError(event.name))
            : state.errors,
      ),
    );
  }

  void _onEmailChanged(EmailChanged event, Emitter<SignupState> emit) {
    emit(
      state.copyWith(
        email: event.email,
        errors: state.formSubmitted
            ? state.errors.copyWith(email: _emailUxError(event.email))
            : state.errors,
      ),
    );
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<SignupState> emit) {
    emit(
      state.copyWith(
        password: event.password,
        errors: state.formSubmitted
            ? state.errors.copyWith(
                password: _passwordUxError(event.password),
                confirmPassword: _confirmPasswordUxError(
                  event.password,
                  state.confirmPassword,
                ),
              )
            : state.errors,
      ),
    );
  }

  void _onConfirmPasswordChanged(
    ConfirmPasswordChanged event,
    Emitter<SignupState> emit,
  ) {
    emit(
      state.copyWith(
        confirmPassword: event.confirmPassword,
        errors: state.formSubmitted
            ? state.errors.copyWith(
                confirmPassword: _confirmPasswordUxError(
                  state.password,
                  event.confirmPassword,
                ),
              )
            : state.errors,
      ),
    );
  }

  Future<void> _onSignupSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    // 1️⃣ Run UX validation for ALL fields (aggregate)
    final uxErrors = SignupErrors(
      name: _nameUxError(state.name),
      email: _emailUxError(state.email),
      password: _passwordUxError(state.password),
      confirmPassword: _confirmPasswordUxError(
        state.password,
        state.confirmPassword,
      ),
    );

    emit(state.copyWith(formSubmitted: true, errors: uxErrors));

    // 2️⃣ If UX errors exist → stop (better UX)
    if (uxErrors.hasErrors) return;

    try {
      // 2️⃣ HARD validation (domain boundary)
      final params = SignupParams(
        name: Name(state.name),
        email: Email(state.email),
        password: ConfirmedPassword(
          password: state.password,
          confirmation: state.confirmPassword,
        ),
      );

      // 3️⃣ Domain is valid → proceed
      emit(state.copyWith(status: SignupStatus.loading));

      final result = await signupUseCase(params);

      result.fold(
        (failure) {
          if (failure is AuthFailure) {
            emit(
              state.copyWith(
                status: SignupStatus.initial,
                errors: _mapFailureToUiErrors(failure),
                serverError: null,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: SignupStatus.initial,
                serverError: _mapFailureToGlobalMessage(failure),
              ),
            );
          }
        },
        (user) {
          emit(state.copyWith(status: SignupStatus.success, user: user));
        },
      );
    } on ValidationException catch (e) {
      // 4️⃣ Domain → UI translation
      emit(
        state.copyWith(
          status: SignupStatus.initial,
          errors: _mapDomainExceptionToUiErrors(e),
        ),
      );
    }
  }

  String? _passwordUxError(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _confirmPasswordUxError(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Confirm password is required';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _nameUxError(String name) {
    if (name.isEmpty) {
      return 'Name is required';
    }
    if (name.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  String? _emailUxError(String email) {
    if (email.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return 'Invalid email';
    }
    return null;
  }

  SignupErrors _mapDomainExceptionToUiErrors(ValidationException exception) {
    if (exception is InvalidNameException) {
      return const SignupErrors(name: 'Name must be at least 3 characters');
    }

    if (exception is InvalidEmailException) {
      return const SignupErrors(email: 'Invalid email address');
    }

    if (exception is WeakPasswordException) {
      return const SignupErrors(
        password: 'Password must be at least 8 characters',
      );
    }

    if (exception is PasswordMismatchException) {
      return const SignupErrors(confirmPassword: 'Passwords do not match');
    }

    return SignupErrors.empty;
  }

  SignupErrors _mapFailureToUiErrors(Failure failure) {
    if (failure is EmailAlreadyExistsFailure) {
      return SignupErrors(email: 'Email already exists');
    }

    if (failure is UsernameAlreadyExistsFailure) {
      return SignupErrors(name: 'Username already exists');
    }

    return SignupErrors.empty;
  }

  String _mapFailureToGlobalMessage(Failure failure) {

    if (failure is NetworkFailure) {
      return 'Network error. Please check your connection.';
    }

    if (failure is ServerFailure) {
      return 'Something went wrong. Please try again later.';
    }

    if (failure is ApiFailure) {
      if (failure.statusCode == 0) {
        return 'Network error. Please check your connection.';
      }
      return 'Something went wrong. Please try again later.';
    }

    return 'Unexpected error occurred.';
  }
}
