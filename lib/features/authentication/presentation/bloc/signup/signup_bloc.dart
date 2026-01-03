import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/usecases/signup_usecase.dart';
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
        errors: {...state.errors, ..._validateName(event.name)},
      ),
    );
  }

  void _onEmailChanged(EmailChanged event, Emitter<SignupState> emit) {
    emit(
      state.copyWith(
        email: event.email,
        errors: {...state.errors, ..._validateEmail(event.email)},
      ),
    );
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<SignupState> emit) {
    emit(
      state.copyWith(
        password: event.password,
        errors: {...state.errors, ..._validatePassword(event.password)},
      ),
    );

    // Re-validate confirm password if it's not empty
    if (state.confirmPassword.isNotEmpty) {
      emit(
        state.copyWith(
          errors: {
            ...state.errors,
            ..._validateConfirmPassword(state.confirmPassword),
          },
        ),
      );
    }
  }

  void _onConfirmPasswordChanged(
    ConfirmPasswordChanged event,
    Emitter<SignupState> emit,
  ) {
    emit(
      state.copyWith(
        confirmPassword: event.confirmPassword,
        errors: {
          ...state.errors,
          ..._validateConfirmPassword(event.confirmPassword),
        },
      ),
    );
  }

  void _onSignupSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    // Perform all validations on submit
    emit(
      state.copyWith(
        formSubmitted: true,
        errors: {
          ...state.errors,
          ..._validateName(state.name),
          ..._validateEmail(state.email),
          ..._validatePassword(state.password),
          ..._validateConfirmPassword(state.confirmPassword),
        },
      ),
    );

    // Check if form is valid (all errors are null)
    final isValid = state.errors.values.every((error) => error == null);

    if (isValid) {
      emit(state.copyWith(status: SignupStatus.loading));

      final result = await signupUseCase(
        SignupParams(
          name: state.name,
          email: state.email,
          password: state.password,
        ),
      );

      result.fold(
        (failure) {
          emit(state.copyWith(status: SignupStatus.failure));
        },
        (user) {        
          emit(state.copyWith(status: SignupStatus.success, user: user));
        },
      );
    }
  }

  // Validation methods
  Map<String, String?> _validateName(String name) {
    name = name.trim();

    if (name.isEmpty) {
      return {'name': 'Name is required'};
    } else if (name.length < 3) {
      return {'name': 'Name must be at least 3 characters'};
    }

    return {'name': null};
  }

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
    } else if (password.length < 8) {
      return {'password': 'Password must be 8+ characters'};
    }

    return {'password': null};
  }

  Map<String, String?> _validateConfirmPassword(String confirmPassword) {
    confirmPassword = confirmPassword.trim();

    if (confirmPassword.isEmpty) {
      return {'confirmPassword': 'Confirm password is required'};
    } else if (confirmPassword != state.password) {
      return {'confirmPassword': 'Passwords do not match'};
    }

    return {'confirmPassword': null};
  }
}
