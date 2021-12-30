import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'signinoption_event.dart';
part 'signinoption_state.dart';

class SigninoptionBloc extends Bloc<SigninoptionEvent, SigninoptionState> {
  SigninoptionBloc() : super(SigninState()) {
    // @override
    // Stream<SigninoptionState> mapEventToState(
    //   SigninoptionEvent event,
    // ) async* {

    on<SigninoptionEvent>((event, emit) {
      emit(SigninState());
    });

    on<RegisterOptionEvent>((event, emit) {
      emit(RegisterState());
    });

    on<ForgotPasswordEvent>((event, emit) {
      emit(ForgotPasswordState());
    });
  }

  @override
  void onChange(Change<SigninoptionState> change) {
    print('SigninoptionState--> ${change.nextState}');
    super.onChange(change);
  }

  @override
  void onEvent(SigninoptionEvent event) {
    print('SigninoptionEvent--> ${event.toString()}');
    super.onEvent(event);
  }
}
