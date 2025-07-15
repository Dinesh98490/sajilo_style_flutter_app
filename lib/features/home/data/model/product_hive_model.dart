// import 'package:equatable/equatable.dart';
// import 'package:hive/hive.dart';
// import 'package:sajilo_style/features/home/domain/entity/product_entity.dart'; // Adjust the import path as needed

// // The 'part' directive for the Hive generator.
// part 'product_hive_model.g.dart';

// @HiveType(typeId: 1) // Important: typeId must be unique for each HiveObject
// class ProductHiveModel extends Equatable {
//   @HiveField(0)
//   final String? productId;

//   @HiveField(1)
//   final String categoryId;

//   @HiveField(2)
//   final String categoryTitle;

//   @HiveField(3)
//   final String title;

//   @HiveField(4)
//   final String desc;

//   @HiveField(5)
//   final String price;

//   @HiveField(6)
//   final String image;

//   @HiveField(7)
//   final String color;

//   @HiveField(8)
//   final String size;

//   @HiveField(9)
//   final String quantity;

//   const ProductHiveModel({
//     this.productId,
//     required this.categoryId,
//     required this.categoryTitle,
//     required this.title,
//     required this.desc,
//     required this.price,
//     required this.image,
//     required this.color,
//     required this.size,
//     required this.quantity,
//   });

//   // Convert Hive Model to a clean Domain Entity
//   ProductEntity toEntity() {
//     return ProductEntity(
//       productId: productId,
//       categoryId: categoryId,
//       categoryTitle: categoryTitle,
//       title: title,
//       desc: desc,
//       price: price,
//       image: image,
//       color: color,
//       size: size,
//       quatity: quantity,
//     );
//   }

//   // Create a Hive Model from a clean Domain Entity
//   factory ProductHiveModel.fromEntity(ProductEntity entity) {
//     return ProductHiveModel(
//       productId: entity.productId,
//       categoryId: entity.categoryId,
//       categoryTitle: entity.categoryTitle,
//       title: entity.title,
//       desc: entity.desc,
//       price: entity.price,
//       image: entity.image,
//       color: entity.color,
//       size: entity.size,
//       quantity: entity.quatity,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         productId,
//         categoryId,
//         categoryTitle,
//         title,
//         desc,
//         price,
//         image,
//         color,
//         size,
//         quantity,
//       ];
// }