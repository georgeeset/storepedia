import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../screens/navigation/navigation_stack.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc(String initialRoute)
      : super(NavigationState(NavigationStack(history: [initialRoute]))) {
    on<NavigationPop>(
      (event, emit) {},
    );

    on<PushHomeScreen>(
      (event, emit) {},
    );

    on<PushLoginSignupScreen>(
      (event, emit) {},
    );

    on<PushPartDetailScreen>(
      (event, emit) {},
    );
    on<PushSearchScreen>(
      (event, emit) {},
    );
    on<PushProfileScreen>(
      (event, emit) {},
    );
    on<PushCameraScreen>(
      (event, emit) {},
    );
    on<NavigationClear>(
      (event, emit) {},
    );
  }
  @override
  void onChange(Change<NavigationState> change) {
    print(
        "old Route ${change.currentState.stack.currentRoute} === New Route ${change.nextState.stack.currentRoute}");
    super.onChange(change);
  }
}
