abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppLoadUserLoadingState extends AppStates {}

class AppLoadUserSuccessState extends AppStates {}

class AppLoadUserErrorState extends AppStates {
  final String error;

  AppLoadUserErrorState(this.error);
}

class AppGetPositionLoadingState extends AppStates {}

class AppGetPositionSuccessState extends AppStates {}

class AppGetPositionErrorState extends AppStates {
  final String error;

  AppGetPositionErrorState(this.error);
}

class AppChangePageState extends AppStates {}

class AppChangeVisibilityLoadingState extends AppStates {}

class AppChangeVisibilitySuccessState extends AppStates {}

class AppChangeVisibilityErrorState extends AppStates {
  final String error;

  AppChangeVisibilityErrorState(this.error);
}