import 'package:fpdart/fpdart.dart';
import 'package:furniture_ecommerce_app/core/errors/failure.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/entities/user.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/usecases/signup_params.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/usecases/signup_usecase.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/value_objects/confirmed_password.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/value_objects/email.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/value_objects/name.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/value_objects/password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignupUseCase signupUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signupUseCase = SignupUseCase(mockAuthRepository);
  });

  final tUserEntity = User(id: 1, name: 'Test User', email: 'test@example.com');
  final tName = Name('Test User');
  final tEmail = Email('test@example.com');
  final tPassword = Password('password123');

  test('should call the [AuthRepository.signup] method', () async {
    // Arrange
    when(
      () => mockAuthRepository.signup(any(), any(), any()),
    ).thenAnswer((_) async => Right(tUserEntity));

    // Act
    final result = await signupUseCase(
      SignupParams(
        name: tName,
        email: tEmail,
        password: ConfirmedPassword(
          password: tPassword.value,
          confirmation: tPassword.value,
        ),
      ),
    );

    // Assert
    verify(
      () => mockAuthRepository.signup(tName.value, tEmail.value, tPassword.value),
    ).called(1);

    expect(result, Right(tUserEntity));

    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return [ApiFailure] when the API call fails', () async {
    // Arrange
    when(
      () => mockAuthRepository.signup(any(), any(), any()),
    ).thenAnswer((_) async => Left(ApiFailure(message: 'API call failed')));

    // Act
    final result = await signupUseCase(
      SignupParams(
        name: tName,
        email: tEmail,
        password: ConfirmedPassword(
          password: tPassword.value,
          confirmation: tPassword.value,
        ),
      ),
    );

    // Assert
    verify(
      () => mockAuthRepository.signup(tName.value, tEmail.value, tPassword.value),
    ).called(1);
    expect(result, Left(ApiFailure(message: 'API call failed')));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
