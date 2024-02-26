part of 'orders_cubit.dart';

sealed class OrdersState {}

final class OrdersInitial extends OrdersState {}

final class OrdersLoading extends OrdersState {}

final class OrdersSuccess extends OrdersState {}

final class OrdersError extends OrdersState {
  final String error;
  OrdersError(this.error);
}
