// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductApiModel _$ProductApiModelFromJson(Map<String, dynamic> json) =>
    ProductApiModel(
      id: json['_id'] as String?,
      title: json['title'] as String,
      desc: json['desc'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      color: json['color'] as String,
      size: json['size'] as String,
      quantity: (json['quantity'] as num).toInt(),
      category: json['categoryId'] == null
          ? null
          : CategoryApiModel.fromJson(
              json['categoryId'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductApiModelToJson(ProductApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'desc': instance.desc,
      'price': instance.price,
      'image': instance.image,
      'color': instance.color,
      'size': instance.size,
      'quantity': instance.quantity,
      'categoryId': instance.category,
    };
