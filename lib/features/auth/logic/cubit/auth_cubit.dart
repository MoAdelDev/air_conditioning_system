import 'dart:io';

import 'package:air_conditioning_system/core/data/app_data.dart';
import 'package:air_conditioning_system/features/auth/data/store_model.dart';
import 'package:air_conditioning_system/features/auth/data/user_model.dart';
import 'package:air_conditioning_system/features/auth/logic/cubit/auth_state.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void login({required String email, required String password}) async {
    emit(AuthLoginLoading());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      if (value.user != null) {
        String uid = value.user!.uid;
        FirebaseDatabase.instance.ref('stores').child(uid).get().then((value) {
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
            emit(AuthLoginSuccess());
          } else {
            FirebaseDatabase.instance
                .ref('admins')
                .child(uid)
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
                emit(AuthLoginSuccess());
              } else {
                FirebaseDatabase.instance
                    .ref('clients')
                    .child(uid)
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
                    emit(AuthLoginSuccess());
                  } else {
                    emit(AuthLoginError('User not found'));
                  }
                });
              }
            });
          }
        });
      }
    }).catchError((error) {
      emit(AuthLoginError(error.toString()));
    });
  }

  File? imageFile;

  void uploadImage() async {
    ImagePicker picker = ImagePicker();
    final response = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (response == null) return;
    imageFile = File(response.path);
    emit(UploadImage());
  }

  void storeRegister({
    required String email,
    required String password,
    required String name,
    required String address,
    required String phone,
  }) async {
    emit(AuthRegisterLoading());
    if (imageFile == null) {
      emit(AuthRegisterError('Please upload your image'));
    } else {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (value.user != null) {
          String uid = value.user!.uid;
          FirebaseStorage.instance
              .ref()
              .child('stores/$uid')
              .putFile(imageFile!)
              .then((p0) {
            p0.ref.getDownloadURL().then((value) {
              StoreModel storeModel = StoreModel(
                uid,
                email,
                name,
                phone,
                address,
                value,
              );
              FirebaseDatabase.instance
                  .ref('stores')
                  .child(uid)
                  .set(storeModel.toJson())
                  .then((value) {
                imageFile = null;
                emit(AuthRegisterSuccess());
              }).catchError((error) {
                emit(AuthRegisterError(error.toString()));
              });
            }).catchError((error) {
              emit(AuthRegisterError(error.toString()));
            });
          }).catchError((error) {
            emit(AuthRegisterError(error.toString()));
          });
        }
      }).catchError((error) {
        emit(AuthRegisterError(error.toString()));
      });
    }
  }

  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    emit(AuthRegisterLoading());
    if (imageFile == null) {
      emit(AuthRegisterError('Please upload your image'));
    } else {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (value.user != null) {
          String uid = value.user!.uid;
          FirebaseStorage.instance
              .ref()
              .child('user/$uid')
              .putFile(imageFile!)
              .then((p0) {
            p0.ref.getDownloadURL().then((value) {
              UserModel userModel = UserModel(
                uid,
                email,
                name,
                phone,
                value,
              );
              FirebaseDatabase.instance
                  .ref('clients')
                  .child(uid)
                  .set(userModel.toJson())
                  .then((value) {
                imageFile = null;
                emit(AuthRegisterSuccess());
              }).catchError((error) {
                emit(AuthRegisterError(error.toString()));
              });
            }).catchError((error) {
              emit(AuthRegisterError(error.toString()));
            });
          }).catchError((error) {
            emit(AuthRegisterError(error.toString()));
          });
        }
      }).catchError((error) {
        emit(AuthRegisterError(error.toString()));
      });
    }
  }
}
