import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:furniture_ecommerce_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:furniture_ecommerce_app/features/authentication/domain/usecases/clear_session_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late ClearSessionUseCase clearSessionUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    clearSessionUseCase = ClearSessionUseCase(mockAuthRepository);
  });

  test('should call AuthRepository.clearSession', () async {
    // Arrange
    when(() => mockAuthRepository.clearSession())
        .thenAnswer((_) async => Future.value());

    // Act
    await clearSessionUseCase();

    // Assert
    verify(() => mockAuthRepository.clearSession()).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
