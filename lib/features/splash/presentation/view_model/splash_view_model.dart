import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_style/app/service_locator/service_locator.dart';
import 'package:sajilo_style/features/auth/presentation/view/login_view.dart';
import 'package:sajilo_style/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:sajilo_style/app/shared_pref/token_shared_prefs.dart';
import 'package:sajilo_style/features/home/presentation/view/home_view.dart';
import 'package:sajilo_style/features/home/presentation/product_view_model/home_view_model.dart';
import 'package:sajilo_style/features/home/presentation/product_view_model/product_bloc.dart';
import 'package:sajilo_style/features/home/domain/use_case/product_get_current_usecase.dart';

class SplashViewModel extends Cubit<void> {
  SplashViewModel() : super(null);

  // Open Login View or Home View after 2 seconds based on token
  Future<void> init(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2), () async {
      final tokenResult = await serviceLocator<TokenSharedPrefs>().getToken();
      final token = tokenResult.fold((failure) => null, (t) => t);
      if (context.mounted) {
        if (token != null && token.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<HomeViewModel>.value(
                    value: serviceLocator<HomeViewModel>(),
                  ),
                  BlocProvider<ProductBloc>(
                    create: (_) => ProductBloc(
                      getAllProducts: serviceLocator<ProductGetCurrentUsecase>(),
                    ),
                  ),
                ],
                child: const HomeView(),
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (_) => serviceLocator<LoginViewModel>(),
                child: LoginView(),
              ),
            ),
          );
        }
      }
    });
  }
}
