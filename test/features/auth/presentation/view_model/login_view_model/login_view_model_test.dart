import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilo_style/core/error/failure.dart';
import 'package:sajilo_style/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:sajilo_style/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:sajilo_style/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:sajilo_style/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

import 'mock_user_login_usecase.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(const LoginParams.initial());
  });

  late MockUserLoginUsecase mockUserLoginUsecase;
  late LoginViewModel loginViewModel;

  setUp(() {
    mockUserLoginUsecase = MockUserLoginUsecase();
    loginViewModel = LoginViewModel(mockUserLoginUsecase);
  });

  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testToken = 'token_123';

  group('LoginViewModel', () {
    blocTest<LoginViewModel, LoginState>(
      'emits [isLoading: true, isSuccess: false], then [isLoading: false, isSuccess: true] when login succeeds',
      build: () {
        when(() => mockUserLoginUsecase(any())).thenAnswer((_) async => const Right(testToken));
        return loginViewModel;
      },
      act: (bloc) => bloc.add(LoginWithEmailAndPasswordEvent(
        context: null, // context is not used in logic for test
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
  });
} 