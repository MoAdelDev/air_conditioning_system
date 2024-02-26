import 'package:air_conditioning_system/core/data/app_data.dart';
import 'package:air_conditioning_system/features/add_air_conditioner/data/air_conditioner_model.dart';
import 'package:air_conditioning_system/features/add_spare_parts/data/spare_part_model.dart';
import 'package:air_conditioning_system/features/auth/data/store_model.dart';
import 'package:air_conditioning_system/features/auth/data/user_model.dart';
import 'package:air_conditioning_system/features/order/data/order_model.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void getUser() async {
    emit(HomeGetUserLoading());
    FirebaseDatabase.instance
        .ref('stores')
        .child(FirebaseAuth.instance.currentUser?.uid ?? '')
        .get()
        .then((value) {
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
        storeModel = StoreModel.fromJson(dataMap);
        emit(HomeGetUserSuccess());
      } else {
        FirebaseDatabase.instance
            .ref('admins')
            .child(FirebaseAuth.instance.currentUser?.uid ?? '')
            .get()
            .then((value) {
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
            userModel = UserModel.fromJson(dataMap);
            emit(HomeGetUserSuccess());
          } else {
            FirebaseDatabase.instance
                .ref('clients')
                .child(FirebaseAuth.instance.currentUser?.uid ?? '')
                .get()
                .then((value) {
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
                userModel = UserModel.fromJson(dataMap);
                emit(HomeGetUserError());
              } else {
                emit(HomeGetUserError());
              }
            });
          }
        });
      }
    });
  }

  List<StoreModel> stores = [];

  void getStores() {
    emit(HomeGetStoresLoading());
    FirebaseDatabase.instance.ref('stores').onValue.listen((value) {
      if (value.snapshot.value != null) {
        stores = value.snapshot.children.map((value) {
          Object data = value.value!;
          Map<String, dynamic> dataMap = {};
          if (data is Map) {
            data.forEach((key, value) {
              if (key is String) {
                dataMap[key] = value;
              }
            });
          }
          return StoreModel.fromJson(dataMap);
        }).toList();
        emit(HomeGetStoresSuccess());
      }
    });
  }

  List<AirConditionerModel> airConditioners = [];

  void getAirConditioners() {
    emit(HomeGetAirConditionersLoading());
    FirebaseDatabase.instance
        .ref('airConditioners')
        .orderByChild('storeId')
        .equalTo(FirebaseAuth.instance.currentUser?.uid ?? '')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        airConditioners = event.snapshot.children.map((value) {
          Object data = value.value!;
          Map<String, dynamic> dataMap = {};
          if (data is Map) {
            data.forEach((key, value) {
              if (key is String) {
                dataMap[key] = value;
              }
            });
          }
          return AirConditionerModel.fromJson(dataMap);
        }).toList();
        emit(HomeGetAirConditionersSuccess());
      }
    });
  }

  List<SparePartModel> spareParts = [];
  void getSpareParts() {
    emit(HomeGetSparePartsLoading());
    FirebaseDatabase.instance
        .ref('spareParts')
        .orderByChild('storeId')
        .equalTo(FirebaseAuth.instance.currentUser?.uid ?? '')
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        spareParts = event.snapshot.children.map((value) {
          Object data = value.value!;
          Map<String, dynamic> dataMap = {};
          if (data is Map) {
            data.forEach((key, value) {
              if (key is String) {
                dataMap[key] = value;
              }
            });
          }
          return SparePartModel.fromJson(dataMap);
        }).toList();
        emit(HomeGetSparePartsSuccess());
      }
    });
  }

  void deleteAirConditioner({required String airConditionerId}) {
    FirebaseDatabase.instance
        .ref('airConditioners')
        .child(airConditionerId)
        .remove()
        .then((value) {
      if (airConditioners.length == 1) {
        airConditioners = [];
      }
      getAirConditioners();
    });
  }

  void deleteSparePart({required String sparePartId}) {
    FirebaseDatabase.instance
        .ref('spareParts')
        .child(sparePartId)
        .remove()
        .then((value) {
      if (spareParts.length == 1) {
        spareParts = [];
      }
      getSpareParts();
    });
  }

  List<OrderModel> orders = [];
  void getReporters() {
    emit(HomeGetReportersLoadingState());
    FirebaseDatabase.instance.ref('orders').onValue.listen((value) {
      if (value.snapshot.value != null) {
        orders = value.snapshot.children.map((value) {
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
        emit(HomeGetReportersSuccessState());
      }
    });
  }
}
