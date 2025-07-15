import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:sajilo_style/features/home/data/model/category_api_model.dart';
import 'package:sajilo_style/features/home/domain/entity/product_entity.dart';

part 'product_api_model.g.dart';

@JsonSerializable()
class ProductApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String title;
  final String desc;
  final double price;
  final String image;
  final String color;
  final String size;
  final int quantity;

  @JsonKey(name: 'categoryId')
  final CategoryApiModel category;

  const ProductApiModel({
    this.id,
    required this.title,
    required this.desc,
    required this.price,
    required this.image,
    required this.color,
    required this.size,
    required this.quantity,
    required this.category,
  });

  factory ProductApiModel.fromJson(Map<String, dynamic> json) =>
      _$ProductApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductApiModelToJson(this);

  // To Entity
  ProductEntity toEntity() {
    return ProductEntity(
      id: id ?? '',
      title: title,
      desc: desc,
      price: price,
      image: image,
      color: color,
      size: size,
      quantity: quantity,
      category: category.toEntity(),
    );
  }

  // From Entity
  factory ProductApiModel.fromEntity(ProductEntity entity) {
    return ProductApiModel(
      id: entity.id,
      title: entity.title,
      desc: entity.desc,
      price: entity.price,
      image: entity.image,
      color: entity.color,
      size: entity.size,
      quantity: entity.quantity,
      category: CategoryApiModel.fromEntity(entity.category),
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        desc,
        price,
        image,
        color,
        size,
        quantity,
        category,
      ];
}
