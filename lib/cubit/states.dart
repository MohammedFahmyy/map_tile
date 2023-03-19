abstract class AppStates {}

class AppInitialState extends AppStates {}

// App Loading States
class AppLoadUserLoadingState extends AppStates {}

class AppLoadUserSuccessState extends AppStates {}

class AppLoadUserErrorState extends AppStates {
  final String error;

  AppLoadUserErrorState(this.error);
}

// Get Position States
class AppGetPositionLoadingState extends AppStates {}

class AppGetPositionSuccessState extends AppStates {}

class AppGetPositionErrorState extends AppStates {
  final String error;

  AppGetPositionErrorState(this.error);
}

// Change Page State
class AppChangePageState extends AppStates {}

// Change Visibility State
class AppChangeVisibilityLoadingState extends AppStates {}

class AppChangeVisibilitySuccessState extends AppStates {}

class AppChangeVisibilityErrorState extends AppStates {
  final String error;

  AppChangeVisibilityErrorState(this.error);
}