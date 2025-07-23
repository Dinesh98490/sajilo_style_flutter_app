import 'package:sajilo_style/features/home/domain/entity/cart_entity.dart';
import 'package:sajilo_style/features/home/domain/entity/product_entity.dart';
import 'package:sajilo_style/features/home/data/data_source/cart_data_source.dart';

abstract interface class ICartRepository {
  Future<List<CartEntity>> getCartItems();
  Future<void> addToCart(ProductEntity product, {int quantity = 1});
  Future<void> removeFromCart(String productId);
  Future<void> updateQuantity(String productId, int quantity);
}

class CartRepository implements ICartRepository {
  final ICartDataSource _cartDataSource;
  CartRepository(this._cartDataSource);

  @override
  Future<List<CartEntity>> getCartItems() => _cartDataSource.getCartItems();

  @override
  Future<void> addToCart(ProductEntity product, {int quantity = 1}) => _cartDataSource.addToCart(product, quantity: quantity);

  @override
  Future<void> removeFromCart(String productId) => _cartDataSource.removeFromCart(productId);

  @override
  Future<void> updateQuantity(String productId, int quantity) => _cartDataSource.updateQuantity(productId, quantity);
} 