import 'package:sajilo_style/features/order/data/data_source/remote_datasource/order_remote_datasource.dart';
import 'package:sajilo_style/features/order/domain/entity/order_entity.dart';

abstract class IOrderRepository {
  Future<List<OrderEntity>> getOrders();
}

class OrderRepository implements IOrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  OrderRepository(this.remoteDataSource);

  @override
  Future<List<OrderEntity>> getOrders() async {
    final models = await remoteDataSource.getOrders();
    return models.map((m) => m.toEntity()).toList();
  }
} 