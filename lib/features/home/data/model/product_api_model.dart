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
  final CategoryApiModel? category;

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

  factory ProductApiModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return ProductApiModel(
        id: json['_id'] as String?,
        title: json['title'] as String? ?? '',
        desc: json['desc'] as String? ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0,
        image: json['image'] as String? ?? '',
        color: json['color'] as String? ?? '',
        size: json['size'] as String? ?? '',
        quantity: (json['quantity'] as num?)?.toInt() ?? 0,
        category: (json['categoryId'] is Map<String, dynamic>)
            ? CategoryApiModel.fromJson(json['categoryId'] as Map<String, dynamic>)
            : null,
      );
    } else {
      print('ProductApiModel.fromJson: expected Map, got ${json.runtimeType}');
      return ProductApiModel(
        id: '',
        title: '',
        desc: '',
        price: 0,
        image: '',
        color: '',
        size: '',
        quantity: 0,
        category: null,
      );
    }
  }

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
      category: category?.toEntity() ?? const CategoryEntity(id: '', title: '', desc: ''),
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
