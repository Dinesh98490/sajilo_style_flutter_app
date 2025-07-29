import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilo_style/features/cart/domain/use_case/cart_usecases.dart';
import 'package:sajilo_style/features/cart/data/repository/cart_repository.dart';
import 'package:sajilo_style/features/home/domain/entity/product_entity.dart';

class MockCartRepository extends Mock implements ICartRepository {}

void main() {
  group('AddToCartUseCase', () {
    late MockCartRepository mockCartRepository;
    late AddToCartUseCase usecase;
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

    setUp(() {
      mockCartRepository = MockCartRepository();
      usecase = AddToCartUseCase(mockCartRepository);
    });

    test('calls repository.addToCart with correct arguments', () async {
      when(() => mockCartRepository.addToCart(product, quantity: 2)).thenAnswer((_) async {});
      await usecase(product, quantity: 2);
      verify(() => mockCartRepository.addToCart(product, quantity: 2)).called(1);
    });

    test('throws if repository.addToCart throws', () async {
      when(() => mockCartRepository.addToCart(product, quantity: 1)).thenThrow(Exception('fail'));
      expect(() => usecase(product), throwsException);
    });
  });
} 