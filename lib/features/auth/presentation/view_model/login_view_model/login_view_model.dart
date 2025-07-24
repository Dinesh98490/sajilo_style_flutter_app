import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_style/app/service_locator/service_locator.dart';
import 'package:sajilo_style/core/common/snackbar/my_snackbar.dart';
import 'package:sajilo_style/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:sajilo_style/features/auth/presentation/view/register_view.dart';
import 'package:sajilo_style/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:sajilo_style/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:sajilo_style/features/auth/presentation/view_model/register_view_model/register_view_model.dart';
import 'package:sajilo_style/features/home/presentation/view/home_view.dart';
import 'package:sajilo_style/features/home/presentation/product_view_model/home_view_model.dart';
import 'package:sajilo_style/features/home/presentation/product_view_model/product_bloc.dart';
import 'package:sajilo_style/features/home/domain/use_case/product_get_current_usecase.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _userLoginUsecase;

  LoginViewModel(this._userLoginUsecase) : super(LoginState.initial()) {
    on<NavigateToRegisterViewEvent>(_onNavigateToRegisterView);
    on<NavigateToHomeViewEvent>(_onNavigateToHomeView);
    on<LoginWithEmailAndPasswordEvent>(_onLoginWithEmailAndPassword);
  }

  void _onNavigateToRegisterView(
    NavigateToRegisterViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,

        MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: serviceLocator<RegisterViewModel>()),
            ],
            child: RegisterView(),
          ),
        ),
      );
    }
  }

 void _onNavigateToHomeView(
    NavigateToHomeViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.pushReplacement(
        event.context,
        MaterialPageRoute(
          builder: (context) => BlocProvider<ProductBloc>(
            create: (_) => ProductBloc(getAllProducts: serviceLocator<ProductGetCurrentUsecase>()),
            child: BlocProvider.value(
              value: serviceLocator<HomeViewModel>(),
              child: const HomeView(),
            ),
          ),
        ),
      );
    }
  }
  void _onLoginWithEmailAndPassword(
    LoginWithEmailAndPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _userLoginUsecase(
      LoginParams(email: event.email, password: event.password),
    );

    print(result);
    result.fold(
      (failure) {
        // Handle failure case
        emit(state.copyWith(isLoading: false, isSuccess: false));
        if (event.context != null) {
          showMySnackBar(
            context: event.context!,
            message: 'Invalid credentials. Please try again.',
            color: Colors.red,
          );
        }
      },
      (token) {
        // Handle success case
        emit(state.copyWith(isLoading: false, isSuccess: true));
        if (event.context != null) {
          add(NavigateToHomeViewEvent(context: event.context!));
        }
      },
    );


  }
}
