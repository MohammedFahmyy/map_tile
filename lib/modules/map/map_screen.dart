import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_tile/layouts/home_layout/cubit/cubit.dart';

import '../../layouts/home_layout/cubit/states.dart';
import '../../shared/constants/constants.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool startedtimer = false;

  // Create Timer To Repeat Update Location
  Timer? timer;

  @override

  // Dispose Timer After Finish
  void dispose() {
    timer!.cancel();
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Creating Cubit For the map
    // The User Location Update is used to update user's location
    // To Show it on The map
    return BlocProvider(
      create: (context) =>
          MapCubit()..userLocationUpdate(id: id, context: context),
      child: BlocConsumer<MapCubit, MapStates>(
        listener: (context, state) {
          // After Updating User and showing the Map
          // App Starts a Pereodic Timer To Update Location Every x minutes
          if (state is MapUpdateUserSuccessState) {
            // Check If timer isn't already started
            if (!startedtimer) {
              timer =
                  Timer.periodic(const Duration(minutes: 5), (Timer t) async {
                // Check if the User isn't logged in, Do Nothing
                if (id != '') {
                  await MapCubit.get(context)
                      .userLocationUpdate(id: id, context: context);
                }
                setState(() {
                  startedtimer = true;
                });
              });
            }
          }
        },
        builder: (context, state) {
          var cubit = MapCubit.get(context);
          return Scaffold(
            body: Column(
              children: [
                Flexible(
                  child: FlutterMap(
                    // Creating The Map
                    options: MapOptions(
                      // Centered with the user location
                      center: LatLng(userLat!, userLng!),
                      minZoom: 14,
                      maxZoom: 18,
                      // Map Boundaries
                      swPanBoundary: LatLng(48.870667, 2.214322),
                      nePanBoundary: LatLng(48.975325, 2.331301),
                      // Disable Map Rotation
                      // You Can Enable it by deleting this line, But in my opinion it's annoying :)
                      interactiveFlags:
                          InteractiveFlag.all & ~InteractiveFlag.rotate,
                      // Default Zoom
                      zoom: 15,
                    ),
                    // To Control Camera Movment
                    mapController: cubit.mapController,
                    children: [
                      // Main Tile using the offline path on the Device
                      TileLayer(
                        tileProvider: FileTileProvider(),
                        maxZoom: 18,
                        urlTemplate: path,
                      ),
                      // Friends' Markers
                      MarkerLayer(
                        markers: usersMarkers,
                      ),
                      // My Marker
                      MarkerLayer(
                        markers: myMarker,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Location Update on Demand Button
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(
                bottom: 25,
                left: 10,
              ),
              child: FloatingActionButton(
                child: const Icon(Icons.gps_not_fixed_outlined),
                onPressed: () async {
                  await cubit.userLocationUpdate(id: id, context: context);
                  setState(() {
                    cubit.mapController.move(LatLng(userLat!, userLng!), 16);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
