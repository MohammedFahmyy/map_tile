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
  @override

  Timer? timer;

  @override
  void dispose() {
    timer!.cancel();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapCubit()..userLocationUpdate(id: id,context:context),
      child: BlocConsumer<MapCubit, MapStates>(
        listener: (context, state) {
          if (state is MapUpdateUserSuccessState) {
            if (!startedtimer) {
              timer =
                  Timer.periodic(const Duration(minutes: 5), (Timer t) async {
                if (id != '') {
                  await MapCubit.get(context).userLocationUpdate(id: id,context: context);
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
                    options: MapOptions(
                      onTap: (tapPosition, point) {
                        print(point);
                      },
                      center: LatLng(userLat!, userLng!),
                      minZoom: 14,
                      maxZoom: 18,
                      swPanBoundary: LatLng(48.815071,2.242373),
                      nePanBoundary: LatLng(48.882722,2.449689),
                      interactiveFlags:
                          InteractiveFlag.all & ~InteractiveFlag.rotate,
                      zoom: 15,
                    ),
                    mapController: cubit.mapController,
                    children: [
                      TileLayer(
                        tileProvider: FileTileProvider(),
                        maxZoom: 18,
                        urlTemplate:
                            path,
                      ),
                       MarkerLayer(
                        markers: usersMarkers,
                      ),
                      MarkerLayer(
                        markers: myMarker,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(
                bottom: 25,
                left: 10,
              ),
              child: FloatingActionButton(
                child: const Icon(Icons.gps_not_fixed_outlined),
                onPressed: () async {
            
                  await cubit.userLocationUpdate(id: id,context: context);
                  setState(() {
                    cubit.mapController.move(LatLng(userLat!,userLng!), 16);
                  });
                },
                // onPressed: () async {
                //   Position position = await cubit.determinePosition();
                //   print(position.latitude);
                //   print(position.longitude);
                //   cubit.markers = <Marker>[];
                //   cubit.markers.add(
                //     Marker(
                //       height: 50,
                //       width: 50,
                //       point: LatLng(position.latitude, position.longitude),
                //       builder: (ctx) => IconButton(
                //         padding: EdgeInsets.zero,
                //         icon: const Icon(
                //           Icons.pin_drop,
                //         ),
                //         iconSize: 50,
                //         onPressed: () {
                //           print("Medoz");
                //         },
                //       ),
                //     ),
                //   );
                // },
              ),
            ),
          );
        },
      ),
    );
  }
}
