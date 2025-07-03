import 'package:dartz/dartz.dart';
import 'package:sajilo_style/core/error/failure.dart';
import 'package:sajilo_style/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:sajilo_style/features/auth/domain/entity/user_entity.dart';
import 'package:sajilo_style/features/auth/domain/repository/user_repository.dart';


class UserRemoteRepository  implements IUserRepository {
  final UserRemoteDatasource _userRemoteDataSource;

    UserRemoteRepository({
      required UserRemoteDatasource userRemoteDatasource
      })
      : _userRemoteDataSource = userRemoteDatasource;



  @override
  Future<Either<Failure, UserEntity>> getCurrentUser()  async {
    try {
      final user = await _userRemoteDataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
    
  }

  // login User Remote Repository
  @override
  Future<Either<Failure, String>> loginUser(String email, String password)
  async {

     try {
      final token = await _userRemoteDataSource.loginUser(
        email,
        password,
      );
      return Right(token);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }


    
  }

  // register user Remote Repository
  @override
  Future<Either<Failure, void>> registerUser(UserEntity user)  async {

     try {
      await _userRemoteDataSource.registerUser(user);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  
  }
}