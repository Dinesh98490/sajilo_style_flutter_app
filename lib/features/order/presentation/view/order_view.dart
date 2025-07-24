import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_style/app/service_locator/service_locator.dart';
import 'package:sajilo_style/features/order/presentation/view_model/order_bloc.dart';
import 'package:sajilo_style/features/order/domain/entity/order_entity.dart';

class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderBloc>(
      create: (_) => serviceLocator<OrderBloc>()..add(FetchOrdersEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
          backgroundColor: Colors.orange,
          elevation: 1,
        ),
        backgroundColor: Colors.grey[100],
        body: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrderLoaded) {
              final orders = state.orders;
              if (orders.isEmpty) {
                return const Center(child: Text('No orders yet'));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: orders.length,
                separatorBuilder: (context, i) => const SizedBox(height: 16),
                itemBuilder: (context, i) {
                  final order = orders[i];
                  return OrderCard(order: order);
                },
              );
            } else if (state is OrderError) {
              return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Order #${order.id}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: order.status == 'Delivered' ? Colors.green.shade50 : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        order.status == 'Delivered' ? Icons.check_circle : Icons.local_shipping,
                        color: order.status == 'Delivered' ? Colors.green : Colors.orange,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(order.status, style: TextStyle(color: order.status == 'Delivered' ? Colors.green : Colors.orange, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Date: ${order.createdAt.toLocal().toString().split(' ')[0]}', style: const TextStyle(color: Colors.black54, fontSize: 13)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order.product.title, style: const TextStyle(fontSize: 14)),
                Text('Rs. ${order.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text('Rs. ${order.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.deepOrange)),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 