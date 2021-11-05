import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
  extends Bloc<AuthenticationEvent, AuthenticationState> {
  late FirebaseAuth _auth;
  late User? _user;

  AuthenticationBloc() : super(AuthenticationInitial()) {
    Firebase.initializeApp().then((_) {
      _auth = FirebaseAuth.instance;
      _auth.authStateChanges().listen((user) => _onAuthStateChanged(user));
    });
  }

  void _onAuthStateChanged(User? firebaseUser) {
    _user = firebaseUser;
    if (_user == null) {
      emit(UnauthenticatedState());
    } else {
      emit(AuthenticatedState(user: _user!));
    }
  }

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    
    if (event is EmailPasswordSigninEvent) {
      yield (AuthenticatingState());
       try {
        await _auth.signInWithEmailAndPassword(
            email: event.email, password: event.password);
      } on FirebaseAuthException catch (err) {
       // print(err.toString());
        yield(AuthenticationFailedState(errorMessage: err.message.toString()));
      }
    }

    if (event is RegisterEvent) {
      var password;
      if (event.password1 == event.password2) {
        password = event.password1;

        yield (AuthenticatingState());

        try{
          await _auth
            .createUserWithEmailAndPassword(
          email: event.email,
          password: password,
        );}on FirebaseAuthException catch(err){
          yield(AuthenticationFailedState(errorMessage: err.message.toString()));
        }
      }
      else {
      yield (AuthenticationFailedState(
          errorMessage: 'Passwords not consistent'));
      }
         
    } 
      
    if(event is SignOutEvent){
      _auth.signOut();
    }

    
  }

 

  @override
  void onChange(Change<AuthenticationState> change) {
    print(change.nextState);
    super.onChange(change);
  }

  @override
  void onEvent(AuthenticationEvent event) {
    print(event);
    super.onEvent(event);
  }
}
