import 'package:equatable/equatable.dart';
import 'package:sajilo_style/features/home/domain/entity/product_entity.dart';
import 'package:sajilo_style/features/auth/domain/entity/user_entity.dart';

class PaymentEntity extends Equatable {
  final String id;
  final String userId;
  final String paymentMethod;
  final double price;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  const PaymentEntity({
    required this.id,
    required this.userId,
    required this.paymentMethod,
    required this.price,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  @override
  List<Object?> get props => [id, userId, paymentMethod, price, date, createdAt, updatedAt, v];
}

class OrderEntity extends Equatable {
  final String id;
  final ProductEntity product;
  final UserEntity user;
  final PaymentEntity payment;
  final String address;
  final double price;
  final int quantity;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  const OrderEntity({
    required this.id,
    required this.product,
    required this.user,
    required this.payment,
    required this.address,
    required this.price,
    required this.quantity,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  @override
  List<Object?> get props => [id, product, user, payment, address, price, quantity, status, createdAt, updatedAt, v];
} 