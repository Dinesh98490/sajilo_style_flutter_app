import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_style/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'home_state.dart';

class HomeViewModel extends Cubit<HomeState> {
  final LoginViewModel loginViewModel;

  HomeViewModel({required this.loginViewModel}) : super(HomeInitial());

  void loadHomeData() {
    emit(HomeLoading());

    // Simulate a delay and fetch user data
    Future.delayed(const Duration(seconds: 1), () {
      try {
        final userName = 'Dinesh';
        emit(HomeLoaded(fullName: userName));
      } catch (e) {
        emit(HomeError(message: 'Failed to load home data'));
      }
    });
  }

  // Optionally remove if not needed
  void loadData() => loadHomeData();
}
