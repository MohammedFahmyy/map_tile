abstract class MapLoginStates {}

class MapLoginInitialState extends MapLoginStates {}

class MapLoginLoadingState extends MapLoginStates {}

class MapLoginSuccessState extends MapLoginStates {
  final String id;

  MapLoginSuccessState(this.id);
}

class MapLoginErrorState extends MapLoginStates {
  final String error;

  MapLoginErrorState(this.error);
}

class MapLoginTogglePasswordState extends MapLoginStates{}