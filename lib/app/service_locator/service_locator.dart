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
import 'package:sajilo_style/features/home/presentation/view_model/home_view_model.dart';
import 'package:sajilo_style/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initApiService();
  await _initHiveService();
  await _initSharedPrefs();
  await _initAuthModule();
  await _initHomeModule();
  await _initSplashModule();


  //  await _initHiveService();
  // await _initApiService();
  // await _initSharedPrefs();
  // await _initAuthModule();
  // await _initHomeModule();
  // await _initSplashModule();
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
    () => UserRemoteDatasource(apiService: serviceLocator<ApiService>()),
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
    () => HomeViewModel(loginViewModel: serviceLocator<LoginViewModel>()),
  );
}


// ---------------------- Splash Module ----------------------

Future<void> _initSplashModule()  async {
  // Register SplashViewModel
  serviceLocator.registerFactory(() => SplashViewModel());
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
