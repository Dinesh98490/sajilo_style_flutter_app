import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilo_style/features/cart/presentation/cart_view_model/cart_bloc.dart';
import 'package:sajilo_style/features/cart/domain/entity/cart_entity.dart';
import 'package:sajilo_style/features/home/domain/entity/product_entity.dart';
import 'package:sajilo_style/features/auth/domain/entity/user_entity.dart';
import 'package:sajilo_style/features/cart/domain/use_case/cart_usecases.dart';

class MockGetCartItemsUseCase extends Mock implements GetCartItemsUseCase {}
class MockAddToCartUseCase extends Mock implements AddToCartUseCase {}
class MockRemoveFromCartUseCase extends Mock implements RemoveFromCartUseCase {}
class MockUpdateCartQuantityUseCase extends Mock implements UpdateCartQuantityUseCase {}

class FakeProductEntity extends Fake implements ProductEntity {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeProductEntity());
  });
  late CartBloc cartBloc;
  late MockGetCartItemsUseCase mockGetCartItems;
  late MockAddToCartUseCase mockAddToCart;
  late MockRemoveFromCartUseCase mockRemoveFromCart;
  late MockUpdateCartQuantityUseCase mockUpdateCartQuantity;

  final testProduct = ProductEntity(
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
  final testUser = UserEntity(
    userId: 'u1',
    fullName: 'Test User',
    email: 'test@example.com',
    phone_number: '1234567890',
    password: 'pass',
    role: 'customer',
  );
  final testCart = CartEntity(
    id: 'cart1',
    user: null,
    product: testProduct,
    totalPrice: 10.0,
    totalProduct: 1,
    v: 0,
  );

  setUp(() {
    mockGetCartItems = MockGetCartItemsUseCase();
    mockAddToCart = MockAddToCartUseCase();
    mockRemoveFromCart = MockRemoveFromCartUseCase();
    mockUpdateCartQuantity = MockUpdateCartQuantityUseCase();
    cartBloc = CartBloc(
      getCartItems: mockGetCartItems,
      addToCart: mockAddToCart,
      removeFromCart: mockRemoveFromCart,
      updateCartQuantity: mockUpdateCartQuantity,
    );
  });

  test('initial state is CartInitial', () {
    expect(cartBloc.state, CartInitial());
  });

  test('emits [CartLoading, CartLoaded] when LoadCartEvent is added', () async {
    when(() => mockGetCartItems()).thenAnswer((_) async => [testCart]);
    cartBloc.add(LoadCartEvent());
    await expectLater(
      cartBloc.stream,
      emitsInOrder([
        isA<CartLoading>(),
        isA<CartLoaded>().having((s) => s.items, 'items', [testCart]),
      ]),
    );
  });

  test('emits [CartError] when LoadCartEvent throws', () async {
    when(() => mockGetCartItems()).thenThrow(Exception('fail'));
    cartBloc.add(LoadCartEvent());
    await expectLater(
      cartBloc.stream,
      emitsInOrder([
        isA<CartLoading>(),
        isA<CartError>(),
      ]),
    );
  });

  test('calls addToCart and reloads cart on AddToCartEvent', () async {
    when(() => mockAddToCart(any(), quantity: any(named: 'quantity'))).thenAnswer((_) async {});
    when(() => mockGetCartItems()).thenAnswer((_) async => [testCart]);
    cartBloc.add(AddToCartEvent(testProduct));
    await expectLater(
      cartBloc.stream,
      emitsThrough(isA<CartLoaded>()),
    );
    verify(() => mockAddToCart(testProduct, quantity: 1)).called(1);
  });

  test('calls removeFromCart and reloads cart on RemoveFromCartEvent', () async {
    when(() => mockRemoveFromCart(any())).thenAnswer((_) async {});
    when(() => mockGetCartItems()).thenAnswer((_) async => []);
    cartBloc.add(RemoveFromCartEvent('1'));
    await expectLater(
      cartBloc.stream,
      emitsThrough(isA<CartLoaded>()),
    );
    verify(() => mockRemoveFromCart('1')).called(1);
  });

  test('calls updateCartQuantity and reloads cart on UpdateCartQuantityEvent', () async {
    when(() => mockUpdateCartQuantity(any(), any())).thenAnswer((_) async {});
    when(() => mockGetCartItems()).thenAnswer((_) async => [testCart]);
    cartBloc.add(UpdateCartQuantityEvent('1', 2));
    await expectLater(
      cartBloc.stream,
      emitsThrough(isA<CartLoaded>()),
    );
    verify(() => mockUpdateCartQuantity('1', 2)).called(1);
  });
} 