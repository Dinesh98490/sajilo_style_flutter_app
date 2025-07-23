import 'package:sajilo_style/features/home/domain/entity/cart_entity.dart';
import 'package:sajilo_style/features/home/domain/entity/product_entity.dart';

abstract interface class ICartDataSource {
  Future<List<CartEntity>> getCartItems();
  Future<void> addToCart(ProductEntity product, {int quantity = 1});
  Future<void> removeFromCart(String productId);
  Future<void> updateQuantity(String productId, int quantity);
} 