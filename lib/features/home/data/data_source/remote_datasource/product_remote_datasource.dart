import 'package:sajilo_style/app/constant/api_endpoints.dart';
import 'package:sajilo_style/core/network/api_service.dart';
import 'package:sajilo_style/features/home/data/data_source/product_data_source.dart';
import 'package:sajilo_style/features/home/data/model/product_api_model.dart';
import 'package:sajilo_style/features/home/domain/entity/product_entity.dart';

class ProductRemoteDatasource implements IProductDataSource {
  final ApiService _apiService;

  ProductRemoteDatasource({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<List<ProductEntity>> getProducts() async {
    try {
      final response = await _apiService.dio.get(ApiEndpoints.getProducts);
      print('Raw response data:');
      print(response.data);

      dynamic data = response.data;

      // If the backend wraps the list in a field (e.g., { "products": [...] })
      if (data is Map && data.containsKey('data') && data['data'] is List) {
        data = data['data'];
      }

      if (response.statusCode == 200 && data is List) {
        final List<ProductApiModel> models = data
            .map((json) => ProductApiModel.fromJson(json))
            .toList()
            .cast<ProductApiModel>();
        final List<ProductEntity> entities = models.map((model) => model.toEntity()).toList();
        return entities;
      } else {
        print('Unexpected response format:');
        print(response.data);
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception("Failed to load the products: $e");
    }
  }
}
