import 'package:json_annotation/json_annotation.dart';
import 'package:sajilo_style/features/auth/data/model/user_api_model.dart';
import 'package:sajilo_style/features/home/data/model/product_api_model.dart';
import 'package:sajilo_style/features/home/domain/entity/cart_entity.dart';
import 'package:equatable/equatable.dart';

part 'cart_api_model.g.dart';

@JsonSerializable()
class CartApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'user_id')
  final UserApiModel? user;
  @JsonKey(name: 'product_id')
  final ProductApiModel? product;
  @JsonKey(name: 'total_price')
  final num totalPrice;
  @JsonKey(name: 'total_product')
  final int totalProduct;
  @JsonKey(name: '__v')
  final int? v;

  CartApiModel({
    this.id,
    this.user,
    this.product,
    required this.totalPrice,
    required this.totalProduct,
    this.v,
  });

  factory CartApiModel.fromJson(Map<String, dynamic> json) => CartApiModel(
    id: json['_id'] as String?,
    user: (json['user_id'] is Map<String, dynamic>)
        ? UserApiModel.fromJson(json['user_id'] as Map<String, dynamic>)
        : null,
    product: (json['product_id'] is Map<String, dynamic>)
        ? ProductApiModel.fromJson(json['product_id'] as Map<String, dynamic>)
        : null,
    totalPrice: json['total_price'] as num,
    totalProduct: (json['total_product'] as num).toInt(),
    v: (json['__v'] as num?)?.toInt(),
  );
  Map<String, dynamic> toJson() => _$CartApiModelToJson(this);

  CartEntity toEntity() => CartEntity(
    id: id,
    user: user?.toEntity(),
    product: product?.toEntity(),
    totalPrice: totalPrice,
    totalProduct: totalProduct,
    v: v,
  );

  factory CartApiModel.fromEntity(CartEntity entity) => CartApiModel(
    id: entity.id,
    user: entity.user != null ? UserApiModel.fromEntity(entity.user!) : null,
    product: entity.product != null ? ProductApiModel.fromEntity(entity.product!) : null,
    totalPrice: entity.totalPrice,
    totalProduct: entity.totalProduct,
    v: entity.v,
  );

  static List<CartEntity> toEntityList(List<CartApiModel> models) {
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  List<Object?> get props => [id, user, product, totalPrice, totalProduct, v];
} 