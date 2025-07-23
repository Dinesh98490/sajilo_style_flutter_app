import 'package:dio/dio.dart';
import 'package:sajilo_style/core/network/api_service.dart';
import 'package:sajilo_style/features/home/data/data_source/cart_data_source.dart';
import 'package:sajilo_style/features/home/domain/entity/cart_entity.dart';
import 'package:sajilo_style/features/home/domain/entity/product_entity.dart';
import 'package:sajilo_style/app/constant/api_endpoints.dart';
import 'package:sajilo_style/features/home/data/model/cart_api_model.dart';
import 'package:sajilo_style/app/shared_pref/token_shared_prefs.dart';

class CartRemoteDataSource implements ICartDataSource {
  final ApiService _apiService;
  final TokenSharedPrefs _tokenSharedPrefs;
  CartRemoteDataSource({required ApiService apiService, required TokenSharedPrefs tokenSharedPrefs})
      : _apiService = apiService, _tokenSharedPrefs = tokenSharedPrefs;

  Future<Options> _getAuthOptions() async {
    final tokenResult = await _tokenSharedPrefs.getToken();
    final token = tokenResult.fold((failure) => null, (t) => t);
    if (token == null || token.isEmpty) throw Exception('No token found');
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<List<CartEntity>> getCartItems() async {
    final options = await _getAuthOptions();
    final response = await _apiService.dio.get(ApiEndpoints.getcart, options: options);
    if (response.statusCode == 200) {
      final data = response.data['data'] ?? response.data;
      print('Cart API raw data: $data');
      if (data is List) {
        final models = <CartApiModel>[];
        for (final item in data) {
          if (item is Map<String, dynamic>) {
            try {
              models.add(CartApiModel.fromJson(item));
            } catch (e) {
              print('Failed to parse cart item: $item, error: $e');
            }
          } else {
            print('Skipping non-map item in cart data: $item (type: ${item.runtimeType})');
          }
        }
        return CartApiModel.toEntityList(models);
      } else {
        print('Cart API data is not a List: $data (type: ${data.runtimeType})');
      }
    }
    throw Exception('Failed to fetch cart items');
  }

  @override
  Future<void> addToCart(ProductEntity product, {int quantity = 1}) async {
    final options = await _getAuthOptions();
    await _apiService.dio.post(
      ApiEndpoints.addorgetcart,
      data: {
        'product_id': product.id,
        'total_price': product.price * quantity,
        'total_product': quantity,
        'discount': 0, // Dummy discount
      },
      options: options,
    );
  }

  @override
  Future<void> removeFromCart(String productId) async {
    final options = await _getAuthOptions();
    await _apiService.dio.delete(
      '${ApiEndpoints.deletecart}?productId=$productId',
      options: options,
    );
  }

  @override
  Future<void> updateQuantity(String productId, int quantity) async {
    final options = await _getAuthOptions();
    await _apiService.dio.put(
      '${ApiEndpoints.updatecart}?id=$productId',
      data: {
        'quantity': quantity,
      },
      options: options,
    );
  }
} 