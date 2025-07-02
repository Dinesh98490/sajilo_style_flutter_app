import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sajilo_style/core/common/snackbar/my_snackbar.dart';
import 'package:sajilo_style/features/auth/domain/use_case/user_register_usercase.dart';
import 'package:sajilo_style/features/auth/presentation/view_model/register_view_model/register_event.dart';
import 'package:sajilo_style/features/auth/presentation/view_model/register_view_model/register_state.dart';

class RegisterViewModel  extends Bloc<RegisterEvent, RegisterState>{

  final UserRegisterUsercase _userRegisterUsecase;



  RegisterViewModel(
    this._userRegisterUsecase,

  ) : super(RegisterState.initial()){

     on<RegisterUserEvent>(_onRegisterUser);

  }

  Future<void> _onRegisterUser(
    RegisterUserEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    

    final result = await _userRegisterUsecase(
      RegisterUserParams(
        fullName: event.fullName,
        email: event.email,
        phone_number: event.phone_number,
        password: event.password,
        role:event.role
      ),
    );
     result.fold(
      (l) {
        print(l);
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showMySnackBar(
          context: event.context,
          message: l.message,
          color: Colors.orange,
        );
      },
      (r) {
        print("success");
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
          context: event.context,
          message: "Registration Successful",
        );
      },
    );
  }

}