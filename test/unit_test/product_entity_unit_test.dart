import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_style/features/home/domain/entity/product_entity.dart';

void main() {
  group('ProductEntity', () {
    final category = CategoryEntity(id: 'c1', title: 'cat', desc: 'catdesc');
    final product1 = ProductEntity(
      id: '1',
      title: 'Test Product',
      desc: 'desc',
      price: 10.0,
      image: 'img.png',
      color: 'red',
      size: 'M',
      quantity: 1,
      category: category,
    );
    final product2 = ProductEntity(
      id: '1',
      title: 'Test Product',
      desc: 'desc',
      price: 10.0,
      image: 'img.png',
      color: 'red',
      size: 'M',
      quantity: 1,
      category: category,
    );
    final product3 = ProductEntity(
      id: '2',
      title: 'Other Product',
      desc: 'other',
      price: 20.0,
      image: 'img2.png',
      color: 'blue',
      size: 'L',
      quantity: 2,
      category: category,
    );

    test('supports equality', () {
      expect(product1, equals(product2));
      expect(product1, isNot(equals(product3)));
    });

    test('props returns correct values', () {
      expect(product1.props, [product1.id, product1.title, product1.desc, product1.price, product1.image, product1.color, product1.size, product1.quantity, product1.category]);
    });

    test('can be constructed', () {
      expect(product1, isA<ProductEntity>());
    });
  });
} 