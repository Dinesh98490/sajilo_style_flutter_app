import 'package:dio/dio.dart';
import 'package:sajilo_style/core/network/api_service.dart';
import 'package:sajilo_style/app/constant/api_endpoints.dart';
import 'package:sajilo_style/app/shared_pref/token_shared_prefs.dart';

class PaymentOrderRemoteDataSource {
  final ApiService _apiService;
  final TokenSharedPrefs _tokenSharedPrefs;
  PaymentOrderRemoteDataSource({required ApiService apiService, required TokenSharedPrefs tokenSharedPrefs})
      : _apiService = apiService, _tokenSharedPrefs = tokenSharedPrefs;

  Future<Options> _getAuthOptions() async {
    final tokenResult = await _tokenSharedPrefs.getToken();
    final token = tokenResult.fold((failure) => null, (t) => t);
    if (token == null || token.isEmpty) throw Exception('No token found');
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  Future<Map<String, dynamic>> createPaymentAndOrder({
    // required String userId,
    required String paymentMethod,
    required double price,
    required String address,
    required String productId,
    required int quantity,
  }) async {
    final options = await _getAuthOptions();
    // 1. Create Payment
    final paymentResponse = await _apiService.dio.post(
      ApiEndpoints.createPayment,
      data: {
        // 'user_id': userId,
        'payment_method': paymentMethod,
        'price': price,
        'date': DateTime.now().toIso8601String(),
      },
      options: options,
    );
    if (paymentResponse.statusCode != 201 || paymentResponse.data['success'] != true) {
      throw Exception('Failed to create payment: ${paymentResponse.data['message']}');
    }
    final paymentId = paymentResponse.data['data']['_id'];

    final orderResponse = await _apiService.dio.post(
      ApiEndpoints.getorders,
      data: {
        'product_id': productId,
        // 'user_id': userId,
        'payment_id': paymentId,
        'address': address,
        'price': price,
        'quantity': quantity,
      },
      options: options,
    );
    if (orderResponse.statusCode != 201 || orderResponse.data['success'] != true) {
      throw Exception('Failed to create order: ${orderResponse.data['message']}');
    }
    return orderResponse.data['data'] as Map<String, dynamic>;
  }
} 