import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_tile/cubit/states.dart';
import 'package:map_tile/modules/map/map_screen.dart';
import 'package:map_tile/modules/report/report_screen.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user_model.dart';
import '../modules/Chat/chat_screen.dart';
import '../modules/login/login_screen.dart';
import '../shared/components/components.dart';
import '../shared/constants/constants.dart';
import '../shared/networks/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  bool loadingUsers = true;
  bool loadingLocation = true;

  // Load Users Function
  Future<void> loadUsers() async {
    emit(AppLoadUserLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {
        allusers.add(UserModel.fromJson(element.data()));
        print(element.data());
      }
      loadingUsers = false;
      emit(AppLoadUserSuccessState());
    }).catchError((error) {
      emit(AppLoadUserErrorState(error.toString()));
      loadingUsers = false;
      print(error);
    });
  }

  // Get Position Function
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    emit(AppGetPositionLoadingState());
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      emit(AppGetPositionErrorState('Location permissions are denied'));
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        emit(AppGetPositionErrorState('Location permissions are denied'));
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emit(AppGetPositionErrorState('Location permissions are denied'));
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    print("Location Done");
    Position position = await Geolocator.getCurrentPosition();
    userLat = position.latitude;
    userLng = position.longitude;
    loadingLocation = false;
    print(userLat);
    print(userLng);
    print("Loading Location: ${!loadingLocation}");
    emit(AppGetPositionSuccessState());
    return position;
  }

  String? uId;
  bool? downloadedT;
  bool? unarchivedT;

  // Get Cached data before application starts
  void cachedData() {
    uId = CacheHelper.getData(key: 'id');
    if (uId != null) {
      id = uId!;
    }
    unarchivedT = CacheHelper.getData(key: 'unarchived');
    if (unarchivedT != null) {
      unarchived = unarchivedT!;
    }
    downloadedT = CacheHelper.getData(key: 'downloaded');
    if (downloadedT != null) {
      downloaded = downloadedT!;
    }
  }

  bool visibility = true;

  // Visibility and Logout Action Determine
  selectedItemAction(context, item) {
    print("ok");
    print(item);
    switch (item) {
      case "Visibility":
        changeVisibility();
        break;
      case "Logout":
        logOut(context);
        break;
      default:
        null;
    }
  }

  // Change Visibility
  changeVisibility() {
    emit(AppChangeVisibilityLoadingState());
    visibility = !visibility;
    // Update To FireStore
    FirebaseFirestore.instance.collection('users').doc(id).update({
      'visibility': visibility,
    }).then((value) {
      emit(AppChangeVisibilitySuccessState());
    }).catchError((onError) {
      emit(AppChangeVisibilityErrorState(onError));
    });
  }

  // Logout Function
  logOut(context) async {
    id = '';
    await CacheHelper.removeData(key: 'id'); 
    navigateAndFinish(context, LoginScreen());
  }

  // Setup Download Path
  getDirectory() async {
    Directory? appDocDirectory = await getExternalStorageDirectory();
    path = '${appDocDirectory!.path}/paris1/{z}/{x}/{y}.png';
  }

  // Main Layout Screens
  List<Widget> screens = [
    const MapScreen(),
    const ReportScreen(),
    const ChatScreen(),
  ];

  // Change Page(Map,Report,Chat)
  int pageIndex = 0;
  changePage(value) {
    pageIndex = value;
    emit(AppChangePageState());
  }
}
