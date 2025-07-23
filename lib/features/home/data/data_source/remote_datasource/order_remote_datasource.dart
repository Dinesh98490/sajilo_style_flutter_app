import 'package:dio/dio.dart';
import 'package:sajilo_style/core/network/api_service.dart';
import 'package:sajilo_style/app/constant/api_endpoints.dart';
import 'package:sajilo_style/app/shared_pref/token_shared_prefs.dart';
import 'package:sajilo_style/features/home/data/model/order_api_model.dart';

class OrderRemoteDataSource {
  final ApiService _apiService;
  final TokenSharedPrefs _tokenSharedPrefs;
  OrderRemoteDataSource({required ApiService apiService, required TokenSharedPrefs tokenSharedPrefs})
      : _apiService = apiService, _tokenSharedPrefs = tokenSharedPrefs;

  Future<Options> _getAuthOptions() async {
    final tokenResult = await _tokenSharedPrefs.getToken();
    final token = tokenResult.fold((failure) => null, (t) => t);
    if (token == null || token.isEmpty) throw Exception('No token found');
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  Future<List<OrderApiModel>> getOrders() async {
    final options = await _getAuthOptions();
    final response = await _apiService.dio.get(
      ApiEndpoints.getorders,
      options: options,
    );
    if (response.statusCode == 200 && response.data['success'] == true) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => OrderApiModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to fetch orders: ${response.data['message']}');
    }
  }
} 