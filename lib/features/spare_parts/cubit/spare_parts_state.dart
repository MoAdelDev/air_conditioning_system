part of 'spare_parts_cubit.dart';

sealed class SparePartsState {}

final class SparePartsInitial extends SparePartsState {}

final class SparePartsLoading extends SparePartsState {}

final class SparePartsSuccess extends SparePartsState {}

final class SparePartsError extends SparePartsState {
  final String error;

  SparePartsError(this.error);
}
