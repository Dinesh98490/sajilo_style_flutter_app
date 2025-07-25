import 'package:flutter/cupertino.dart';

@immutable
sealed class LoginEvent {}

class NavigateToRegisterViewEvent extends LoginEvent {
  final BuildContext context;

  NavigateToRegisterViewEvent({required this.context});
}

class NavigateToHomeViewEvent extends LoginEvent {
  final BuildContext context;

  NavigateToHomeViewEvent({required this.context});
}

class LoginWithEmailAndPasswordEvent extends LoginEvent {
  final BuildContext? context;
  final String email;
  final String password;

  LoginWithEmailAndPasswordEvent({
    this.context,
    required this.email,
    required this.password,
  });
}
