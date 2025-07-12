import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilo_style/app/shared_pref/token_shared_prefs.dart';
import 'package:sajilo_style/core/error/failure.dart';
import 'package:sajilo_style/features/auth/domain/repository/user_repository.dart';
import 'package:sajilo_style/features/auth/domain/use_case/user_login_usecase.dart';

class MockIUserRepository extends Mock implements IUserRepository {}
class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  late UserLoginUsecase userLoginUsecase;
  late MockIUserRepository mockUserRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;

  setUp(() {
    mockUserRepository = MockIUserRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    userLoginUsecase = UserLoginUsecase(
      userRepository: mockUserRepository,
      tokenSharedPrefs: mockTokenSharedPrefs,
    );
  });

  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testToken = 'jwt_token_123';
  const loginParams = LoginParams(email: testEmail, password: testPassword);


  // review the code of the unit test
  group('UserLoginUsecase Unit Tests', () {
    test('should return token when login is successful', () async {
      // Arrange
      when(() => mockUserRepository.loginUser(testEmail, testPassword))
          .thenAnswer((_) async => const Right(testToken));
      when(() => mockTokenSharedPrefs.saveToken(testToken))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await userLoginUsecase(loginParams);

      // Assert
      expect(result, const Right(testToken));
      verify(() => mockUserRepository.loginUser(testEmail, testPassword)).called(1);
      verify(() => mockTokenSharedPrefs.saveToken(testToken)).called(1);
    });

    test('should return failure when repository login fails', () async {
      // Arrange
      const failure = RemoteDatabaseFailure(message: 'Invalid credentials');
      when(() => mockUserRepository.loginUser(testEmail, testPassword))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await userLoginUsecase(loginParams);

      // Assert
      expect(result, const Left(failure));
      verify(() => mockUserRepository.loginUser(testEmail, testPassword)).called(1);
      verifyNever(() => mockTokenSharedPrefs.saveToken(any()));
    });

    test('should handle empty email and password', () async {
      // Arrange
      const emptyParams = LoginParams(email: '', password: '');
      const failure = RemoteDatabaseFailure(message: 'Email and password are required');
      when(() => mockUserRepository.loginUser('', ''))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await userLoginUsecase(emptyParams);

      // Assert
      expect(result, const Left(failure));
      verify(() => mockUserRepository.loginUser('', '')).called(1);
      verifyNever(() => mockTokenSharedPrefs.saveToken(any()));
    });

    test('should handle network failure from repository', () async {
      // Arrange
      const networkFailure = RemoteDatabaseFailure(
        message: 'Network error',
        statusCode: 500,
      );
      when(() => mockUserRepository.loginUser(testEmail, testPassword))
          .thenAnswer((_) async => const Left(networkFailure));

      // Act
      final result = await userLoginUsecase(loginParams);

      // Assert
      expect(result, const Left(networkFailure));
      verify(() => mockUserRepository.loginUser(testEmail, testPassword)).called(1);
      verifyNever(() => mockTokenSharedPrefs.saveToken(any()));
    });

    test('should handle local database failure from repository', () async {
      // Arrange
      const localFailure = LocalDatabaseFailure(message: 'Database connection failed');
      when(() => mockUserRepository.loginUser(testEmail, testPassword))
          .thenAnswer((_) async => const Left(localFailure));

      // Act
      final result = await userLoginUsecase(loginParams);

      // Assert
      expect(result, const Left(localFailure));
      verify(() => mockUserRepository.loginUser(testEmail, testPassword)).called(1);
      verifyNever(() => mockTokenSharedPrefs.saveToken(any()));
    });


      // should handle different email and password
    test('should handle different email and password combinations', () async {
      // Arrange
      const differentParams = LoginParams(email: 'user@test.com', password: 'different123');
      when(() => mockUserRepository.loginUser('user@test.com', 'different123'))
          .thenAnswer((_) async => const Right('different_token'));
      when(() => mockTokenSharedPrefs.saveToken('different_token'))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await userLoginUsecase(differentParams);

      // Assert
      expect(result, const Right('different_token'));
      verify(() => mockUserRepository.loginUser('user@test.com', 'different123')).called(1);
      verify(() => mockTokenSharedPrefs.saveToken('different_token')).called(1);
    });

    test('should verify LoginParams equality', () async {
      // Arrange
      const params1 = LoginParams(email: 'test@example.com', password: 'password');
      const params2 = LoginParams(email: 'test@example.com', password: 'password');
      const params3 = LoginParams(email: 'different@example.com', password: 'password');

      // Assert
      expect(params1, equals(params2));
      expect(params1, isNot(equals(params3)));
    });

    test('should verify LoginParams initial constructor', () async {
      // Arrange
      const initialParams = LoginParams.initial();

      // Assert
      expect(initialParams.email, equals(''));
      expect(initialParams.password, equals(''));
    });
  });
} 