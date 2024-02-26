import 'package:air_conditioning_system/features/add_air_conditioner/data/air_conditioner_model.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';

part 'air_conditioners_state.dart';

class AirConditionersCubit extends Cubit<AirConditionersState> {
  AirConditionersCubit() : super(AirConditionersInitial());

  List<AirConditionerModel> airConditioners = [];
  void getAirConditioners(final String storeId) {
    emit(AirConditionersLoading());
    FirebaseDatabase.instance
        .ref('airConditioners')
        .orderByChild('storeId')
        .equalTo(storeId)
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
      }
      emit(AirConditionersSuccess());
    });
  }
}
