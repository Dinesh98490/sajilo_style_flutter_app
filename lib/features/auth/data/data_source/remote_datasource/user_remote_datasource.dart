import 'package:sajilo_style/features/auth/data/data_source/user_data_source.dart';
import 'package:sajilo_style/features/auth/domain/entity/user_entity.dart';

class UserRemoteDatasource implements IUserDataSource {
  @override
  Future<UserEntity> getCurrentUser() async {
    // TODO: Implement API logic to fetch current user
    throw UnimplementedError('getCurrentUser is not implemented');
  }

  @override
  Future<String> loginUser(String email, String password) async {
    // TODO: Implement API logic to log in user
    throw UnimplementedError('loginUser is not implemented');
  }

  @override
  Future<void> registerUser(UserEntity userData) async {
    // TODO: Implement API logic to register user
    throw UnimplementedError('registerUser is not implemented');
  }
}
