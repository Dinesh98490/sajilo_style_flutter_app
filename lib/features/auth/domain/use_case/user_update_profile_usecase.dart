import 'package:dartz/dartz.dart';
import 'package:sajilo_style/app/use_case/use_case.dart';
import 'package:sajilo_style/core/error/failure.dart';
import 'package:sajilo_style/features/auth/domain/entity/user_entity.dart';
import 'package:sajilo_style/features/auth/domain/repository/user_repository.dart';

class UserUpdateProfileUsecase implements UsecaseWithParams<void, UserEntity> {
  final IUserRepository _userRepository;
  UserUpdateProfileUsecase({required IUserRepository userRepository}) : _userRepository = userRepository;
  @override
  Future<Either<Failure, void>> call(UserEntity params) {
    return _userRepository.updateProfile(params);
  }
} 