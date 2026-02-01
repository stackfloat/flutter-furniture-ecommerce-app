import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_ecommerce_app/features/authentication/presentation/bloc/signup/signup_event.dart';

void main() {
  group('SignupEvent', () {
    group('NameChanged', () {
      test('supports value equality', () {
        expect(
          const NameChanged('John Doe'),
          equals(const NameChanged('John Doe')),
        );
      });

      test('different names are not equal', () {
        expect(
          const NameChanged('John Doe'),
          isNot(equals(const NameChanged('Jane Doe'))),
        );
      });

      test('props include name', () {
        const event = NameChanged('John Doe');
        expect(event.props, equals(['John Doe']));
      });
    });

    group('EmailChanged', () {
      test('supports value equality', () {
        expect(
          const EmailChanged('test@example.com'),
          equals(const EmailChanged('test@example.com')),
        );
      });

      test('different emails are not equal', () {
        expect(
          const EmailChanged('test1@example.com'),
          isNot(equals(const EmailChanged('test2@example.com'))),
        );
      });

      test('props include email', () {
        const event = EmailChanged('test@example.com');
        expect(event.props, equals(['test@example.com']));
      });
    });

    group('PasswordChanged', () {
      test('supports value equality', () {
        expect(
          const PasswordChanged('password123'),
          equals(const PasswordChanged('password123')),
        );
      });

      test('different passwords are not equal', () {
        expect(
          const PasswordChanged('password123'),
          isNot(equals(const PasswordChanged('password456'))),
        );
      });

      test('props include password', () {
        const event = PasswordChanged('password123');
        expect(event.props, equals(['password123']));
      });
    });

    group('ConfirmPasswordChanged', () {
      test('supports value equality', () {
        expect(
          const ConfirmPasswordChanged('password123'),
          equals(const ConfirmPasswordChanged('password123')),
        );
      });

      test('different confirm passwords are not equal', () {
        expect(
          const ConfirmPasswordChanged('password123'),
          isNot(equals(const ConfirmPasswordChanged('password456'))),
        );
      });

      test('props include confirmPassword', () {
        const event = ConfirmPasswordChanged('password123');
        expect(event.props, equals(['password123']));
      });
    });

    group('SignupSubmitted', () {
      test('supports value equality', () {
        expect(
          const SignupSubmitted(),
          equals(const SignupSubmitted()),
        );
      });

      test('props are empty', () {
        const event = SignupSubmitted();
        expect(event.props, equals([]));
      });

      test('all instances are equal', () {
        const event1 = SignupSubmitted();
        const event2 = SignupSubmitted();
        expect(event1, equals(event2));
      });
    });

    group('RevealPassword', () {
      test('supports value equality', () {
        expect(
          const RevealPassword(true),
          equals(const RevealPassword(true)),
        );
      });

      test('different reveal states are not equal', () {
        expect(
          const RevealPassword(true),
          isNot(equals(const RevealPassword(false))),
        );
      });

      test('props include revealPassword', () {
        const event = RevealPassword(true);
        expect(event.props, equals([true]));
      });

      test('false value works correctly', () {
        const event = RevealPassword(false);
        expect(event.revealPassword, false);
        expect(event.props, equals([false]));
      });
    });

    group('RevealConfirmPassword', () {
      test('supports value equality', () {
        expect(
          const RevealConfirmPassword(true),
          equals(const RevealConfirmPassword(true)),
        );
      });

      test('different reveal states are not equal', () {
        expect(
          const RevealConfirmPassword(true),
          isNot(equals(const RevealConfirmPassword(false))),
        );
      });

      test('props include revealConfirmPassword', () {
        const event = RevealConfirmPassword(true);
        expect(event.props, equals([true]));
      });

      test('false value works correctly', () {
        const event = RevealConfirmPassword(false);
        expect(event.revealConfirmPassword, false);
        expect(event.props, equals([false]));
      });
    });

    group('Event inheritance', () {
      test('all events extend SignupEvent', () {
        expect(const NameChanged('test'), isA<SignupEvent>());
        expect(const EmailChanged('test'), isA<SignupEvent>());
        expect(const PasswordChanged('test'), isA<SignupEvent>());
        expect(const ConfirmPasswordChanged('test'), isA<SignupEvent>());
        expect(const SignupSubmitted(), isA<SignupEvent>());
        expect(const RevealPassword(true), isA<SignupEvent>());
        expect(const RevealConfirmPassword(true), isA<SignupEvent>());
      });
    });
  });
}
