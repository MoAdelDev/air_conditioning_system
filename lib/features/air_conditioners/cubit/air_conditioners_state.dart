part of 'air_conditioners_cubit.dart';

sealed class AirConditionersState {}

final class AirConditionersInitial extends AirConditionersState {}

final class AirConditionersLoading extends AirConditionersState {}

final class AirConditionersSuccess extends AirConditionersState {}

final class AirConditionersError extends AirConditionersState {
  final String error;
  AirConditionersError(this.error);
}
