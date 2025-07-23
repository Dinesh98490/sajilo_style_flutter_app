import 'package:sajilo_style/features/home/data/data_source/remote_datasource/payment_order_remote_datasource.dart';

abstract interface class IPaymentOrderRepository {
  Future<Map<String, dynamic>> createPaymentAndOrder({
    // required String userId,
    required String paymentMethod,
    required double price,
    required String address,
    required String productId,
    required int quantity,
  });
}

class PaymentOrderRepository implements IPaymentOrderRepository {
  final PaymentOrderRemoteDataSource _remoteDataSource;
  PaymentOrderRepository(this._remoteDataSource);

  @override
  Future<Map<String, dynamic>> createPaymentAndOrder({
    // required String userId,
    required String paymentMethod,
    required double price,
    required String address,
    required String productId,
    required int quantity,
  }) {
    return _remoteDataSource.createPaymentAndOrder(
      // userId: userId,
      paymentMethod: paymentMethod,
      price: price,
      address: address,
      productId: productId,
      quantity: quantity,
    );
  }
} 