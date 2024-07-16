part of 'navigation_bloc.dart';

sealed class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class NavigationPop extends NavigationEvent {
  const NavigationPop();
  @override
  List<Object> get props => [];
}

class NavigationClear extends NavigationEvent {
  const NavigationClear();

  @override
  List<Object> get props => [];
}

class PushHomeScreen extends NavigationEvent {
  const PushHomeScreen();
  @override
  List<Object> get props => [];
}

class PushAddItemScreen extends NavigationEvent {
  const PushAddItemScreen();
  @override
  List<Object> get props => [];
}

class PushLoginSignupScreen extends NavigationEvent {
  const PushLoginSignupScreen();
  @override
  List<Object> get props => [];
}

class PushPartDetailScreen extends NavigationEvent {
  const PushPartDetailScreen();
  @override
  List<Object> get props => [];
}

class PushSearchScreen extends NavigationEvent {
  const PushSearchScreen();
  @override
  List<Object> get props => [];
}

class PushProfileScreen extends NavigationEvent {
  const PushProfileScreen();
  @override
  List<Object> get props => [];
}

class PushCameraScreen extends NavigationEvent {
  const PushCameraScreen();
  @override
  List<Object> get props => [];
}
