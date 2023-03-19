import 'package:flutter_map/flutter_map.dart';

import '../../models/user_model.dart';

// This File is used to save constants that we need across the app
// Most variables are empty and will be initialized before using app

// id of user
String id = '';

// List of all users
List<UserModel> allusers = [];
// User Marker
var myMarker = <Marker>[];
// User Coordinates
double? userLat;
double? userLng;
// Other Users Markers
var usersMarkers = <Marker>[];
// Download Path
String? path;
// Checkers for downlaoding indicators
bool downloaded = false;
bool unarchived = false;
