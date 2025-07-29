import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sajilo_style/features/cart/domain/entity/cart_entity.dart';
import 'package:sajilo_style/features/home/domain/entity/product_entity.dart';
import 'package:sajilo_style/features/cart/domain/use_case/cart_usecases.dart';

// Events
abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class LoadCartEvent extends CartEvent {}
class AddToCartEvent extends CartEvent {
  final ProductEntity product;
  final int quantity;
  const AddToCartEvent(this.product, {this.quantity = 1});
  @override
  List<Object?> get props => [product, quantity];
}
class RemoveFromCartEvent extends CartEvent {
  final String productId;
  const RemoveFromCartEvent(this.productId);
  @override
  List<Object?> get props => [productId];
}
class UpdateCartQuantityEvent extends CartEvent {
  final String productId;
  final int quantity;
  const UpdateCartQuantityEvent(this.productId, this.quantity);
  @override
  List<Object?> get props => [productId, quantity];
}

// States
abstract class CartState extends Equatable {
  const CartState();
  @override
  List<Object?> get props => [];
}
class CartInitial extends CartState {}
class CartLoading extends CartState {}
class CartLoaded extends CartState {
  final List<CartEntity> items;
  const CartLoaded(this.items);
  @override
  List<Object?> get props => [items];
}
class CartError extends CartState {
  final String message;
  const CartError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItemsUseCase getCartItems;
  final AddToCartUseCase addToCart;
  final RemoveFromCartUseCase removeFromCart;
  final UpdateCartQuantityUseCase updateCartQuantity;

  CartBloc({
    required this.getCartItems,
    required this.addToCart,
    required this.removeFromCart,
    required this.updateCartQuantity,
  }) : super(CartInitial()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateCartQuantityEvent>(_onUpdateCartQuantity);
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = await getCartItems();
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    try {
      await addToCart(event.product, quantity: event.quantity);
      add(LoadCartEvent());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) async {
    try {
      await removeFromCart(event.productId);
      add(LoadCartEvent());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onUpdateCartQuantity(UpdateCartQuantityEvent event, Emitter<CartState> emit) async {
    try {
      await updateCartQuantity(event.productId, event.quantity);
      add(LoadCartEvent());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
} 