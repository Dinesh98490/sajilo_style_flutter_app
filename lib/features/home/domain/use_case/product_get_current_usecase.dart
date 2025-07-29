import 'package:dartz/dartz.dart';
import 'package:sajilo_style/app/use_case/use_case.dart';
import 'package:sajilo_style/core/error/failure.dart';
import 'package:sajilo_style/features/home/domain/entity/product_entity.dart';
import 'package:sajilo_style/features/home/domain/repository/product_repository.dart';

class ProductGetCurrentUsecase implements
UsecaseWithoutParams<List<ProductEntity>>{
  final IProductRepository _iproductRepository;


  ProductGetCurrentUsecase({required IProductRepository productRepository})
  : _iproductRepository = productRepository;

  @override
  Future<Either<Failure, List<ProductEntity>>> call() {
     return _iproductRepository.getProducts();
  }
}