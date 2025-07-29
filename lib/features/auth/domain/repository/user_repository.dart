import 'package:dartz/dartz.dart';
import 'package:sajilo_style/core/error/failure.dart';
import 'package:sajilo_style/features/auth/domain/entity/user_entity.dart';

abstract interface class IUserRepository{
  Future<Either<Failure, void>>  registerUser (UserEntity user);

  Future<Either<Failure, String>> loginUser(
    String email,
    String password,
  );


  Future<Either<Failure, UserEntity>> getCurrentUser();
  Future<Either<Failure, void>> updateProfile(UserEntity user);
  Future<Either<Failure, void>> changePassword(String oldPassword, String newPassword);
}
