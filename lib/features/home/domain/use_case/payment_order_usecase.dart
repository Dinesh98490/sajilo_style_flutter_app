import 'package:sajilo_style/features/home/data/repository/payment_order_repository.dart';

class CreatePaymentAndOrderUseCase {
  final IPaymentOrderRepository repository;
  CreatePaymentAndOrderUseCase(this.repository);

  Future<Map<String, dynamic>> call({
    // required String userId,
    required String paymentMethod,
    required double price,
    required String address,
    required String productId,
    required int quantity,
  }) {
    return repository.createPaymentAndOrder(
      // userId: userId,
      paymentMethod: paymentMethod,
      price: price,
      address: address,
      productId: productId,
      quantity: quantity,
    );
  }
} 