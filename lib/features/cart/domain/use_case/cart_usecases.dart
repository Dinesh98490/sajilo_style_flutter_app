import 'package:sajilo_style/features/cart/domain/entity/cart_entity.dart';
import 'package:sajilo_style/features/home/domain/entity/product_entity.dart';
import 'package:sajilo_style/features/cart/data/repository/cart_repository.dart';

class GetCartItemsUseCase {
  final ICartRepository repository;
  GetCartItemsUseCase(this.repository);
  Future<List<CartEntity>> call() => repository.getCartItems();
}

class AddToCartUseCase {
  final ICartRepository repository;
  AddToCartUseCase(this.repository);
  Future<void> call(ProductEntity product, {int quantity = 1}) => repository.addToCart(product, quantity: quantity);
}

class RemoveFromCartUseCase {
  final ICartRepository repository;
  RemoveFromCartUseCase(this.repository);
  Future<void> call(String productId) => repository.removeFromCart(productId);
}

class UpdateCartQuantityUseCase {
  final ICartRepository repository;
  UpdateCartQuantityUseCase(this.repository);
  Future<void> call(String productId, int quantity) => repository.updateQuantity(productId, quantity);
} 