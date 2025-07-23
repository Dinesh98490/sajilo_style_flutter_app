import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_style/features/profile/presentation/profile_view_model/profile_event.dart';
import 'package:sajilo_style/features/profile/presentation/profile_view_model/profile_state.dart';
import 'package:sajilo_style/features/auth/domain/use_case/user_get_current_usecase.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserGetCurrentUsecase _getCurrentUser;

  ProfileBloc({required UserGetCurrentUsecase getCurrentUser})
      : _getCurrentUser = getCurrentUser,
        super(ProfileInitial()) {
    on<FetchProfileEvent>(_onFetchProfile);
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
} 