import 'package:equatable/equatable.dart';
import 'package:sajilo_style/features/auth/domain/entity/user_entity.dart';
import 'package:sajilo_style/features/home/domain/entity/product_entity.dart';

class CartEntity extends Equatable {
  final String? id;
  final UserEntity? user;
  final ProductEntity? product;
  final num totalPrice;
  final int totalProduct;
  final int? v;

  const CartEntity({
    this.id,
    this.user,
    this.product,
    required this.totalPrice,
    required this.totalProduct,
    this.v,
  });

  @override
  List<Object?> get props => [id, user, product, totalPrice, totalProduct, v];
} 