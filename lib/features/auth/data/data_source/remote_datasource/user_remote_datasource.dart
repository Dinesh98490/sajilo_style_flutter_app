import 'package:dio/dio.dart';
import 'package:sajilo_style/app/constant/api_endpoints.dart';
import 'package:sajilo_style/core/network/api_service.dart';
import 'package:sajilo_style/features/auth/data/data_source/user_data_source.dart';
import 'package:sajilo_style/features/auth/data/model/user_api_model.dart';
import 'package:sajilo_style/features/auth/domain/entity/user_entity.dart';
import 'package:sajilo_style/app/shared_pref/token_shared_prefs.dart';

class UserRemoteDatasource  implements IUserDataSource{

  final ApiService _apiService;
  final TokenSharedPrefs _tokenSharedPrefs;
  UserRemoteDatasource({required ApiService apiService, required TokenSharedPrefs tokenSharedPrefs})
    : _apiService = apiService, _tokenSharedPrefs = tokenSharedPrefs;


  @override
  Future<UserEntity> getCurrentUser() async {
    // Retrieve token from shared preferences
    final tokenResult = await _tokenSharedPrefs.getToken();
    return tokenResult.fold((failure) => throw Exception(failure.message), (token) async {
      if (token == null || token.isEmpty) {
        throw Exception('No token found');
      }
      try {
        final response = await _apiService.dio.get(
          ApiEndpoints.getme,
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );
        print(response.statusCode);
        print(response.data['data']);
        if (response.statusCode == 200) {
          // Handle nested 'data' field in API response
          final userJson = response.data['data'] ?? response.data;
          final userApiModel = UserApiModel.fromJson(userJson);
          return userApiModel.toEntity();
        } else if (response.statusCode == 401) {
          // Unauthorized, remove token
          await _tokenSharedPrefs.removeToken();
          throw Exception('Invalid or expired token. Please log in again.');
        } else {
          throw Exception(response.statusMessage);
        }
      } on DioException catch (e) {
        if (e.response?.statusCode == 401) {
          await _tokenSharedPrefs.removeToken();
          throw Exception('Invalid or expired token. Please log in again.');
        }
        throw Exception('Failed to fetch current user: ${e.message}');
      } catch (e) {
        throw Exception('Failed to fetch current user: $e');
      }
    });
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