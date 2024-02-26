import 'package:air_conditioning_system/core/data/app_data.dart';
import 'package:air_conditioning_system/features/order/data/order_model.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());

  void order({
    required String image,
    required String name,
    required String storeId,
    required String totalPrice,
    required String amount,
    required String address,
    required bool isVisa,
  }) {
    emit(OrderLoading());
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseDatabase.instance.ref('stores').child(storeId).get().then((value) {
      if (value.exists) {
        if (value.exists && value.value != null) {
          Object data = value.value!;
          Map<String, dynamic> dataMap = {};

          if (data is Map) {
            data.forEach((key, value) {
              if (key is String) {
                dataMap[key] = value;
              }
            });
          }
          String storeName = dataMap['name'];
          OrderModel orderModel = OrderModel(
            id,
            name,
            image,
            storeId,
            storeName,
            address,
            totalPrice.toString(),
            FirebaseAuth.instance.currentUser?.uid ?? '',
            int.parse(amount),
            userModel?.name ?? '',
            isVisa ? 'بطاقة دفع' : 'الدفع عند الاستلام',
          );

          FirebaseDatabase.instance
              .ref('orders/$id')
              .set(orderModel.toJson())
              .then((value) {
            emit(OrderSuccess());
          }).catchError((error) {
            emit(OrderFailed(message: error.toString()));
          });
        }
      }
    });
  }
}
