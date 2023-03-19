import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_tile/layouts/home_layout/cubit/states.dart';

import '../../../models/user_model.dart';
import '../../../shared/constants/constants.dart';

class MapCubit extends Cubit<MapStates> {
  MapCubit() : super(MapInitialState());

  static MapCubit get(context) => BlocProvider.of(context);

  var markerst = <Marker>[];

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    emit(MapGetPositionLoadingState());
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      emit(MapGetPositionErrorState('Location permissions are denied'));
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
        emit(MapGetPositionErrorState('Location permissions are denied'));
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emit(MapGetPositionErrorState('Location permissions are denied'));
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    print("Location Done");
    emit(MapGetPositionSuccessState());
    return await Geolocator.getCurrentPosition();
  }

  Future<void> userLocationUpdate({
    required BuildContext context,
    required String id,
  }) async {
    Position position = await determinePosition();
    print(id);
    print(position);
    print("check id =$id");
    emit(MapUpdateUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(id).update({
      'lat': position.latitude,
      'lng': position.longitude,
    });
    userLat = position.latitude;
    userLng = position.longitude;
    emit(MapUpdateUserSuccessState());
    addMyMarker(position.latitude, position.longitude);
    loadUsers(context);
  }

  bool loading = true;

  MapController mapController = MapController();

  addMyMarker(latitude, longitude) {
    if (myMarker.isNotEmpty) {
      myMarker.clear();
    }
    myMarker.add(Marker(
      height: 76,
      width: 76,
      point: LatLng(latitude,longitude),
      builder: (ctx) => Column(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.location_on,
            ),
            iconSize: 50,
            color: Colors.redAccent,
            onPressed: () {
              changeCamera(latitude,longitude);
            },
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            "You",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ));
  }

  changeCamera(lat, lng) {
    mapController.move(LatLng(lat, lng), 16);
    emit(MapCameraMoveState());
  }

  Future<void> loadUsers(context) async {
    emit(MapLoadUserLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((value) {
      if (usersMarkers.isNotEmpty) {
        usersMarkers.clear();
      }
      for (var element in value.docs) {
        UserModel user = UserModel.fromJson(element.data());
        allusers.add(user);
        if ((user.lat != 0 && user.lng != 0) && user.id != id && (user.visibility == true)) {
          usersMarkers.add(Marker(
            height: 100,
            width: 100,
            point: LatLng(user.lat!, user.lng!),
            builder: (ctx) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.location_on,
                  ),
                  iconSize: 50,
                  color: Colors.black,
                  onPressed: () {
                    changeCamera(user.lat!, user.lng!);
                    showDialog(context: context, builder: (context) => SimpleDialog(
                      title: Text(user.fname!),
                      children: [
                        SimpleDialogOption(
                          child: Text("Email : ${user.email!}"),
                        ),
                        SimpleDialogOption(
                          child: Text("Phone Number : ${user.phone!}"),
                        ),
                      ],
                    ), );
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  user.fname!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  user.lname!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ));
        }
        print(element.data());
      }
      print(usersMarkers.length);
      loading = false;
      emit(MapLoadUserSuccessState());
    }).catchError((error) {
      emit(MapLoadUserErrorState(error.toString()));
      loading = false;
      print(error);
    });
  }
}
