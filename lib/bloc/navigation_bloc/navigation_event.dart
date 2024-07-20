part of 'navigation_bloc.dart';

sealed class NavigationEvent extends Equatable {
  const NavigationEvent();
  @override
  List<Object> get props => [];
}

class NavigationPop extends NavigationEvent {
  const NavigationPop();
  @override
  String toString() {
    return 'NavigationPop';
  }

  @override
  List<Object> get props => [];
}

class NavigationClear extends NavigationEvent {
  const NavigationClear();
  @override
  String toString() {
    return 'NavigationClear';
  }

  @override
  List<Object> get props => [];
}

class PushHomeScreen extends NavigationEvent {
  @override
  String toString() {
    return 'PushHomeScreen';
  }
}

class PushAddItemScreen extends NavigationEvent {
  const PushAddItemScreen({this.photo});
  final dynamic photo;

  @override
  String toString() {
    return 'PushAddItemScreen';
  }

  @override
  List<Object> get props => [];
}

class PushLoginSignupScreen extends NavigationEvent {
  @override
  String toString() {
    return 'PushLoginSignupScreen';
  }

  @override
  List<Object> get props => [];
}

class PushPartDetailScreen extends NavigationEvent {
  const PushPartDetailScreen({this.part});
  final Part? part;
  @override
  String toString() {
    return 'PushPartDetailScreen';
  }

  @override
  List<Object> get props => [];
}

class PushSearchScreen extends NavigationEvent {
  const PushSearchScreen({this.searchString});
  final String? searchString;
  @override
  String toString() {
    return 'PushSearchScreen';
  }

  @override
  List<Object> get props => [];
}

class PushProfileScreen extends NavigationEvent {
  const PushProfileScreen();
  @override
  String toString() {
    return 'PushProfileScreen';
  }

  @override
  List<Object> get props => [];
}

class PushReplaceScreen extends NavigationEvent {
  const PushReplaceScreen(this.routName);
  final String routName;

  @override
  String toString() {
    return 'PushReplaceScreen => $routName';
  }
}

class PushExhaustedPartScreen extends NavigationEvent {
  const PushExhaustedPartScreen();
  @override
  String toString() {
    return 'PushExhaustedPartScreen';
  }
}

class PushCameraScreen extends NavigationEvent {
  const PushCameraScreen({required this.onPop});
  final Function onPop;
  @override
  String toString() {
    return 'PushCameraScreen';
  }

  @override
  List<Object> get props => [];
}
