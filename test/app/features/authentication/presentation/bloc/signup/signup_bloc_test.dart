import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/value_objects/confirmed_password.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/value_objects/email.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/value_objects/name.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/value_objects/password.dart';
import 'package:mocktail/mocktail.dart';

import 'package:furniture_ecommerce_app/core/errors/failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/entities/user.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/failures/auth_validation_failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/failures/email_already_exists_failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/failures/username_already_exists_failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/usecases/signup_params.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/usecases/signup_usecase.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signup/signup_bloc.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signup/signup_errors.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signup/signup_event.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signup/signup_state.dart';

class MockSignupUseCase extends Mock implements SignupUseCase {}

void main() {
  late SignupBloc signupBloc;
  late MockSignupUseCase mockSignupUseCase;

  const tUser = User(
    id: 1,
    name: 'Test User',
    email: 'test@example.com',
  );

  setUp(() {
    mockSignupUseCase = MockSignupUseCase();
    signupBloc = SignupBloc(mockSignupUseCase);
  });

  setUpAll(() {
    registerFallbackValue(
      SignupParams(
        name: Name('Test User'),
        email: Email('test@example.com'),
        password: ConfirmedPassword(
          password: 'password123',
          confirmation: 'password123',
        ),
      ),
    );
  });

  tearDown(() {
    signupBloc.close();
  });

  test('initial state is correct', () {
    expect(signupBloc.state, const SignupState());
    expect(signupBloc.state.status, SignupStatus.initial);
    expect(signupBloc.state.name, '');
    expect(signupBloc.state.email, '');
    expect(signupBloc.state.password, '');
    expect(signupBloc.state.confirmPassword, '');
    expect(signupBloc.state.formSubmitted, false);
    expect(signupBloc.state.errors, SignupErrors.empty);
  });

  group('NameChanged', () {
    blocTest<SignupBloc, SignupState>(
      'emits updated name when NameChanged is added',
      build: () => signupBloc,
      act: (bloc) => bloc.add(const NameChanged('John Doe')),
      expect: () => [
        const SignupState(name: 'John Doe'),
      ],
    );

    blocTest<SignupBloc, SignupState>(
      'clears server error when name is changed',
      build: () => signupBloc,
      seed: () => const SignupState(serverError: 'Server error'),
      act: (bloc) => bloc.add(const NameChanged('John Doe')),
      expect: () => [
        const SignupState(name: 'John Doe', serverError: null),
      ],
    );

    blocTest<SignupBloc, SignupState>(
      'validates name when form is already submitted',
      build: () => signupBloc,
      seed: () => const SignupState(formSubmitted: true, name: ''),
      act: (bloc) => bloc.add(const NameChanged('J')),
      expect: () => [
        SignupState(
          formSubmitted: true,
          name: 'J',
          errors: SignupErrors(name: 'Name must be at least ${Name.minLength} characters'),
        ),
      ],
    );

    blocTest<SignupBloc, SignupState>(
      'does not validate name when form is not submitted',
      build: () => signupBloc,
      act: (bloc) => bloc.add(const NameChanged('J')),
      expect: () => [
        const SignupState(name: 'J'),
      ],
    );
  });

  group('EmailChanged', () {
    blocTest<SignupBloc, SignupState>(
      'emits updated email when EmailChanged is added',
      build: () => signupBloc,
      act: (bloc) => bloc.add(const EmailChanged('test@example.com')),
      expect: () => [
        const SignupState(email: 'test@example.com'),
      ],
    );

    blocTest<SignupBloc, SignupState>(
      'clears server error when email is changed',
      build: () => signupBloc,
      seed: () => const SignupState(serverError: 'Server error'),
      act: (bloc) => bloc.add(const EmailChanged('test@example.com')),
      expect: () => [
        const SignupState(email: 'test@example.com', serverError: null),
      ],
    );

    blocTest<SignupBloc, SignupState>(
      'validates email when form is already submitted',
      build: () => signupBloc,
      seed: () => const SignupState(formSubmitted: true),
      act: (bloc) => bloc.add(const EmailChanged('invalid-email')),
      expect: () => [
        const SignupState(
          formSubmitted: true,
          email: 'invalid-email',
          errors: SignupErrors(email: 'Invalid email'),
        ),
      ],
    );

    blocTest<SignupBloc, SignupState>(
      'does not validate email when form is not submitted',
      build: () => signupBloc,
      act: (bloc) => bloc.add(const EmailChanged('invalid-email')),
      expect: () => [
        const SignupState(email: 'invalid-email'),
      ],
    );
  });

  group('PasswordChanged', () {
    blocTest<SignupBloc, SignupState>(
      'emits updated password when PasswordChanged is added',
      build: () => signupBloc,
      act: (bloc) => bloc.add(const PasswordChanged('password123')),
      expect: () => [
        const SignupState(password: 'password123'),
      ],
    );

    blocTest<SignupBloc, SignupState>(
      'clears server error when password is changed',
      build: () => signupBloc,
      seed: () => const SignupState(serverError: 'Server error'),
      act: (bloc) => bloc.add(const PasswordChanged('password123')),
      expect: () => [
        const SignupState(password: 'password123', serverError: null),
      ],
    );

    blocTest<SignupBloc, SignupState>(
      'validates password when form is already submitted',
      build: () => signupBloc,
      seed: () => const SignupState(formSubmitted: true),
      act: (bloc) => bloc.add(const PasswordChanged('12345')),
      expect: () => [
        SignupState(
          formSubmitted: true,
          password: '12345',
          errors: SignupErrors(
            password: 'Password must be at least ${Password.minLength} characters',
            confirmPassword: 'Confirm password is required',
          ),
        ),
      ],
    );

    blocTest<SignupBloc, SignupState>(
      'validates both password and confirm password when form is submitted',
      build: () => signupBloc,
      seed: () => const SignupState(
        formSubmitted: true,
        confirmPassword: 'different',
      ),
      act: (bloc) => bloc.add(const PasswordChanged('password123')),
      expect: () => [
        const SignupState(
          formSubmitted: true,
          password: 'password123',
          confirmPassword: 'different',
          errors: SignupErrors(confirmPassword: 'Passwords do not match'),
        ),
      ],
    );
  });

  group('ConfirmPasswordChanged', () {
    blocTest<SignupBloc, SignupState>(
      'emits updated confirm password when ConfirmPasswordChanged is added',
      build: () => signupBloc,
      act: (bloc) => bloc.add(const ConfirmPasswordChanged('password123')),
      expect: () => [
        const SignupState(confirmPassword: 'password123'),
      ],
    );

    blocTest<SignupBloc, SignupState>(
      'clears server error when confirm password is changed',
      build: () => signupBloc,
      seed: () => const SignupState(serverError: 'Server error'),
      act: (bloc) => bloc.add(const ConfirmPasswordChanged('password123')),
      expect: () => [
        const SignupState(confirmPassword: 'password123', serverError: null),
      ],
    );

    blocTest<SignupBloc, SignupState>(
      'validates confirm password when form is already submitted',
      build: () => signupBloc,
      seed: () => const SignupState(
        formSubmitted: true,
        password: 'password123',
      ),
      act: (bloc) => bloc.add(const ConfirmPasswordChanged('different')),
      expect: () => [
        const SignupState(
          formSubmitted: true,
          password: 'password123',
          confirmPassword: 'different',
          errors: SignupErrors(confirmPassword: 'Passwords do not match'),
        ),
      ],
    );
  });

  group('RevealPassword', () {
    blocTest<SignupBloc, SignupState>(
      'emits updated revealPassword state',
      build: () => signupBloc,
      act: (bloc) => bloc.add(const RevealPassword(true)),
      expect: () => [
        const SignupState(revealPassword: true),
      ],
    );

    blocTest<SignupBloc, SignupState>(
      'can toggle reveal password off',
      build: () => signupBloc,
      seed: () => const SignupState(revealPassword: true),
      act: (bloc) => bloc.add(const RevealPassword(false)),
      expect: () => [
        const SignupState(revealPassword: false),
      ],
    );
  });

  group('RevealConfirmPassword', () {
    blocTest<SignupBloc, SignupState>(
      'emits updated revealConfirmPassword state',
      build: () => signupBloc,
      act: (bloc) => bloc.add(const RevealConfirmPassword(true)),
      expect: () => [
        const SignupState(revealConfirmPassword: true),
      ],
    );

    blocTest<SignupBloc, SignupState>(
      'can toggle reveal confirm password off',
      build: () => signupBloc,
      seed: () => const SignupState(revealConfirmPassword: true),
      act: (bloc) => bloc.add(const RevealConfirmPassword(false)),
      expect: () => [
        const SignupState(revealConfirmPassword: false),
      ],
    );
  });

  group('SignupSubmitted - Validation Errors', () {
    blocTest<SignupBloc, SignupState>(
      'emits formSubmitted true and validation errors when fields are empty',
      build: () => signupBloc,
      act: (bloc) => bloc.add(const SignupSubmitted()),
      expect: () => [
        const SignupState(
          formSubmitted: true,
          errors: SignupErrors(
            name: 'Name is required',
            email: 'Email is required',
            password: 'Password is required',
            confirmPassword: 'Confirm password is required',
          ),
        ),
      ],
      verify: (_) {
        verifyNever(() => mockSignupUseCase(any()));
      },
    );

    blocTest<SignupBloc, SignupState>(
      'does not call usecase when UX validation fails',
      build: () => signupBloc,
      seed: () => const SignupState(
        name: 'John',
        email: 'invalid-email',
        password: '123',
        confirmPassword: '456',
      ),
      act: (bloc) => bloc.add(const SignupSubmitted()),
      expect: () => [
        SignupState(
          formSubmitted: true,
          name: 'John',
          email: 'invalid-email',
          password: '123',
          confirmPassword: '456',
          errors: SignupErrors(
            email: 'Invalid email',
            password: 'Password must be at least ${Password.minLength} characters',
            confirmPassword: 'Passwords do not match',
          ),
        ),
      ],
      verify: (_) {
        verifyNever(() => mockSignupUseCase(any()));
      },
    );

    blocTest<SignupBloc, SignupState>(
      'handles domain validation exception (InvalidNameException)',
      build: () => signupBloc,
      seed: () => const SignupState(
        name: 'Jo',
        email: 'test@example.com',
        password: 'password123',
        confirmPassword: 'password123',
      ),
      act: (bloc) => bloc.add(const SignupSubmitted()),
      expect: () => [
        SignupState(
          formSubmitted: true,
          name: 'Jo',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          errors: SignupErrors(name: 'Name must be at least ${Name.minLength} characters'),
          status: SignupStatus.initial,
        ),
      ],
    );
  });

  group('SignupSubmitted - Success', () {
    blocTest<SignupBloc, SignupState>(
      'emits loading then success when signup succeeds',
      build: () {
        when(() => mockSignupUseCase(any()))
            .thenAnswer((_) async => const Right(tUser));
        return signupBloc;
      },
      seed: () => const SignupState(
        name: 'John Doe',
        email: 'test@example.com',
        password: 'password123',
        confirmPassword: 'password123',
      ),
      act: (bloc) => bloc.add(const SignupSubmitted()),
      expect: () => [
        const SignupState(
          formSubmitted: true,
          name: 'John Doe',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          errors: SignupErrors(),
        ),
        const SignupState(
          formSubmitted: true,
          name: 'John Doe',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          errors: SignupErrors(),
          status: SignupStatus.loading,
        ),
        const SignupState(
          formSubmitted: true,
          name: 'John Doe',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          errors: SignupErrors(),
          status: SignupStatus.success,
          user: tUser,
        ),
      ],
      verify: (_) {
        verify(() => mockSignupUseCase(any())).called(1);
      },
    );
  });

  group('SignupSubmitted - Failure Cases', () {
    blocTest<SignupBloc, SignupState>(
      'emits failure with field error when EmailAlreadyExistsFailure',
      build: () {
        when(() => mockSignupUseCase(any()))
            .thenAnswer((_) async => const Left(EmailAlreadyExistsFailure()));
        return signupBloc;
      },
      seed: () => const SignupState(
        name: 'John Doe',
        email: 'existing@example.com',
        password: 'password123',
        confirmPassword: 'password123',
      ),
      act: (bloc) => bloc.add(const SignupSubmitted()),
      expect: () => [
        const SignupState(
          formSubmitted: true,
          name: 'John Doe',
          email: 'existing@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          errors: SignupErrors(),
        ),
        const SignupState(
          formSubmitted: true,
          name: 'John Doe',
          email: 'existing@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          errors: SignupErrors(),
          status: SignupStatus.loading,
        ),
        const SignupState(
          formSubmitted: true,
          name: 'John Doe',
          email: 'existing@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          errors: SignupErrors(email: 'Email already exists'),
          status: SignupStatus.failure,
        ),
      ],
    );

    blocTest<SignupBloc, SignupState>(
      'emits failure with field error when UsernameAlreadyExistsFailure',
      build: () {
        when(() => mockSignupUseCase(any()))
            .thenAnswer((_) async => const Left(UsernameAlreadyExistsFailure()));
        return signupBloc;
      },
      seed: () => const SignupState(
        name: 'ExistingUser',
        email: 'test@example.com',
        password: 'password123',
        confirmPassword: 'password123',
      ),
      act: (bloc) => bloc.add(const SignupSubmitted()),
      expect: () => [
        const SignupState(
          formSubmitted: true,
          name: 'ExistingUser',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          errors: SignupErrors(),
        ),
        const SignupState(
          formSubmitted: true,
          name: 'ExistingUser',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          errors: SignupErrors(),
          status: SignupStatus.loading,
        ),
        const SignupState(
          formSubmitted: true,
          name: 'ExistingUser',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          errors: SignupErrors(name: 'Username already exists'),
          status: SignupStatus.failure,
        ),
      ],
    );

    blocTest<SignupBloc, SignupState>(
      'emits failure with field errors when AuthValidationFailure',
      build: () {
        when(() => mockSignupUseCase(any())).thenAnswer(
          (_) async => const Left(
            AuthValidationFailure({
              'name': ['Name is invalid'],
              'email': ['Email format is wrong'],
            }),
          ),
        );
        return signupBloc;
      },
      seed: () => const SignupState(
        name: 'John',
        email: 'test@example.com',
        password: 'password123',
        confirmPassword: 'password123',
      ),
      act: (bloc) => bloc.add(const SignupSubmitted()),
      expect: () => [
        const SignupState(
          formSubmitted: true,
          name: 'John',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          errors: SignupErrors(),
        ),
        const SignupState(
          formSubmitted: true,
          name: 'John',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          errors: SignupErrors(),
          status: SignupStatus.loading,
        ),
        const SignupState(
          formSubmitted: true,
          name: 'John',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          errors: SignupErrors(
            name: 'Name is invalid',
            email: 'Email format is wrong',
          ),
          status: SignupStatus.failure,
        ),
      ],
    );

    blocTest<SignupBloc, SignupState>(
      'emits failure with server error when NetworkFailure',
      build: () {
        when(() => mockSignupUseCase(any())).thenAnswer(
          (_) async => const Left(NetworkFailure(message: 'No internet connection')),
        );
        return signupBloc;
      },
      seed: () => const SignupState(
        name: 'John Doe',
        email: 'test@example.com',
        password: 'password123',
        confirmPassword: 'password123',
      ),
      act: (bloc) => bloc.add(const SignupSubmitted()),
      expect: () => [
        const SignupState(
          formSubmitted: true,
          name: 'John Doe',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          errors: SignupErrors(),
        ),
        const SignupState(
          formSubmitted: true,
          name: 'John Doe',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          errors: SignupErrors(),
          status: SignupStatus.loading,
        ),
        const SignupState(
          formSubmitted: true,
          name: 'John Doe',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          errors: SignupErrors(),
          status: SignupStatus.failure,
          serverError: 'No internet connection',
        ),
      ],
    );

    blocTest<SignupBloc, SignupState>(
      'emits failure with server error when ServerFailure',
      build: () {
        when(() => mockSignupUseCase(any())).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Internal server error')),
        );
        return signupBloc;
      },
      seed: () => const SignupState(
        name: 'John Doe',
        email: 'test@example.com',
        password: 'password123',
        confirmPassword: 'password123',
      ),
      act: (bloc) => bloc.add(const SignupSubmitted()),
      expect: () => [
        const SignupState(
          formSubmitted: true,
          name: 'John Doe',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          errors: SignupErrors(),
        ),
        const SignupState(
          formSubmitted: true,
          name: 'John Doe',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          errors: SignupErrors(),
          status: SignupStatus.loading,
        ),
        const SignupState(
          formSubmitted: true,
          name: 'John Doe',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          errors: SignupErrors(),
          status: SignupStatus.failure,
          serverError: 'Internal server error',
        ),
      ],
    );

    blocTest<SignupBloc, SignupState>(
      'does not process signup when already loading',
      build: () {
        when(() => mockSignupUseCase(any()))
            .thenAnswer((_) async => const Right(tUser));
        return signupBloc;
      },
      seed: () => const SignupState(
        name: 'John Doe',
        email: 'test@example.com',
        password: 'password123',
        confirmPassword: 'password123',
        status: SignupStatus.loading,
      ),
      act: (bloc) => bloc.add(const SignupSubmitted()),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockSignupUseCase(any()));
      },
    );
  });
}
