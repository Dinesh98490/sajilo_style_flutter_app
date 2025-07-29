import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_style/features/profile/presentation/profile_view_model/profile_event.dart';
import 'package:sajilo_style/features/profile/presentation/profile_view_model/profile_state.dart';
import 'package:sajilo_style/features/auth/domain/use_case/user_get_current_usecase.dart';
import 'package:sajilo_style/features/auth/domain/use_case/user_update_profile_usecase.dart';
import 'package:sajilo_style/features/auth/domain/use_case/user_change_password_usecase.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserGetCurrentUsecase _getCurrentUser;
  final UserUpdateProfileUsecase _updateProfile;
  final UserChangePasswordUsecase _changePassword;

  ProfileBloc({
    required UserGetCurrentUsecase getCurrentUser,
    required UserUpdateProfileUsecase updateProfile,
    required UserChangePasswordUsecase changePassword,
  })  : _getCurrentUser = getCurrentUser,
        _updateProfile = updateProfile,
        _changePassword = changePassword,
        super(ProfileInitial()) {
    on<FetchProfileEvent>(_onFetchProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<ChangePasswordEvent>(_onChangePassword);
  }

  Future<void> _onFetchProfile(
      FetchProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await _getCurrentUser();
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (user) => emit(ProfileLoaded(user)),
    );
  }

  Future<void> _onUpdateProfile(UpdateProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileUpdateLoading());
    final result = await _updateProfile(event.user);
    result.fold(
      (failure) => emit(ProfileUpdateError(failure.message)),
      (_) => emit(ProfileUpdateSuccess()),
    );
  }

  Future<void> _onChangePassword(ChangePasswordEvent event, Emitter<ProfileState> emit) async {
    emit(ChangePasswordLoading());
    final result = await _changePassword(ChangePasswordParams(
      oldPassword: event.oldPassword,
      newPassword: event.newPassword,
    ));
    result.fold(
      (failure) => emit(ChangePasswordError(failure.message)),
      (_) => emit(ChangePasswordSuccess()),
    );
  }
} 