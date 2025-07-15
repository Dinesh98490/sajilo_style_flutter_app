import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String id;
  final String title;
  final String desc;
  final double price;
  final String image;
  final String color;
  final String size;
  final int quantity;
  final CategoryEntity category;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.desc,
    required this.price,
    required this.image,
    required this.color,
    required this.size,
    required this.quantity,
    required this.category,
  });

  @override
  List<Object?> get props => [id, title, desc, price, image, color, size, quantity, category];
}

class CategoryEntity extends Equatable {
  final String id;
  final String title;
  final String desc;

  const CategoryEntity({
    required this.id,
    required this.title,
    required this.desc,
  });

  @override
  List<Object?> get props => [id, title, desc];
}
