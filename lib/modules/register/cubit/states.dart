// Register States of Each Event In the Register Screen

abstract class MapRegisterStates {}

class MapRegisterInitialState extends MapRegisterStates {}

// Register in Firebase
class MapRegisterLoadingState extends MapRegisterStates {}

class MapRegisterSuccessState extends MapRegisterStates {
  final String name;

  MapRegisterSuccessState(this.name);
}

class MapRegisterErrorState extends MapRegisterStates {
  final String error;

  MapRegisterErrorState(this.error);
}

// Create User FireStore Cloud
class MapCreateUserLoadingState extends MapRegisterStates {}

class MapCreateUserSuccessState extends MapRegisterStates {
  final String name;

  MapCreateUserSuccessState(this.name);
}

class MapCreateUserErrorState extends MapRegisterStates {
  final String error;

  MapCreateUserErrorState(this.error);
}

// Load Users To Check Phone Uniqueness
class MapLoadUserLoadingState extends MapRegisterStates {}

class MapLoadUserSuccessState extends MapRegisterStates {}

class MapLoadUserErrorState extends MapRegisterStates {
  final String error;

  MapLoadUserErrorState(this.error);
}

// Check Phone Uniqueness
class MapCheckPhoneLoadingState extends MapRegisterStates {}

class MapCheckPhoneSuccessState extends MapRegisterStates {}

class MapCheckPhoneErrorState extends MapRegisterStates {
  final String error;

  MapCheckPhoneErrorState(this.error);
}