import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_style/app/service_locator/service_locator.dart';
import 'package:sajilo_style/features/auth/presentation/view/login_view.dart';
import 'package:sajilo_style/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

class SplashViewModel extends Cubit<void> {
  SplashViewModel() : super(null);

  // Open Login View after 2 seconds
  Future<void> init(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2), () async {
      // Open Login page or Onboarding Screen

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: serviceLocator<LoginViewModel>(),
              child: LoginView(),
            ),
          ),
        );
      }
    });
  }
}
