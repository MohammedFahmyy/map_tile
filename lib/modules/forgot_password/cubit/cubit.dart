import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_tile/modules/forgot_password/cubit/states.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordStates> {
  ForgotPasswordCubit() : super(ForgotPasswordInitialState());

  static ForgotPasswordCubit get(context) => BlocProvider.of(context);

  bool loading = false;

  // Progress Indicator
  toggleLoading(){
    loading = !loading;
    emit(ForgotPasswordToggleLoadingState());
  }
}
