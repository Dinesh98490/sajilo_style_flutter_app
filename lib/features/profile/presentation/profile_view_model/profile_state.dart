import 'package:equatable/equatable.dart';
import 'package:sajilo_style/features/auth/domain/entity/user_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserEntity user;
  const ProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileUpdateLoading extends ProfileState {}
class ProfileUpdateSuccess extends ProfileState {}
class ProfileUpdateError extends ProfileState {
  final String message;
  const ProfileUpdateError(this.message);
  @override
  List<Object?> get props => [message];
}

class ChangePasswordLoading extends ProfileState {}
class ChangePasswordSuccess extends ProfileState {}
class ChangePasswordError extends ProfileState {
  final String message;
  const ChangePasswordError(this.message);
  @override
  List<Object?> get props => [message];
} 