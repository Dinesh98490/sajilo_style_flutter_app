import 'package:sajilo_style/core/network/hive_service.dart';
import 'package:sajilo_style/features/home/data/data_source/product_data_source.dart';
import 'package:sajilo_style/features/home/domain/entity/product_entity.dart';

class ProductLocalDatasource implements IProductDataSource{

  final HiveService _hiveService;

  ProductLocalDatasource({required HiveService hiveService})
  : _hiveService=hiveService;

  @override
  Future<List<ProductEntity>> getProducts() {
    // TODO: implement getProducts
    throw UnimplementedError();
  }

  

}