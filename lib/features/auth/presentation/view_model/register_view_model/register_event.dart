import 'package:flutter/widgets.dart';

@immutable
sealed class RegisterEvent {}

class RegisterUserEvent extends RegisterEvent {
  final BuildContext context;
  final String fullName;
  final String email;
  final String phone_number;
  final String password;
  final String role;

  RegisterUserEvent({
    required this.context,
    required this.fullName,
    required this.email,
    required this.phone_number,
    required this.password,
    this.role="Customer"

  });
}


