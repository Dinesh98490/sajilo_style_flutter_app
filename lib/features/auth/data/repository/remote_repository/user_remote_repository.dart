import 'package:dartz/dartz.dart';
import 'package:sajilo_style/core/error/failure.dart';
import 'package:sajilo_style/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:sajilo_style/features/auth/domain/entity/user_entity.dart';
import 'package:sajilo_style/features/auth/domain/repository/user_repository.dart';


class UserRemoteRepository  implements IUserRepository {
  final UserRemoteDatasource _dataSource;

    UserRemoteRepository({required UserRemoteDatasource datasource})
      : _dataSource = datasource;



  @override
  Future<Either<Failure, UserEntity>> getCurrentUser()  {
    // TODO: implement loginUser
    throw UnimplementedError();
    
  }

  @override
  Future<Either<Failure, String>> loginUser(String email, String password) {
    // TODO: implement loginUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> registerUser(UserEntity user) {
    // TODO: implement registerUser
    throw UnimplementedError();
  }
}