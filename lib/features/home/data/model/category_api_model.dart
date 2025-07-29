import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:sajilo_style/features/home/domain/entity/product_entity.dart';

part 'category_api_model.g.dart';

@JsonSerializable()
class CategoryApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String title;
  final String desc;

  const CategoryApiModel({
    this.id,
    required this.title,
    required this.desc,
  });

  factory CategoryApiModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryApiModelToJson(this);

  // To Entity
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id ?? '',
      title: title,
      desc: desc,
    );
  }

  // From Entity
  factory CategoryApiModel.fromEntity(CategoryEntity entity) {
    return CategoryApiModel(
      id: entity.id,
      title: entity.title,
      desc: entity.desc,
    );
  }

  @override
  List<Object?> get props => [id, title, desc];
}
