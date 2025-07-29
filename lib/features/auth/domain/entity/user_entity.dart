import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';


// etntity of the user
class UserEntity extends Equatable {
  final String? userId;
  final String  fullName;
  final String email;
  final String phone_number;
  final String password;
  final String role;



  const UserEntity({
    this.userId,
    required this.fullName,
    required this.email,
    required this.phone_number,
    required this.password,
    required this.role

  });

  UserEntity copyWith({
    String? userId,
    String? fullName,
    String? email,
    String? phone_number,
    String? password,
    String? role,
  }) {
    return UserEntity(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone_number: phone_number ?? this.phone_number,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    fullName,
    email,
    phone_number,
    password,
    role
  ];
}