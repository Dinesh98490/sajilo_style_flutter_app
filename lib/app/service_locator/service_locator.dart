import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sajilo_style/app/shared_pref/token_shared_prefs.dart';
import 'package:sajilo_style/core/network/api_service.dart';
import 'package:sajilo_style/core/network/hive_service.dart';
import 'package:sajilo_style/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:sajilo_style/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:sajilo_style/features/auth/data/repository/local_repository/user_local_repository.dart';
import 'package:sajilo_style/features/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:sajilo_style/features/auth/domain/use_case/user_get_current_usecase.dart';
import 'package:sajilo_style/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:sajilo_style/features/auth/domain/use_case/user_register_usercase.dart';
import 'package:sajilo_style/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:sajilo_style/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:sajilo_style/features/home/data/data_source/remote_datasource/product_remote_datasource.dart';
import 'package:sajilo_style/features/home/data/repository/remote_repository/product_remote_repository.dart';
import 'package:sajilo_style/features/home/domain/use_case/product_get_current_usecase.dart';
import 'package:sajilo_style/features/home/presentation/product_view_model/home_view_model.dart';
import 'package:sajilo_style/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:sajilo_style/features/profile/presentation/profile_view_model/profile_bloc.dart';
import 'package:sajilo_style/features/home/data/data_source/remote_datasource/cart_remote_datasource.dart';
import 'package:sajilo_style/features/home/data/repository/cart_repository.dart';
import 'package:sajilo_style/features/home/domain/use_case/cart_usecases.dart';
import 'package:sajilo_style/features/home/presentation/product_view_model/cart_bloc.dart';
import 'package:sajilo_style/features/home/data/data_source/remote_datasource/payment_order_remote_datasource.dart';
import 'package:sajilo_style/features/home/data/repository/payment_order_repository.dart';
import 'package:sajilo_style/features/home/domain/use_case/payment_order_usecase.dart';
import 'package:sajilo_style/features/home/presentation/product_view_model/payment_order_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sajilo_style/features/home/data/data_source/remote_datasource/order_remote_datasource.dart';
import 'package:sajilo_style/features/home/data/repository/order_repository.dart';
import 'package:sajilo_style/features/home/domain/use_case/get_orders_usecase.dart';
import 'package:sajilo_style/features/home/presentation/product_view_model/order_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initApiService();
  await _initHiveService();
  await _initSharedPrefs();
  await _initAuthModule();
  await _initHomeModule();
  await _initSplashModule();
  await _initProfileModule();
  await _initCartModule();
  await _initPaymentOrderModule();
  await _initOrderModule();
}

Future<void> _initApiService() async {
  serviceLocator.registerLazySingleton(() => ApiService(Dio()));
}

Future<void> _initHiveService() async {
  // Initialize and register HiveService
  serviceLocator.registerLazySingleton(() => HiveService());
}

Future<void> _initSharedPrefs() async {
  // Initialize Shared Preferences if needed
  final sharedPrefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPrefs);
  serviceLocator.registerLazySingleton(
    () => TokenSharedPrefs(
      sharedPreferences: serviceLocator<SharedPreferences>(),
    ),
  );
}

// ---------------------- Auth Module ----------------------

 Future<void> _initAuthModule() async {
  // Data Source
  serviceLocator.registerFactory(
    () => UserLocalDatasource(hiveService: serviceLocator<HiveService>()),
  );

  serviceLocator.registerFactory(
    () => UserRemoteDatasource(apiService: serviceLocator<ApiService>(), tokenSharedPrefs: serviceLocator<TokenSharedPrefs>()),
  );


    // Repository

  serviceLocator.registerFactory(
    () => UserLocalRepository(
      userLocalDatasource: serviceLocator<UserLocalDatasource>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserRemoteRepository(
      userRemoteDatasource: serviceLocator<UserRemoteDatasource>(),
    ),
  );



  // Usecases
  serviceLocator.registerFactory(
    () => UserLoginUsecase(
      userRepository: serviceLocator<UserRemoteRepository>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserRegisterUsercase(
      userRepository: serviceLocator<UserRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserGetCurrentUsecase(userRepository: serviceLocator<UserRemoteRepository>()),
  );

    serviceLocator.registerFactory(
    () => RegisterViewModel(
     
      serviceLocator<UserRegisterUsercase>(),

    ),
  );

   serviceLocator.registerFactory(
    () => LoginViewModel(serviceLocator<UserLoginUsecase>()),
  );
}





 


Future<void> _initHomeModule() async {
  serviceLocator.registerFactory(
    () => ProductRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );
  serviceLocator.registerFactory(
    () => ProductRemoteRepository(productRemoteDatasource: serviceLocator<ProductRemoteDatasource>()),
  );
  serviceLocator.registerFactory(
    () => ProductGetCurrentUsecase(productRepository: serviceLocator<ProductRemoteRepository>()),
  );
  serviceLocator.registerFactory(
    () => HomeViewModel(loginViewModel: serviceLocator<LoginViewModel>()),
  );
}


// ---------------------- Splash Module ----------------------

Future<void> _initSplashModule()  async {
  // Register SplashViewModel
  serviceLocator.registerFactory(() => SplashViewModel());
}

Future<void> _initProfileModule() async {
  serviceLocator.registerFactory(
    () => ProfileBloc(getCurrentUser: serviceLocator<UserGetCurrentUsecase>()),
  );
}

Future<void> _initCartModule() async {
  serviceLocator.registerFactory(
    () => CartRemoteDataSource(apiService: serviceLocator<ApiService>(), tokenSharedPrefs: serviceLocator<TokenSharedPrefs>()),
  );
  serviceLocator.registerFactory<ICartRepository>(
    () => CartRepository(serviceLocator<CartRemoteDataSource>()),
  );
  serviceLocator.registerFactory(() => GetCartItemsUseCase(serviceLocator<ICartRepository>()));
  serviceLocator.registerFactory(() => AddToCartUseCase(serviceLocator<ICartRepository>()));
  serviceLocator.registerFactory(() => RemoveFromCartUseCase(serviceLocator<ICartRepository>()));
  serviceLocator.registerFactory(() => UpdateCartQuantityUseCase(serviceLocator<ICartRepository>()));
  serviceLocator.registerFactory(() => CartBloc(
    getCartItems: serviceLocator<GetCartItemsUseCase>(),
    addToCart: serviceLocator<AddToCartUseCase>(),
    removeFromCart: serviceLocator<RemoveFromCartUseCase>(),
    updateCartQuantity: serviceLocator<UpdateCartQuantityUseCase>(),
  ));
}

Future<void> _initPaymentOrderModule() async {
  serviceLocator.registerFactory(
    () => PaymentOrderRemoteDataSource(
      apiService: serviceLocator<ApiService>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );
  serviceLocator.registerFactory<IPaymentOrderRepository>(
    () => PaymentOrderRepository(serviceLocator<PaymentOrderRemoteDataSource>()),
  );
  serviceLocator.registerFactory(
    () => CreatePaymentAndOrderUseCase(serviceLocator<IPaymentOrderRepository>()),
  );
  serviceLocator.registerFactory(
    () => PaymentOrderBloc(
      createPaymentAndOrderUseCase: serviceLocator<CreatePaymentAndOrderUseCase>(),
    ),
  );
}

Future<void> _initOrderModule() async {
  serviceLocator.registerFactory(
    () => OrderRemoteDataSource(
      apiService: serviceLocator<ApiService>(),
      tokenSharedPrefs: serviceLocator<TokenSharedPrefs>(),
    ),
  );
  serviceLocator.registerFactory<IOrderRepository>(
    () => OrderRepository(serviceLocator<OrderRemoteDataSource>()),
  );
  serviceLocator.registerFactory(
    () => GetOrdersUseCase(serviceLocator<IOrderRepository>()),
  );
  serviceLocator.registerFactory(
    () => OrderBloc(getOrdersUseCase: serviceLocator<GetOrdersUseCase>()),
  );
}


// ---------------------- ViewModels ----------------------

  // void _initViewModels() {
  // // Register RegisterViewModel with RegisterUsecase injected
  // serviceLocator.registerFactory(
  //   () => RegisterViewModel(serviceLocator<UserRegisterUsercase>()),
  // );

  // Register LoginViewModel with LoginUsecase injected
//   serviceLocator.registerFactory(
//     () => LoginViewModel(serviceLocator<UserLoginUsecase>()),
//   );
// }
