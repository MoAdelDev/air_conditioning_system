part of 'add_air_conditioner_cubit.dart';

sealed class AddAirConditionerState {}

final class AddInitial extends AddAirConditionerState {}

final class UploadImage extends AddAirConditionerState {}

final class AddAirConditionerLoading extends AddAirConditionerState {}

final class AddAirConditionerSuccess extends AddAirConditionerState {}

final class AddAirConditionerError extends AddAirConditionerState {
  final String error;

  AddAirConditionerError(this.error);
}
