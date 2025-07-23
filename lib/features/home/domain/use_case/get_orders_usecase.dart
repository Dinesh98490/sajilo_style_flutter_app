import 'package:sajilo_style/features/home/domain/entity/order_entity.dart';
import 'package:sajilo_style/features/home/data/repository/order_repository.dart';

class GetOrdersUseCase {
  final IOrderRepository repository;
  GetOrdersUseCase(this.repository);

  Future<List<OrderEntity>> call() {
    return repository.getOrders();
  }
} 