abstract class MapRegisterStates {}

class MapRegisterInitialState extends MapRegisterStates {}

class MapRegisterLoadingState extends MapRegisterStates {}

class MapRegisterSuccessState extends MapRegisterStates {
  final String name;

  MapRegisterSuccessState(this.name);
}

class MapRegisterErrorState extends MapRegisterStates {
  final String error;

  MapRegisterErrorState(this.error);
}

class MapCreateUserLoadingState extends MapRegisterStates {}

class MapCreateUserSuccessState extends MapRegisterStates {
  final String name;

  MapCreateUserSuccessState(this.name);
}

class MapCreateUserErrorState extends MapRegisterStates {
  final String error;

  MapCreateUserErrorState(this.error);
}

class MapLoadUserLoadingState extends MapRegisterStates {}

class MapLoadUserSuccessState extends MapRegisterStates {}

class MapLoadUserErrorState extends MapRegisterStates {
  final String error;

  MapLoadUserErrorState(this.error);
}

class MapCheckPhoneLoadingState extends MapRegisterStates {}

class MapCheckPhoneSuccessState extends MapRegisterStates {}

class MapCheckPhoneErrorState extends MapRegisterStates {
  final String error;

  MapCheckPhoneErrorState(this.error);
}