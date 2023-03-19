import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_tile/cubit/states.dart';
import 'package:map_tile/modules/login/login_screen.dart';
import 'package:map_tile/shared/bloc_observe.dart';
import 'package:map_tile/shared/networks/local/cache_helper.dart';
import 'package:map_tile/shared/styles/themes.dart';
import 'cubit/cubit.dart';
import 'firebase_options.dart';
import 'layouts/home_layout/home_layout.dart';

//Main function of the application
void main() async {
  // Flutter Binding is essential before run app to make sure everything is just right
  WidgetsFlutterBinding.ensureInitialized();
  // Bloc observer is used to monitor the app states while using bloc state managment
  Bloc.observer = MyBlocObserver();
  // CacheHelper to deal with Cached Data save,get,clear ...etc
  await CacheHelper.init();
  // Firebase is used to connect the application to online database & authentication
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // run app :)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // Lock the rotation of the application
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // Here we start the real work
    // First we create a bloc(Cubit) to start working with our states
    return BlocProvider(
      // Create the Bloc
      // The .. is used to do the function right after we create our bloc
      // We need to execute 4 main functions
      // 1- loadUsers to connect the application to database
      // Just in case the user is already logged in and will navigate to Home directly
      // 2- CachedData to check if the user is already logged in and downloaded the map
      // Believe me you need this you don't want to download the map everytime :)
      // determinePosition to get User Position
      // getDirectory to initialize the Download Directory
      create: (context) => AppCubit()
        ..loadUsers()
        ..cachedData()
        ..determinePosition()
        ..getDirectory(),
      // After creating bloc we need to use it, Here's how
      child: BlocConsumer<AppCubit, AppStates>(
        // Bloc needs a function to listen to states
        listener: (context, state) {},
        // And another function to build Widgets
        builder: (context, state) {
          // This is how We create an object to use later
          var cubit = AppCubit.get(context);
          return MaterialApp(
              title: 'Map Tile',
              // for debugging purposes
              debugShowCheckedModeBanner: false,
              // I designed the Colors and the designs in the theme in case you wanted to change the main color easily
              // Or Use Dark Mode
              theme: lightmode,
              themeMode: ThemeMode.light,
              // Conditional Builder
              // It's used to show loading circle while starting the App
              home: ConditionalBuilder(
                // After Loading location and loading users you can show the widget in the builder
                  condition: (!cubit.loadingLocation) && (!cubit.loadingUsers),
                  // Now there are two options
                  // If the user id is saved in cache you go directly to Home
                  // If No user logged in the id is null and you go th login screen
                  builder: (context) =>
                      (cubit.uId != null) ? const HomeLayout() : LoginScreen(),
                      // In case still loading
                  fallback: (context) {
                    return const Scaffold(
                        body: Center(child: CircularProgressIndicator()));
                  }));
        },
      ),
    );
  }
}
