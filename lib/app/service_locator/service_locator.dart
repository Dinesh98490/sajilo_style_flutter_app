import 'package:get_it/get_it.dart';
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

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Initialize services that require async setup, e.g., Hive
  await _initHiveService();

  // Register data sources, repositories, and use cases synchronously
  _initAuthModule();

  // Register ViewModels that depend on above use cases
  _initViewModels();

  // Register other modules like Home and Splash ViewModels
  _initHomeModule();
  _initSplashModule();
}

// ---------------------- Hive Service ----------------------

Future<void> _initHiveService() async {
  // Initialize and register HiveService
  serviceLocator.registerLazySingleton(() => HiveService());
}

// ---------------------- Auth Module ----------------------

void _initAuthModule() {
  // Register remote datasource - make sure this is added!
  serviceLocator.registerFactory(() => UserRemoteDatasource());

  // Register local datasource, injecting HiveService
  serviceLocator.registerFactory(() => UserLocalDatasource(
        hiveService: serviceLocator<HiveService>(),
      ));

  // Register remote repository, injecting remote datasource
  serviceLocator.registerFactory(() => UserRemoteRepository(
        datasource: serviceLocator<UserRemoteDatasource>(),
      ));
      serviceLocator.registerFactory(() => UserLocalRepository(
        userLocalDatasource: serviceLocator<UserLocalDatasource>()
        
      ));


  // Register use cases, injecting repository
  serviceLocator.registerFactory(() => UserLoginUsecase(
        userRepository: serviceLocator<UserLocalRepository>(),
      ));

  serviceLocator.registerFactory(() => UserRegisterUsercase(
        userRepository: serviceLocator<UserLocalRepository>(),
      ));

  serviceLocator.registerFactory(() => UserGetCurrentUsecase(
        userRepository: serviceLocator<UserLocalRepository>(),
      ));
}

// ---------------------- Home Module ----------------------

void _initHomeModule() {
  // Register HomeViewModel with dependency on LoginViewModel
  serviceLocator.registerFactory(
    () => HomeViewModel(loginViewModel: serviceLocator<LoginViewModel>()),
  );
}

// ---------------------- Splash Module ----------------------

void _initSplashModule() {
  // Register SplashViewModel
  serviceLocator.registerFactory(() => SplashViewModel());
}

// ---------------------- ViewModels ----------------------

void _initViewModels() {
  // Register RegisterViewModel with RegisterUsecase injected
  serviceLocator.registerFactory(() => RegisterViewModel(
        serviceLocator<UserRegisterUsercase>(),
      ));

  // Register LoginViewModel with LoginUsecase injected
  serviceLocator.registerFactory(() => LoginViewModel(
        serviceLocator<UserLoginUsecase>(),
      ));
}
