import 'package:air_conditioning_system/features/add_air_conditioner/data/air_conditioner_model.dart';
import 'package:air_conditioning_system/features/order/data/order_model.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitial());

  List<OrderModel> orders = [];
  List<AirConditionerModel> airConditioners = [];
  void getOrders() {
    emit(OrdersLoading());
    FirebaseDatabase.instance
        .ref('orders')
        .orderByChild('storeId')
        .equalTo(FirebaseAuth.instance.currentUser?.uid ?? '')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        orders = event.snapshot.children.map((value) {
          Object data = value.value!;
          Map<String, dynamic> dataMap = {};
          if (data is Map) {
            data.forEach((key, value) {
              if (key is String) {
                dataMap[key] = value;
              }
            });
          }
          return OrderModel.fromJson(dataMap);
        }).toList();
        emit(OrdersSuccess());
      }
    });
  }
}
