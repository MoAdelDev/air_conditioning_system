part of 'home_cubit.dart';

sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeGetUserLoading extends HomeState {}

final class HomeGetUserSuccess extends HomeState {}

final class HomeGetUserError extends HomeState {}

final class HomeGetStoresLoading extends HomeState {}

final class HomeGetStoresSuccess extends HomeState {}

final class HomeGetStoresError extends HomeState {}

final class HomeGetSparePartsLoading extends HomeState {}

final class HomeGetSparePartsSuccess extends HomeState {}

final class HomeGetSparePartsError extends HomeState {}

final class HomeGetAirConditionersLoading extends HomeState {}

final class HomeGetAirConditionersSuccess extends HomeState {}

final class HomeGetAirConditionersError extends HomeState {}

final class HomeGetReportersLoadingState extends HomeState {}

final class HomeGetReportersSuccessState extends HomeState {}

final class HomeGetReportersErrorState extends HomeState {}
