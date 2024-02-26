part of 'add_spare_parts_cubit.dart';

sealed class AddSparePartsState {}

final class AddSparePartsInitial extends AddSparePartsState {}

final class AddSparePartsLoading extends AddSparePartsState {}

final class AddSparePartsSuccess extends AddSparePartsState {}

final class AddSparePartsError extends AddSparePartsState {
  final String error;
  AddSparePartsError(this.error);
}

final class UploadImage extends AddSparePartsState {}
