import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'signinoption_event.dart';
part 'signinoption_state.dart';

class SigninoptionBloc extends Bloc<SigninoptionEvent, SigninoptionState> {
  SigninoptionBloc() : super(SigninState());

  @override
  Stream<SigninoptionState> mapEventToState(
    SigninoptionEvent event,
  ) async* {
    if(event is SigninoptionEvent){
      yield(SigninState());
    }
    if(event is RegisterOptionEvent){
      yield(RegisterState());
    }
    if(event is ForgotPasswordEvent){
      yield(ForgotPasswordState());
    }
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
