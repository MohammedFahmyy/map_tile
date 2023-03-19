abstract class MapStates {}

class MapInitialState extends MapStates {}

class MapCameraMoveState extends MapStates {}

class MapUpdateUserLoadingState extends MapStates {}

class MapUpdateUserSuccessState extends MapStates {}

class MapUpdateUserErrorState extends MapStates {
  final String error;

  MapUpdateUserErrorState(this.error);
}

class MapMakePointerLoadingState extends MapStates {}

class MapMakePointerSuccessState extends MapStates {}

class MapGetPositionLoadingState extends MapStates {}

class MapGetPositionSuccessState extends MapStates {}

class MapGetPositionErrorState extends MapStates {
  final String error;

  MapGetPositionErrorState(this.error);
}

class MapLoadUserLoadingState extends MapStates {}

class MapLoadUserSuccessState extends MapStates {}

class MapLoadUserErrorState extends MapStates {
  final String error;

  MapLoadUserErrorState(this.error);
}
