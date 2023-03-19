import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_tile/models/user_model.dart';
import 'package:map_tile/modules/register/cubit/states.dart';
import 'package:map_tile/shared/constants/constants.dart';

class MapRegisterCubit extends Cubit<MapRegisterStates> {
  MapRegisterCubit() : super(MapRegisterInitialState());

  static MapRegisterCubit get(context) => BlocProvider.of(context);
  bool visiblePassword = true;
  bool processing = false;

  // Fuction to Check Phone Uniqueness
  void chechPhone(String phone) async {
    emit(MapCheckPhoneLoadingState());
    processing = true;
    bool unique = true;
    // Get All Users From Database
    FirebaseFirestore.instance.collection('users').get().then((value) {
      // Empty List
      allusers = [];
      // Loop To get Users
      for (var element in value.docs) {
        UserModel temp = UserModel.fromJson(element.data());
        allusers.add(temp);
        // Check If Phone Is Reapeated
        if (phone == temp.phone) {
          unique = false;
        }
      }
      if (unique) {
        emit(MapCheckPhoneSuccessState());
      } else {
        processing = false;
        emit(MapCheckPhoneErrorState("Phone number is already in use"));
      }
    }).catchError((error) {
      processing = false;
      emit(MapCheckPhoneErrorState(error.toString()));
    });
  }

  // Register User Creadentials
  void userRegister({
    required String email,
    required String password,
    required String phone,
    required String fname,
    required String lname,
  }) async {
    emit(MapRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      userCreate(
          fname: fname,
          lname: lname,
          email: email,
          phone: phone,
          id: value.user!.uid);
      emit(MapRegisterSuccessState("Success"));
    }).catchError((error) {
      processing = false;
      emit(MapRegisterErrorState(error.toString()));
    });
  }

  // Add User Info To Database
  // Note: Default Coordinates are (0,0) and used is visible by default
  void userCreate({
    required String fname,
    required String lname,
    required String email,
    required String phone,
    required String id,
  }) {
    emit(MapCreateUserLoadingState());
    UserModel model = UserModel(
      email: email,
      fname: fname,
      lname: lname,
      phone: phone,
      id: id,
      visibility: true,
      lat: 0.0,
      lng: 0.0,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(model.toMap())
        .then((value) {
      processing = false;
      emit(MapCreateUserSuccessState(id));
    }).catchError((error) {
      processing = false;
      emit(MapCreateUserErrorState(error.toString()));
    });
  }
}
