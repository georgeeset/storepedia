import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:storepedia/model/part.dart';
import '../../screens/navigation/navigation_stack.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc(String initialRoute)
      : super(NavigationState(NavigationStack(history: [initialRoute]))) {
    final currentRoute = state;
    on<NavigationPop>(
      (event, emit) {},
    );

    on<PushHomeScreen>(
      (event, emit) {
        emit(NavigationState(currentRoute.stack.push('/')));
      },
    );

    on<PushLoginSignupScreen>(
      (event, emit) {
        emit(NavigationState(currentRoute.stack.push('/signin')));
      },
    );

    on<PushPartDetailScreen>(
      (event, emit) {
        emit(NavigationState(
            currentRoute.stack.push('/part-detail/${event.part}')));
      },
    );

    on<PushSearchScreen>(
      (event, emit) {
        emit(NavigationState(currentRoute.stack.push('/search')));
      },
    );

    on<PushProfileScreen>(
      (event, emit) {
        emit(NavigationState(currentRoute.stack.push('/profile')));
      },
    );

    on<PushCameraScreen>(
      (event, emit) {
        emit(NavigationState(currentRoute.stack.push('/camera')));
      },
    );

    on<NavigationClear>(
      (event, emit) {},
    );
  }

  @override
  void onChange(Change<NavigationState> change) {
    print(
        "old Route => ${change.currentState.stack.currentRoute} || New Route => ${change.nextState.stack.currentRoute}");
    print(change.nextState.stack.history);
    super.onChange(change);
  }
}
