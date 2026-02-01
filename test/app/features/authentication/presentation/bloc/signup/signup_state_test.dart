import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/entities/user.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signup/signup_errors.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signup/signup_state.dart';

void main() {
  group('SignupState', () {
    group('constructor', () {
      test('creates state with default values', () {
        const state = SignupState();
        expect(state.name, '');
        expect(state.email, '');
        expect(state.password, '');
        expect(state.confirmPassword, '');
        expect(state.formSubmitted, false);
        expect(state.errors, SignupErrors.empty);
        expect(state.status, SignupStatus.initial);
        expect(state.revealPassword, false);
        expect(state.revealConfirmPassword, false);
        expect(state.user, isNull);
        expect(state.serverError, isNull);
      });

      test('creates state with specified values', () {
        const user = User(id: 1, name: 'Test', email: 'test@example.com');
        const errors = SignupErrors(name: 'Error');
        const state = SignupState(
          name: 'John Doe',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
          formSubmitted: true,
          errors: errors,
          status: SignupStatus.loading,
          revealPassword: true,
          revealConfirmPassword: true,
          user: user,
          serverError: 'Server error',
        );

        expect(state.name, 'John Doe');
        expect(state.email, 'test@example.com');
        expect(state.password, 'password123');
        expect(state.confirmPassword, 'password123');
        expect(state.formSubmitted, true);
        expect(state.errors, errors);
        expect(state.status, SignupStatus.loading);
        expect(state.revealPassword, true);
        expect(state.revealConfirmPassword, true);
        expect(state.user, user);
        expect(state.serverError, 'Server error');
      });
    });

    group('value equality', () {
      test('supports value equality', () {
        expect(
          const SignupState(name: 'John', email: 'test@example.com'),
          equals(const SignupState(name: 'John', email: 'test@example.com')),
        );
      });

      test('different states are not equal', () {
        expect(
          const SignupState(name: 'John'),
          isNot(equals(const SignupState(name: 'Jane'))),
        );
      });

      test('default states are equal', () {
        expect(const SignupState(), equals(const SignupState()));
      });
    });

    group('props', () {
      test('include all fields', () {
        const user = User(id: 1, name: 'Test', email: 'test@example.com');
        const errors = SignupErrors(name: 'Error');
        const state = SignupState(
          name: 'John',
          email: 'test@example.com',
          password: 'pass',
          confirmPassword: 'pass',
          formSubmitted: true,
          errors: errors,
          status: SignupStatus.loading,
          revealPassword: true,
          revealConfirmPassword: true,
          user: user,
          serverError: 'Error',
        );

        expect(state.props, [
          'John',
          'test@example.com',
          'pass',
          'pass',
          true,
          errors,
          SignupStatus.loading,
          true,
          true,
          user,
          'Error',
        ]);
      });

      test('props count is 11', () {
        const state = SignupState();
        expect(state.props.length, 11);
      });
    });

    group('helper getters', () {
      test('nameError returns errors.name', () {
        const state = SignupState(
          errors: SignupErrors(name: 'Name is required'),
        );
        expect(state.nameError, 'Name is required');
      });

      test('nameError returns null when no error', () {
        const state = SignupState();
        expect(state.nameError, isNull);
      });

      test('emailError returns errors.email', () {
        const state = SignupState(
          errors: SignupErrors(email: 'Invalid email'),
        );
        expect(state.emailError, 'Invalid email');
      });

      test('emailError returns null when no error', () {
        const state = SignupState();
        expect(state.emailError, isNull);
      });

      test('passwordError returns errors.password', () {
        const state = SignupState(
          errors: SignupErrors(password: 'Password too short'),
        );
        expect(state.passwordError, 'Password too short');
      });

      test('passwordError returns null when no error', () {
        const state = SignupState();
        expect(state.passwordError, isNull);
      });

      test('confirmPasswordError returns errors.confirmPassword', () {
        const state = SignupState(
          errors: SignupErrors(confirmPassword: 'Passwords do not match'),
        );
        expect(state.confirmPasswordError, 'Passwords do not match');
      });

      test('confirmPasswordError returns null when no error', () {
        const state = SignupState();
        expect(state.confirmPasswordError, isNull);
      });
    });

    group('copyWith', () {
      const baseState = SignupState(
        name: 'John Doe',
        email: 'test@example.com',
        password: 'password123',
        confirmPassword: 'password123',
        formSubmitted: true,
        errors: SignupErrors(name: 'Error'),
        status: SignupStatus.loading,
        revealPassword: true,
        revealConfirmPassword: true,
        user: User(id: 1, name: 'Test', email: 'test@example.com'),
        serverError: 'Server error',
      );

      test('returns same object when no parameters', () {
        expect(baseState.copyWith(), equals(baseState));
      });

      test('updates name when provided', () {
        final newState = baseState.copyWith(name: 'Jane Doe');
        expect(newState.name, 'Jane Doe');
        expect(newState.email, 'test@example.com');
      });

      test('updates email when provided', () {
        final newState = baseState.copyWith(email: 'new@example.com');
        expect(newState.name, 'John Doe');
        expect(newState.email, 'new@example.com');
      });

      test('updates password when provided', () {
        final newState = baseState.copyWith(password: 'newpass123');
        expect(newState.password, 'newpass123');
        expect(newState.confirmPassword, 'password123');
      });

      test('updates confirmPassword when provided', () {
        final newState = baseState.copyWith(confirmPassword: 'newpass123');
        expect(newState.password, 'password123');
        expect(newState.confirmPassword, 'newpass123');
      });

      test('updates formSubmitted when provided', () {
        final newState = baseState.copyWith(formSubmitted: false);
        expect(newState.formSubmitted, false);
      });

      test('updates errors when provided', () {
        const newErrors = SignupErrors(email: 'New error');
        final newState = baseState.copyWith(errors: newErrors);
        expect(newState.errors, newErrors);
      });

      test('updates status when provided', () {
        final newState = baseState.copyWith(status: SignupStatus.success);
        expect(newState.status, SignupStatus.success);
      });

      test('updates revealPassword when provided', () {
        final newState = baseState.copyWith(revealPassword: false);
        expect(newState.revealPassword, false);
      });

      test('updates revealConfirmPassword when provided', () {
        final newState = baseState.copyWith(revealConfirmPassword: false);
        expect(newState.revealConfirmPassword, false);
      });

      test('updates user when provided', () {
        const newUser = User(id: 2, name: 'New User', email: 'new@example.com');
        final newState = baseState.copyWith(user: newUser);
        expect(newState.user, newUser);
      });

      test('can set serverError to null explicitly', () {
        final newState = baseState.copyWith(serverError: null);
        expect(newState.serverError, isNull);
      });

      test('preserves serverError when not provided', () {
        final newState = baseState.copyWith(name: 'Jane');
        expect(newState.serverError, 'Server error');
      });

      test('can update serverError to new value', () {
        final newState = baseState.copyWith(serverError: 'New error');
        expect(newState.serverError, 'New error');
      });

      test('can update multiple fields at once', () {
        const newErrors = SignupErrors(email: 'Email error');
        final newState = baseState.copyWith(
          name: 'Jane Doe',
          email: 'jane@example.com',
          status: SignupStatus.failure,
          errors: newErrors,
          serverError: null,
        );

        expect(newState.name, 'Jane Doe');
        expect(newState.email, 'jane@example.com');
        expect(newState.status, SignupStatus.failure);
        expect(newState.errors, newErrors);
        expect(newState.serverError, isNull);
      });

      test('preserves unchanged fields', () {
        final newState = baseState.copyWith(name: 'Jane');
        expect(newState.email, 'test@example.com');
        expect(newState.password, 'password123');
        expect(newState.confirmPassword, 'password123');
        expect(newState.formSubmitted, true);
        expect(newState.status, SignupStatus.loading);
        expect(newState.revealPassword, true);
        expect(newState.revealConfirmPassword, true);
      });
    });

    group('SignupStatus enum', () {
      test('has all expected values', () {
        expect(SignupStatus.values, [
          SignupStatus.initial,
          SignupStatus.loading,
          SignupStatus.success,
          SignupStatus.failure,
        ]);
      });

      test('initial is default status', () {
        const state = SignupState();
        expect(state.status, SignupStatus.initial);
      });
    });

    group('edge cases', () {
      test('handles empty strings correctly', () {
        const state = SignupState(
          name: '',
          email: '',
          password: '',
          confirmPassword: '',
        );
        expect(state.name, '');
        expect(state.email, '');
        expect(state.password, '');
        expect(state.confirmPassword, '');
      });

      test('handles all false booleans', () {
        const state = SignupState(
          formSubmitted: false,
          revealPassword: false,
          revealConfirmPassword: false,
        );
        expect(state.formSubmitted, false);
        expect(state.revealPassword, false);
        expect(state.revealConfirmPassword, false);
      });

      test('handles all true booleans', () {
        const state = SignupState(
          formSubmitted: true,
          revealPassword: true,
          revealConfirmPassword: true,
        );
        expect(state.formSubmitted, true);
        expect(state.revealPassword, true);
        expect(state.revealConfirmPassword, true);
      });
    });
  });
}
