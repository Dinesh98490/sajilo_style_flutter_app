import 'package:dartz/dartz.dart';
import 'package:sajilo_style/core/error/failure.dart';
import 'package:sajilo_style/features/home/data/data_source/product_data_source.dart';
import 'package:sajilo_style/features/home/data/data_source/remote_datasource/product_remote_datasource.dart';
import 'package:sajilo_style/features/home/domain/entity/product_entity.dart';
import 'package:sajilo_style/features/home/domain/repository/product_repository.dart';

class ProductRemoteRepository implements IProductRepository{
  final ProductRemoteDatasource
  _productRemoteDatasource;


  ProductRemoteRepository({
    required ProductRemoteDatasource
    productRemoteDatasource

  })
  : _productRemoteDatasource = productRemoteDatasource;

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final products = await _productRemoteDatasource.getProducts();
      return Right(products);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

}