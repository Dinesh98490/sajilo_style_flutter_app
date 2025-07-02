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