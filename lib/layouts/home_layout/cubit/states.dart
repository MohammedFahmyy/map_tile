abstract class MapStates {}

class MapInitialState extends MapStates {}

// Camera Move
class MapCameraMoveState extends MapStates {}

// Update User States
class MapUpdateUserLoadingState extends MapStates {}

class MapUpdateUserSuccessState extends MapStates {}

class MapUpdateUserErrorState extends MapStates {
  final String error;

  MapUpdateUserErrorState(this.error);
}

// Create Pointer
class MapMakePointerLoadingState extends MapStates {}

class MapMakePointerSuccessState extends MapStates {}

// Get Position
class MapGetPositionLoadingState extends MapStates {}

class MapGetPositionSuccessState extends MapStates {}

class MapGetPositionErrorState extends MapStates {
  final String error;

  MapGetPositionErrorState(this.error);
}

// Loading User
class MapLoadUserLoadingState extends MapStates {}

class MapLoadUserSuccessState extends MapStates {}

class MapLoadUserErrorState extends MapStates {
  final String error;

  MapLoadUserErrorState(this.error);
}
