// home_state.dart

import 'package:flutter/material.dart';

@immutable
abstract class HomeState {
  get offers => null;

  get fullName => null;

  get cate => null;

  
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final String fullName;

  HomeLoaded({required this.fullName});
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});
}
