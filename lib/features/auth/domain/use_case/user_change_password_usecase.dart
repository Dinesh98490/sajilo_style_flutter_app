import 'package:dartz/dartz.dart';
import 'package:sajilo_style/app/use_case/use_case.dart';
import 'package:sajilo_style/core/error/failure.dart';
import 'package:sajilo_style/features/auth/domain/repository/user_repository.dart';

class ChangePasswordParams {
  final String oldPassword;
  final String newPassword;
  ChangePasswordParams({required this.oldPassword, required this.newPassword});
}

class UserChangePasswordUsecase implements UsecaseWithParams<void, ChangePasswordParams> {
  final IUserRepository _userRepository;
  UserChangePasswordUsecase({required IUserRepository userRepository}) : _userRepository = userRepository;
  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) {
    return _userRepository.changePassword(params.oldPassword, params.newPassword);
  }
} 