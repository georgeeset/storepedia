part of 'navigation_bloc.dart';

class NavigationState extends Equatable {
  const NavigationState(this.stack);
  final NavigationStack stack;

  @override
  List<Object> get props => [stack];
}
