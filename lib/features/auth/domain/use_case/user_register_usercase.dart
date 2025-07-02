import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sajilo_style/app/use_case/use_case.dart';
import 'package:sajilo_style/core/error/failure.dart';
import 'package:sajilo_style/features/auth/domain/entity/user_entity.dart';
import 'package:sajilo_style/features/auth/domain/repository/user_repository.dart';

class RegisterUserParams  extends Equatable {
  final String fullName;
  final String email;
  final String phone_number;
  final String password;
  final String role;

  const RegisterUserParams({
    required this.fullName,
    required this.email,
    required this.phone_number,
    required this.password,
    required this.role
  });

  // initialize constructor 
  const RegisterUserParams.initial({
    required this.fullName,
    required this.email,
    required this.phone_number,
    required this.password,
    required this.role
  });


  @override
  List<Object?> get props => [
    fullName,
    email,
    phone_number, 
    password,
    role
  ];

}


class UserRegisterUsercase implements UsecaseWithParams<void, RegisterUserParams>{
  final IUserRepository _userRepository;

    UserRegisterUsercase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) {

    final userEntity = UserEntity(
      fullName: params.fullName, 
      email: params.email, 
      phone_number: params.phone_number, 
      password: params.password,
      role: params.role
      
    );
    return _userRepository.registerUser(userEntity);
    
  }
    
}