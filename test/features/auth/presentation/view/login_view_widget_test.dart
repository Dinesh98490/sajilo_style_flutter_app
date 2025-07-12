import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilo_style/features/auth/presentation/view/login_view.dart';
import 'package:sajilo_style/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:sajilo_style/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:sajilo_style/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

class MockLoginViewModel extends Mock implements LoginViewModel {}

void main() {
  late MockLoginViewModel mockLoginViewModel;

  setUpAll(() {
    registerFallbackValue(LoginWithEmailAndPasswordEvent(
      context: null,
      email: 'test@example.com',
      password: 'password',
    ));
  });

  setUp(() {
    mockLoginViewModel = MockLoginViewModel();
    when(() => mockLoginViewModel.stream).thenAnswer((_) => Stream.value(const LoginState.initial()));
    when(() => mockLoginViewModel.state).thenReturn(const LoginState.initial());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<LoginViewModel>.value(
        value: mockLoginViewModel,
        child: const LoginView(),
      ),
    );
  }


  // check the code of the widget test
  group('LoginView Widget Tests', () {
    testWidgets('should display all UI elements correctly', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.text('Sign in to Continue'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Remember Me'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text("Don't have an account?"), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
      expect(find.text('OR'), findsOneWidget);
      
      // Check for icons
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.facebook), findsOneWidget);
    });

    testWidgets('should show validation errors for empty fields', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Assert
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('should toggle password visibility when eye icon is tapped', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      
      // Initially password should be obscured
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      
      // Tap the visibility toggle
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();
      
      // Password should now be visible
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      
      // Tap again to hide password
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();
      
      // Password should be hidden again
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('should toggle remember me checkbox', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      
      // Initially checkbox should be unchecked
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, false);
      
      // Tap the checkbox
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      
      // Checkbox should now be checked
      final updatedCheckbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(updatedCheckbox.value, true);
    });

  // should call login event when form is valid and login button is pressed
    testWidgets('should call login event when form is valid and login button is pressed', (WidgetTester tester) async {
      // Arrange
      when(() => mockLoginViewModel.add(any())).thenReturn(null);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      
      // Enter valid email and password
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      
      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Assert
      verify(() => mockLoginViewModel.add(any())).called(1);
    });

    testWidgets('should not call login event when form is invalid', (WidgetTester tester) async {
      // Arrange
      when(() => mockLoginViewModel.add(any())).thenReturn(null);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      
      // Don't enter any data, just tap login
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Assert
      verifyNever(() => mockLoginViewModel.add(any()));
    });

    testWidgets('should handle form submission with valid data', (WidgetTester tester) async {
      // Arrange
      when(() => mockLoginViewModel.add(any())).thenReturn(null);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      
      // Enter valid data
      await tester.enterText(find.byType(TextFormField).first, 'valid@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'validpassword');
      
      // Submit form
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Assert
      verify(() => mockLoginViewModel.add(any())).called(1);
    });

    testWidgets('should validate email field is required', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      
      // Enter only password
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      
      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Assert
      expect(find.text('Email is required'), findsOneWidget);
      verifyNever(() => mockLoginViewModel.add(any()));
    });

    testWidgets('should validate password field is required', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      
      // Enter only email
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      
      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Assert
      expect(find.text('Password is required'), findsOneWidget);
      verifyNever(() => mockLoginViewModel.add(any()));
    });
  });
} 