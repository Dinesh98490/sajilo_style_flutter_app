import 'package:dartz/dartz.dart';
import 'package:sajilo_style/core/error/failure.dart';
import 'package:sajilo_style/features/home/domain/entity/product_entity.dart';

abstract interface class IProductRepository{

  Future<Either<Failure, List<ProductEntity>>> getProducts(); 

}