import 'package:dartz/dartz.dart';
import 'package:sajilo_style/core/error/failure.dart';
import 'package:sajilo_style/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:sajilo_style/features/auth/domain/entity/user_entity.dart';
import 'package:sajilo_style/features/auth/domain/repository/user_repository.dart';



// local repository
class UserLocalRepository implements IUserRepository {

  final UserLocalDatasource _userLocalDatasource;


  UserLocalRepository({
    required UserLocalDatasource userLocalDatasource,
  }) : _userLocalDatasource = userLocalDatasource;


  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> loginUser(
    String username,
    String password,
  ) async {
    try {
      final result = await _userLocalDatasource.loginUser(
        username,
        password,
      );
      return Right(result);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Failed to login: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user)  async {
      try {
      await _userLocalDatasource.registerUser(user);
      return Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: "Failed to register: $e"));
    }
}

  @override
  Future<Either<Failure, void>> updateProfile(UserEntity user) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, void>> changePassword(String oldPassword, String newPassword) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }
}
