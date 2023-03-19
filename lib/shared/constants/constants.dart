import 'package:flutter_map/flutter_map.dart';

import '../../models/user_model.dart';

String id = '';

List<UserModel> allusers = [];
  var myMarker = <Marker>[];
  double? userLat;
  double? userLng;
  var usersMarkers = <Marker>[];
  String? path;
  bool downloaded = false;
  bool unarchived = false;