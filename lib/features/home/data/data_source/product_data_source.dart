import 'package:sajilo_style/features/home/domain/entity/product_entity.dart';

abstract interface class IProductDataSource{
  Future<List<ProductEntity>> getProducts(); 

}