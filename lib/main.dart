import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_tile/modules/login/login_screen.dart';
import 'package:map_tile/shared/bloc_observe.dart';
import 'package:map_tile/shared/networks/local/cache_helper.dart';
import 'package:map_tile/shared/networks/remote/dio_helper.dart';
import 'package:map_tile/shared/styles/themes.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  // bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  // String? token = CacheHelper.getData(key: 'token');
  // Widget start;
  // if (onBoarding != null) {
  //   if (token != null) {
  //     start = const ShopLayout();
  //   }
  //   else {
  //     start = LoginScreen();
  //   }
  // }
  // else {
  //   start = OnBoardingScreen();
  // }
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightmode,
      darkTheme: darkmode,
      themeMode: ThemeMode.light,
      home: LoginScreen() ,
    );
  }
}
