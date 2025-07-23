import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entity/product_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_style/features/home/presentation/product_view_model/cart_bloc.dart';
import 'package:sajilo_style/app/service_locator/service_locator.dart';
import 'package:sajilo_style/features/home/presentation/product_view_model/payment_order_bloc.dart';

class ProductDetailView extends StatelessWidget {
  final ProductEntity product;
  const ProductDetailView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartBloc>(
          create: (_) => serviceLocator<CartBloc>(),
        ),
        BlocProvider<PaymentOrderBloc>(
          create: (_) => serviceLocator<PaymentOrderBloc>(),
        ),
      ],
      child: BlocListener<PaymentOrderBloc, PaymentOrderState>(
        listener: (context, state) {
          if (state is PaymentOrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          } else if (state is PaymentOrderSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order placed successfully!')),
            );
          }
        },
        child: BlocListener<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            } else if (state is CartLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to cart!')),
              );
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.orange,
                      expandedHeight: 320,
                      pinned: true,
                      elevation: 0,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Hero(
                          tag: product.id,
                          child: Container(
                            color: Colors.orange.shade50,
                            child: CachedNetworkImage(
                              imageUrl: "http://10.0.2.2:5050/${product.image}",
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 320,
                              placeholder: (context, url) => Container(
                                color: Colors.orange.shade50,
                                child: const Center(child: CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.orange.shade50,
                                child: const Icon(Icons.broken_image, size: 80, color: Colors.orange),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    product.title,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrange.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Rs. ${product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.deepOrange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.category, color: Colors.orange.shade400, size: 20),
                                const SizedBox(width: 6),
                                Text(
                                  product.category.title,
                                  style: const TextStyle(fontSize: 15, color: Colors.orange, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.local_shipping, color: Colors.green, size: 16),
                                      SizedBox(width: 4),
                                      Text('Free Delivery', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                _InfoChip(label: 'Color', value: product.color),
                                const SizedBox(width: 10),
                                _InfoChip(label: 'Size', value: product.size),
                                const SizedBox(width: 10),
                                _InfoChip(label: 'Qty', value: product.quantity.toString()),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                _StarRating(rating: 4.5),
                                const SizedBox(width: 8),
                                const Text('4.5 (234 reviews)', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54)),
                              ],
                            ),
                            const SizedBox(height: 28),
                            const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                product.desc,
                                style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
                              ),
                            ),
                            const SizedBox(height: 32),
                            const Divider(height: 32, thickness: 1),
                            const Text('Customer Reviews', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 12),
                            _ReviewTile(
                              name: 'Aayush Sharma',
                              rating: 5,
                              review: 'Great quality! Fast delivery and the product is exactly as described.',
                            ),
                            _ReviewTile(
                              name: 'Sneha Karki',
                              rating: 4,
                              review: 'Very comfortable and stylish. Will buy again!',
                            ),
                            _ReviewTile(
                              name: 'Ramesh Thapa',
                              rating: 5,
                              review: 'Excellent value for money. Highly recommended.',
                            ),
                            const SizedBox(height: 32),
                            const Divider(height: 32, thickness: 1),
                            const Text('You may also like', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 140,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                separatorBuilder: (context, i) => const SizedBox(width: 16),
                                itemBuilder: (context, i) => _DummyProductCard(),
                              ),
                            ),
                            const SizedBox(height: 100), // For button space
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
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
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 2,
                              ),
                              onPressed: () {
                                context.read<CartBloc>().add(AddToCartEvent(product));
                              },
                              child: const Text('Add to Cart', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 2,
                              ),
                              onPressed: () {
                                // Dummy values for userId, address, paymentMethod
                                context.read<PaymentOrderBloc>().add(
                                  CreatePaymentAndOrderEvent(
                                  
                                    paymentMethod: 'COD',
                                    price: product.price,
                                    address: 'Kathmandu, Nepal',
                                    productId: product.id,
                                    quantity: 1,
                                  ),
                                );
                              },
                              child: const Text('Buy Now', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.orange),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.orange)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87)),
        ],
      ),
    );
  }
}

class _StarRating extends StatelessWidget {
  final double rating;
  final int maxStars;
  const _StarRating({required this.rating, this.maxStars = 5});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(maxStars, (index) {
        final isFull = rating >= index + 1;
        final isHalf = !isFull && rating > index && rating < index + 1;
        return Icon(
          isFull
              ? Icons.star
              : isHalf
                  ? Icons.star_half
                  : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final String name;
  final int rating;
  final String review;
  const _ReviewTile({required this.name, required this.rating, required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.orange.shade200,
            child: Text(name.isNotEmpty ? name[0] : '', style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    _StarRating(rating: rating.toDouble()),
                  ],
                ),
                const SizedBox(height: 4),
                Text(review, style: const TextStyle(color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DummyProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              'assets/images/category.png',
              width: 110,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Sneaker X', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                SizedBox(height: 2),
                Text('Rs. 2999', style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w600, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 