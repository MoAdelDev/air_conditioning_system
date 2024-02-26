import 'dart:io';
import 'package:air_conditioning_system/features/add_air_conditioner/data/air_conditioner_model.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

part 'add_state.dart';

class AddAirConsditionerCubit extends Cubit<AddAirConditionerState> {
  AddAirConsditionerCubit() : super(AddInitial());

  File? imageFile;

  void uploadImage() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageFile = File(image.path);
      emit(UploadImage());
    }
  }

  void addAirConditioner(
      {required String name, required String price, required String capacity}) {
    emit(AddAirConditionerLoading());
    if (imageFile != null) {
      final String id = DateTime.now().millisecondsSinceEpoch.toString();
      FirebaseStorage.instance
          .ref('air-conditioners/$id')
          .putFile(imageFile!)
          .then((p0) {
        p0.ref.getDownloadURL().then((value) {
          AirConditionerModel model = AirConditionerModel(
            name,
            price,
            capacity,
            id,
            value,
            FirebaseAuth.instance.currentUser?.uid ?? '',
          );
          FirebaseDatabase.instance
              .ref('airConditioners/$id')
              .set(model.toJson())
              .then((value) {
            imageFile = null;
            emit(AddAirConditionerSuccess());
          }).catchError((error) {
            emit(AddAirConditionerError(error.toString()));
          });
        });
      }).catchError((error) {
        emit(AddAirConditionerError(error.toString()));
      });
    } else {
      emit(AddAirConditionerError('أدخل صورة للتكييف'));
    }
  }
}
