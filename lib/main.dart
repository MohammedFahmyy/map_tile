import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_tile/cubit/states.dart';
import 'package:map_tile/modules/login/login_screen.dart';
import 'package:map_tile/shared/bloc_observe.dart';
import 'package:map_tile/shared/networks/local/cache_helper.dart';
import 'package:map_tile/shared/networks/remote/dio_helper.dart';
import 'package:map_tile/shared/styles/themes.dart';
import 'cubit/cubit.dart';
import 'firebase_options.dart';
import 'layouts/home_layout/home_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return BlocProvider(
      create: (context) => AppCubit()
        ..loadUsers()
        ..cachedData()
        ..determinePosition()
        ..getDirectory(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return MaterialApp(
              title: 'Map Tile',
              debugShowCheckedModeBanner: false,
              theme: lightmode,
              themeMode: ThemeMode.light,
              home: ConditionalBuilder(
                  condition: (!cubit.loadingLocation) && (!cubit.loadingUsers),
                  builder: (context) =>
                      (cubit.uId != null) ? const HomeLayout() : LoginScreen(),
                  fallback: (context) {
                    return const Scaffold(
                        body: Center(child: CircularProgressIndicator()));
                  }));
        },
      ),
    );
  }
}
