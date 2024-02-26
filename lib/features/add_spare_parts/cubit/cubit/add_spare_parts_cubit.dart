import 'dart:io';

import 'package:air_conditioning_system/features/add_spare_parts/data/spare_part_model.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

part 'add_spare_parts_state.dart';

class AddSparePartsCubit extends Cubit<AddSparePartsState> {
  AddSparePartsCubit() : super(AddSparePartsInitial());

  File? imageFile;

  void uploadImage() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageFile = File(image.path);
      emit(UploadImage());
    }
  }

  void addSparePart(
      {required String name,
      required String price,
      required String brandName}) {
    emit(AddSparePartsLoading());
    if (imageFile != null) {
      final String id = DateTime.now().millisecondsSinceEpoch.toString();
      FirebaseStorage.instance
          .ref('spare-parts/$id')
          .putFile(imageFile!)
          .then((p0) {
        p0.ref.getDownloadURL().then((value) {
          SparePartModel model = SparePartModel(
            name,
            price,
            brandName,
            id,
            value,
            FirebaseAuth.instance.currentUser?.uid ?? '',
          );
          FirebaseDatabase.instance
              .ref('spareParts/$id')
              .set(model.toJson())
              .then((value) {
            imageFile = null;
            emit(AddSparePartsSuccess());
          }).catchError((error) {
            emit(AddSparePartsError(error.toString()));
          });
        });
      }).catchError((error) {
        emit(AddSparePartsError(error.toString()));
      });
    } else {
      emit(AddSparePartsError('أدخل صورة لقطعة الغيار'));
    }
  }
}
