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

  loadUsers() async {
    emit(MapLoadUserLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {
        allusers = [];
        allusers.add(UserModel.fromJson(element.data()));
        print(element.data());
      }
      print(value.docs);
      emit(MapLoadUserSuccessState());
    }).catchError((error) {
      emit(MapLoadUserErrorState(error.toString()));
      print(error);
    });
  }

  void chechPhone(String phone) async {
    emit(MapCheckPhoneLoadingState());
    processing = true;
    bool unique = true;
    FirebaseFirestore.instance.collection('users').get().then((value) {
      allusers = [];
      for (var element in value.docs) {
        UserModel temp = UserModel.fromJson(element.data());
        allusers.add(temp);
        print(temp.phone);
        print(phone);
        if (phone == temp.phone) {
          unique = false;
        }
        print(element.data());
      }
      print(unique);
      print(allusers.length);
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
      print(value.user);
      userCreate(
          fname: fname,
          lname: lname,
          email: email,
          phone: phone,
          id: value.user!.uid);
      emit(MapRegisterSuccessState("Success"));
    }).catchError((error) {
      processing = false;
      print(error.toString());
      emit(MapRegisterErrorState(error.toString()));
    });
  }

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
