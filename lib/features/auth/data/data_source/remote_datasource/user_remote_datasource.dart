import 'package:dio/dio.dart';
import 'package:sajilo_style/app/constant/api_endpoints.dart';
import 'package:sajilo_style/core/network/api_service.dart';
import 'package:sajilo_style/features/auth/data/data_source/user_data_source.dart';
import 'package:sajilo_style/features/auth/data/model/user_api_model.dart';
import 'package:sajilo_style/features/auth/domain/entity/user_entity.dart';

class UserRemoteDatasource  implements IUserDataSource{

  final ApiService _apiService;
  UserRemoteDatasource({required ApiService apiService})
    : _apiService = apiService;


  @override
  Future<UserEntity> getCurrentUser() {
    
    throw UnimplementedError();
  }

  @override
  Future<String> loginUser(String email, String password) async {

    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        final str = response.data['token'];
        return str;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioException catch (e) {
      throw Exception('Failed to login user: ${e.message}');
    } catch (e) {
      throw Exception('Failed to login user: $e');
    
  }
  }

  @override
  Future<void> registerUser(UserEntity userData) async {
   try {
      final userApiModel = UserApiModel.fromEntity(userData);
      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: userApiModel.toJson(),
      );
      print(response.statusCode);
      if (response.statusCode == 201) {
        return;
      } else {
        throw Exception(
          'Failed to register user: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Failed to register user: ${e.message}');
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }


}