import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_style/features/cart/domain/entity/cart_entity.dart';
import 'package:sajilo_style/features/home/domain/entity/product_entity.dart';

void main() {
  group('CartEntity', () {
    final product = ProductEntity(
      id: '1',
      title: 'Test Product',
      desc: 'desc',
      price: 10.0,
      image: 'img.png',
      color: 'red',
      size: 'M',
      quantity: 1,
      category: const CategoryEntity(id: 'c1', title: 'cat', desc: 'catdesc'),
    );
    final cart1 = CartEntity(id: 'cart1', user: null, product: product, totalPrice: 10.0, totalProduct: 1, v: 0);
    final cart2 = CartEntity(id: 'cart1', user: null, product: product, totalPrice: 10.0, totalProduct: 1, v: 0);
    final cart3 = CartEntity(id: 'cart2', user: null, product: product, totalPrice: 20.0, totalProduct: 2, v: 0);

    test('supports equality', () {
      expect(cart1, equals(cart2));
      expect(cart1, isNot(equals(cart3)));
    });

    test('props returns correct values', () {
      expect(cart1.props, [cart1.id, cart1.user, cart1.product, cart1.totalPrice, cart1.totalProduct, cart1.v]);
    });

    test('can be constructed', () {
      expect(cart1, isA<CartEntity>());
    });
  });
} 