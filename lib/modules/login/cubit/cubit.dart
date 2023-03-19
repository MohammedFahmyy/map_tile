import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_tile/modules/login/cubit/states.dart';

class MapLoginCubit extends Cubit<MapLoginStates> {
  MapLoginCubit() : super(MapLoginInitialState());

  static MapLoginCubit get(context) => BlocProvider.of(context);
  bool visiblePassword = true;

  // Toggle Password Visibility
  void togglePasswordVisibiltiy()
  {
    visiblePassword = !visiblePassword;
    emit(MapLoginTogglePasswordState());
  }

  // Login With Email & Password
  void userLogin({
    required String email,
    required String password,
  }){
    emit(MapLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value){

      emit(MapLoginSuccessState(value.user!.uid));
    }).catchError((error){

      emit(MapLoginErrorState(error.toString()));
    });
  }
}