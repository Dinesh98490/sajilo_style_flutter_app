import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:sajilo_style/features/home/data/model/product_api_model.dart';
import 'package:sajilo_style/features/auth/data/model/user_api_model.dart';
import 'package:sajilo_style/features/home/domain/entity/order_entity.dart';
import 'package:sajilo_style/features/home/domain/entity/product_entity.dart';
import 'package:sajilo_style/features/auth/domain/entity/user_entity.dart';

part 'order_api_model.g.dart';

@JsonSerializable()
class PaymentApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  final double price;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;
  @JsonKey(name: '__v')
  final int? v;

  const PaymentApiModel({
    this.id,
    this.userId,
    required this.paymentMethod,
    required this.price,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    this.v,
  });

  factory PaymentApiModel.fromJson(Map<String, dynamic> json) => _$PaymentApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentApiModelToJson(this);

  PaymentEntity toEntity() => PaymentEntity(
    id: id ?? '',
    userId: userId ?? '',
    paymentMethod: paymentMethod,
    price: price,
    date: date,
    createdAt: createdAt,
    updatedAt: updatedAt,
    v: v ?? 0,
  );

  factory PaymentApiModel.fromEntity(PaymentEntity entity) => PaymentApiModel(
    id: entity.id,
    userId: entity.userId,
    paymentMethod: entity.paymentMethod,
    price: entity.price,
    date: entity.date,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
    v: entity.v,
  );

  @override
  List<Object?> get props => [id, userId, paymentMethod, price, date, createdAt, updatedAt, v];
}

@JsonSerializable()
class OrderApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'product_id')
  final ProductApiModel? product;
  @JsonKey(name: 'user_id')
  final UserApiModel? user;
  @JsonKey(name: 'payment_id')
  final PaymentApiModel? payment;
  final String address;
  final double price;
  final int quantity;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  @JsonKey(name: '__v')
  final int? v;

  const OrderApiModel({
    this.id,
    this.product,
    this.user,
    this.payment,
    required this.address,
    required this.price,
    required this.quantity,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.v,
  });

  factory OrderApiModel.fromJson(Map<String, dynamic> json) => _$OrderApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderApiModelToJson(this);

  OrderEntity toEntity() => OrderEntity(
    id: id ?? '',
    product: product?.toEntity() ?? ProductEntity(
      id: '',
      title: '',
      desc: '',
      price: 0,
      image: '',
      color: '',
      size: '',
      quantity: 0,
      category: const CategoryEntity(id: '', title: '', desc: ''),
    ),
    user: user?.toEntity() ?? UserEntity(
      userId: '',
      fullName: '',
      email: '',
      phone_number: '',
      password: '',
      role: '',
    ),
    payment: payment?.toEntity() ?? PaymentEntity(
      id: '',
      userId: '',
      paymentMethod: '',
      price: 0,
      date: DateTime.fromMillisecondsSinceEpoch(0),
      createdAt: DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
      v: 0,
    ),
    address: address,
    price: price,
    quantity: quantity,
    status: status,
    createdAt: createdAt,
    updatedAt: updatedAt,
    v: v ?? 0,
  );

  factory OrderApiModel.fromEntity(OrderEntity entity) => OrderApiModel(
    id: entity.id,
    product: ProductApiModel.fromEntity(entity.product),
    user: UserApiModel.fromEntity(entity.user),
    payment: PaymentApiModel.fromEntity(entity.payment),
    address: entity.address,
    price: entity.price,
    quantity: entity.quantity,
    status: entity.status,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
    v: entity.v,
  );

  @override
  List<Object?> get props => [id, product, user, payment, address, price, quantity, status, createdAt, updatedAt, v];
} 