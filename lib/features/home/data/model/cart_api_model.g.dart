// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartApiModel _$CartApiModelFromJson(Map<String, dynamic> json) => CartApiModel(
      id: json['_id'] as String?,
      user: json['user_id'] == null
          ? null
          : UserApiModel.fromJson(json['user_id']),
      product: json['product_id'] == null
          ? null
          : ProductApiModel.fromJson(json['product_id']),
      totalPrice: json['total_price'] as num,
      totalProduct: (json['total_product'] as num).toInt(),
      v: (json['__v'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CartApiModelToJson(CartApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'user_id': instance.user,
      'product_id': instance.product,
      'total_price': instance.totalPrice,
      'total_product': instance.totalProduct,
      '__v': instance.v,
    };
