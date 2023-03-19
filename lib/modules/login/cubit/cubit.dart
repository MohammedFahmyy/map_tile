import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_tile/modules/login/cubit/states.dart';

class MapLoginCubit extends Cubit<MapLoginStates> {
  MapLoginCubit() : super(MapLoginInitialState());

  static MapLoginCubit get(context) => BlocProvider.of(context);
  bool visiblePassword = true;
  //MapLoginModel? loginModel;

  void togglePasswordVisibiltiy()
  {
    visiblePassword = !visiblePassword;
    emit(MapLoginTogglePasswordState());
  }

  void userLogin({
    required String email,
    required String password,
  }){
    emit(MapLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value){
      print(value.user!.uid);
      emit(MapLoginSuccessState(value.user!.uid));
    }).catchError((error){
      print(error.toString());
      emit(MapLoginErrorState(error.toString()));
    });
  }
}