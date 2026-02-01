import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signup/signup_errors.dart';

void main() {
  group('SignupErrors', () {
    group('constructor', () {
      test('creates errors with all null by default', () {
        const errors = SignupErrors();
        expect(errors.name, isNull);
        expect(errors.email, isNull);
        expect(errors.password, isNull);
        expect(errors.confirmPassword, isNull);
      });

      test('creates errors with specified values', () {
        const errors = SignupErrors(
          name: 'Name error',
          email: 'Email error',
          password: 'Password error',
          confirmPassword: 'Confirm password error',
        );
        expect(errors.name, 'Name error');
        expect(errors.email, 'Email error');
        expect(errors.password, 'Password error');
        expect(errors.confirmPassword, 'Confirm password error');
      });
    });

    group('empty constant', () {
      test('has all null values', () {
        expect(SignupErrors.empty.name, isNull);
        expect(SignupErrors.empty.email, isNull);
        expect(SignupErrors.empty.password, isNull);
        expect(SignupErrors.empty.confirmPassword, isNull);
      });

      test('hasErrors is false', () {
        expect(SignupErrors.empty.hasErrors, false);
      });
    });

    group('hasErrors', () {
      test('returns false when all fields are null', () {
        const errors = SignupErrors();
        expect(errors.hasErrors, false);
      });

      test('returns true when name has error', () {
        const errors = SignupErrors(name: 'Name is required');
        expect(errors.hasErrors, true);
      });

      test('returns true when email has error', () {
        const errors = SignupErrors(email: 'Invalid email');
        expect(errors.hasErrors, true);
      });

      test('returns true when password has error', () {
        const errors = SignupErrors(password: 'Password too short');
        expect(errors.hasErrors, true);
      });

      test('returns true when confirmPassword has error', () {
        const errors = SignupErrors(confirmPassword: 'Passwords do not match');
        expect(errors.hasErrors, true);
      });

      test('returns true when multiple fields have errors', () {
        const errors = SignupErrors(
          name: 'Name error',
          email: 'Email error',
        );
        expect(errors.hasErrors, true);
      });

      test('returns true when all fields have errors', () {
        const errors = SignupErrors(
          name: 'Name error',
          email: 'Email error',
          password: 'Password error',
          confirmPassword: 'Confirm error',
        );
        expect(errors.hasErrors, true);
      });
    });

    group('value equality', () {
      test('supports value equality', () {
        expect(
          const SignupErrors(name: 'Error', email: 'Error'),
          equals(const SignupErrors(name: 'Error', email: 'Error')),
        );
      });

      test('different errors are not equal', () {
        expect(
          const SignupErrors(name: 'Error1'),
          isNot(equals(const SignupErrors(name: 'Error2'))),
        );
      });

      test('empty errors are equal', () {
        expect(
          const SignupErrors(),
          equals(const SignupErrors()),
        );
      });
    });

    group('props', () {
      test('include all error fields', () {
        const errors = SignupErrors(
          name: 'Name error',
          email: 'Email error',
          password: 'Password error',
          confirmPassword: 'Confirm error',
        );
        expect(errors.props, [
          'Name error',
          'Email error',
          'Password error',
          'Confirm error',
        ]);
      });

      test('include null values', () {
        const errors = SignupErrors(name: 'Name error');
        expect(errors.props, ['Name error', null, null, null]);
      });
    });

    group('copyWith', () {
      const baseErrors = SignupErrors(
        name: 'Name error',
        email: 'Email error',
        password: 'Password error',
        confirmPassword: 'Confirm error',
      );

      test('returns same object when no parameters', () {
        expect(baseErrors.copyWith(), equals(baseErrors));
      });

      test('updates name when provided', () {
        final newErrors = baseErrors.copyWith(name: 'New name error');
        expect(newErrors.name, 'New name error');
        expect(newErrors.email, 'Email error');
        expect(newErrors.password, 'Password error');
        expect(newErrors.confirmPassword, 'Confirm error');
      });

      test('updates email when provided', () {
        final newErrors = baseErrors.copyWith(email: 'New email error');
        expect(newErrors.name, 'Name error');
        expect(newErrors.email, 'New email error');
        expect(newErrors.password, 'Password error');
        expect(newErrors.confirmPassword, 'Confirm error');
      });

      test('updates password when provided', () {
        final newErrors = baseErrors.copyWith(password: 'New password error');
        expect(newErrors.name, 'Name error');
        expect(newErrors.email, 'Email error');
        expect(newErrors.password, 'New password error');
        expect(newErrors.confirmPassword, 'Confirm error');
      });

      test('updates confirmPassword when provided', () {
        final newErrors = baseErrors.copyWith(confirmPassword: 'New confirm error');
        expect(newErrors.name, 'Name error');
        expect(newErrors.email, 'Email error');
        expect(newErrors.password, 'Password error');
        expect(newErrors.confirmPassword, 'New confirm error');
      });

      test('can clear name error by setting to null', () {
        final newErrors = baseErrors.copyWith(name: null);
        expect(newErrors.name, isNull);
        expect(newErrors.email, 'Email error');
        expect(newErrors.password, 'Password error');
        expect(newErrors.confirmPassword, 'Confirm error');
      });

      test('can clear email error by setting to null', () {
        final newErrors = baseErrors.copyWith(email: null);
        expect(newErrors.name, 'Name error');
        expect(newErrors.email, isNull);
        expect(newErrors.password, 'Password error');
        expect(newErrors.confirmPassword, 'Confirm error');
      });

      test('can clear password error by setting to null', () {
        final newErrors = baseErrors.copyWith(password: null);
        expect(newErrors.name, 'Name error');
        expect(newErrors.email, 'Email error');
        expect(newErrors.password, isNull);
        expect(newErrors.confirmPassword, 'Confirm error');
      });

      test('can clear confirmPassword error by setting to null', () {
        final newErrors = baseErrors.copyWith(confirmPassword: null);
        expect(newErrors.name, 'Name error');
        expect(newErrors.email, 'Email error');
        expect(newErrors.password, 'Password error');
        expect(newErrors.confirmPassword, isNull);
      });

      test('can update multiple fields at once', () {
        final newErrors = baseErrors.copyWith(
          name: 'New name',
          password: 'New password',
        );
        expect(newErrors.name, 'New name');
        expect(newErrors.email, 'Email error');
        expect(newErrors.password, 'New password');
        expect(newErrors.confirmPassword, 'Confirm error');
      });

      test('can clear all errors', () {
        final newErrors = baseErrors.copyWith(
          name: null,
          email: null,
          password: null,
          confirmPassword: null,
        );
        expect(newErrors.hasErrors, false);
        expect(newErrors, equals(SignupErrors.empty));
      });

      test('preserves unchanged fields from empty errors', () {
        const emptyErrors = SignupErrors();
        final newErrors = emptyErrors.copyWith(name: 'Name error');
        expect(newErrors.name, 'Name error');
        expect(newErrors.email, isNull);
        expect(newErrors.password, isNull);
        expect(newErrors.confirmPassword, isNull);
      });
    });
  });
}
