import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_style/features/home/presentation/product_view_model/cart_bloc.dart';
import 'package:sajilo_style/app/service_locator/service_locator.dart';
import 'package:sajilo_style/features/home/domain/entity/cart_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartBloc>(
      create: (_) => serviceLocator<CartBloc>()..add(LoadCartEvent()),
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return Scaffold(
              appBar: AppBar(title: const Text('My Cart'), backgroundColor: Colors.orange, elevation: 1),
              body: const Center(child: CircularProgressIndicator()),
            );
          } else if (state is CartError) {
            return Scaffold(
              appBar: AppBar(title: const Text('My Cart'), backgroundColor: Colors.orange, elevation: 1),
              body: Center(child: Text(state.message, style: const TextStyle(color: Colors.red))),
            );
          } else if (state is CartLoaded) {
            final cartItems = state.items;
            double subtotal = cartItems.fold(0, (sum, item) => sum + (item.totalPrice as num).toDouble());
            double delivery = 100;
            double total = subtotal + delivery;
            return Scaffold(
              appBar: AppBar(title: const Text('My Cart'), backgroundColor: Colors.orange, elevation: 1),
              backgroundColor: Colors.grey[100],
              body: Column(
                children: [
                  Expanded(
                    child: cartItems.isEmpty
                        ? const Center(child: Text('Your cart is empty'))
                        : ListView.separated(
                            padding: const EdgeInsets.all(20),
                            itemCount: cartItems.length,
                            separatorBuilder: (context, i) => const SizedBox(height: 16),
                            itemBuilder: (context, i) => CartCard(
                              title: cartItems[i].product?.title ?? '',
                              price: (cartItems[i].totalPrice as num).toDouble(),
                              image: cartItems[i].product?.image ?? '',
                              color: cartItems[i].product?.color ?? '',
                              size: cartItems[i].product?.size ?? '',
                              quantity: cartItems[i].totalProduct,
                              onRemove: () {
                                context.read<CartBloc>().add(RemoveFromCartEvent(cartItems[i].product?.id ?? ''));
                              },
                              onIncrease: () {
                                context.read<CartBloc>().add(UpdateCartQuantityEvent(cartItems[i].product?.id ?? '', cartItems[i].totalProduct + 1));
                              },
                              onDecrease: () {
                                if (cartItems[i].totalProduct > 1) {
                                  context.read<CartBloc>().add(UpdateCartQuantityEvent(cartItems[i].product?.id ?? '', cartItems[i].totalProduct - 1));
                                }
                              },
                            ),
                          ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 16,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Subtotal', style: TextStyle(fontWeight: FontWeight.w500)),
                              Text('Rs. ${subtotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Delivery', style: TextStyle(fontWeight: FontWeight.w500)),
                              Text('Rs. ${delivery.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const Divider(height: 24, thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              Text('Rs. ${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.deepOrange)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 2,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Proceeding to checkout!')),
                                );
                              },
                              child: const Text('Checkout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          // Initial state
          return Scaffold(
            appBar: AppBar(title: const Text('My Cart'), backgroundColor: Colors.orange, elevation: 1),
            body: const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}

class CartCard extends StatelessWidget {
  final String title;
  final double price;
  final String image;
  final String color;
  final String size;
  final int quantity;
  final VoidCallback onRemove;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const CartCard({
    super.key,
    required this.title,
    required this.price,
    required this.image,
    required this.color,
    required this.size,
    required this.quantity,
    required this.onRemove,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: "http://10.0.2.2:5050/${image}",
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.orange.shade50,
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.broken_image, size: 40, color: Colors.orange),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('Color: $color', style: const TextStyle(fontSize: 12)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('Size: $size', style: const TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Rs. ${price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 70),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.orange, size: 18),
                        onPressed: onDecrease,
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                      Text('$quantity', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, color: Colors.orange, size: 18),
                        onPressed: onIncrease,
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                    onPressed: onRemove,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 