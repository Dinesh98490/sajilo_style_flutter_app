import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilo_style/core/error/failure.dart';
import 'package:sajilo_style/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:sajilo_style/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:sajilo_style/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:sajilo_style/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

class MockUserLoginUsecase extends Mock implements UserLoginUsecase {}

void main() {
  late MockUserLoginUsecase mockUserLoginUsecase;
  late LoginViewModel loginViewModel;

  setUp(() {
    mockUserLoginUsecase = MockUserLoginUsecase();
    loginViewModel = LoginViewModel(mockUserLoginUsecase);
  });

  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testToken = 'token_123';

  setUpAll(() {
    registerFallbackValue(const LoginParams.initial());
  });



  group('LoginViewModel Bloc Tests', () {
    blocTest<LoginViewModel, LoginState>(
      'emits [isLoading: true, isSuccess: false], then [isLoading: false, isSuccess: true] when login succeeds',
      build: () {
        when(() => mockUserLoginUsecase(any())).thenAnswer((_) async => const Right(testToken));
        return loginViewModel;
      },
      act: (bloc) => bloc.add(LoginWithEmailAndPasswordEvent(
        context: null,
        email: testEmail,
        password: testPassword,
      )),
      expect: () => [
        const LoginState(isLoading: true, isSuccess: false),
        const LoginState(isLoading: false, isSuccess: true),
      ],
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [isLoading: true, isSuccess: false], then [isLoading: false, isSuccess: false] when login fails',
      build: () {
        when(() => mockUserLoginUsecase(any())).thenAnswer((_) async => Left(LocalDatabaseFailure(message: 'Invalid credentials')));
        return loginViewModel;
      },
      act: (bloc) => bloc.add(LoginWithEmailAndPasswordEvent(
        context: null,
        email: testEmail,
        password: testPassword,
      )),
      expect: () => [
        const LoginState(isLoading: true, isSuccess: false),
        const LoginState(isLoading: false, isSuccess: false),
      ],
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [isLoading: true, isSuccess: false], then [isLoading: false, isSuccess: false] when network error occurs',
      build: () {
        when(() => mockUserLoginUsecase(any())).thenAnswer((_) async => Left(RemoteDatabaseFailure(message: 'Network error')));
        return loginViewModel;
      },
      act: (bloc) => bloc.add(LoginWithEmailAndPasswordEvent(
        context: null,
        email: testEmail,
        password: testPassword,
      )),
      expect: () => [
        const LoginState(isLoading: true, isSuccess: false),
        const LoginState(isLoading: false, isSuccess: false),
      ],
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [isLoading: true, isSuccess: false], then [isLoading: false, isSuccess: false] when shared preferences error occurs',
      build: () {
        when(() => mockUserLoginUsecase(any())).thenAnswer((_) async => Left(SharedPreferencesFailure(message: 'Storage error')));
        return loginViewModel;
      },
      act: (bloc) => bloc.add(LoginWithEmailAndPasswordEvent(
        context: null,
        email: testEmail,
        password: testPassword,
      )),
      expect: () => [
        const LoginState(isLoading: true, isSuccess: false),
        const LoginState(isLoading: false, isSuccess: false),
      ],
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [isLoading: true, isSuccess: false], then [isLoading: false, isSuccess: true] with different credentials',
      build: () {
        when(() => mockUserLoginUsecase(any())).thenAnswer((_) async => const Right('different_token'));
        return loginViewModel;
      },
      act: (bloc) => bloc.add(LoginWithEmailAndPasswordEvent(
        context: null,
        email: 'user@test.com',
        password: 'different123',
      )),
      expect: () => [
        const LoginState(isLoading: true, isSuccess: false),
        const LoginState(isLoading: false, isSuccess: true),
      ],
    );

    blocTest<LoginViewModel, LoginState>(
      'emits [isLoading: true, isSuccess: false], then [isLoading: false, isSuccess: false] with empty credentials',
      build: () {
        when(() => mockUserLoginUsecase(any())).thenAnswer((_) async => Left(LocalDatabaseFailure(message: 'Empty credentials')));
        return loginViewModel;
      },
      act: (bloc) => bloc.add(LoginWithEmailAndPasswordEvent(
        context: null,
        email: '',
        password: '',
      )),
      expect: () => [
        const LoginState(isLoading: true, isSuccess: false),
        const LoginState(isLoading: false, isSuccess: false),
      ],
    );

    test('initial state should be LoginState.initial()', () {
      expect(loginViewModel.state, const LoginState.initial());
    });

    test('should emit correct states when login process starts and succeeds', () async {
      when(() => mockUserLoginUsecase(any())).thenAnswer((_) async => const Right(testToken));

      expect(loginViewModel.state, const LoginState.initial());

      loginViewModel.add(LoginWithEmailAndPasswordEvent(
        context: null,
        email: testEmail,
        password: testPassword,
      ));

      await Future.delayed(const Duration(milliseconds: 100));
      expect(loginViewModel.state, const LoginState(isLoading: false, isSuccess: true));
    });

    test('should emit correct states when login process starts and fails', () async {
      when(() => mockUserLoginUsecase(any())).thenAnswer((_) async => Left(LocalDatabaseFailure(message: 'Invalid credentials')));

      expect(loginViewModel.state, const LoginState.initial());

      loginViewModel.add(LoginWithEmailAndPasswordEvent(
        context: null,
        email: testEmail,
        password: testPassword,
      ));

      await Future.delayed(const Duration(milliseconds: 100));
      expect(loginViewModel.state, const LoginState(isLoading: false, isSuccess: false));
    });
  });
} 