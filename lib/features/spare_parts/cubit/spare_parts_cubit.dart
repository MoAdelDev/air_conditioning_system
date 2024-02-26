import 'package:air_conditioning_system/features/add_spare_parts/data/spare_part_model.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';

part 'spare_parts_state.dart';

class SparePartsCubit extends Cubit<SparePartsState> {
  SparePartsCubit() : super(SparePartsInitial());

  List<SparePartModel> spareParts = [];
  void getSpareParts(final String storeId) {
    emit(SparePartsLoading());
    FirebaseDatabase.instance
        .ref('spareParts')
        .orderByChild('storeId')
        .equalTo(storeId)
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
      }
      emit(SparePartsSuccess());
    });
  }
}
