
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  late FirebaseAuth _auth;
  late User? _user;

  AuthenticationBloc() : super(AuthenticationInitial()) {
    void onAuthStateChanged(User? firebaseUser) {
      _user = firebaseUser;
      if (_user == null) {
        emit(UnauthenticatedState());
      } else {
        emit(AuthenticatedState(user: _user!));
      }
    }

    _auth = FirebaseAuth.instance;
    _auth.authStateChanges().listen((user) => onAuthStateChanged(user));

    // @override
    // Stream<AuthenticationState> mapEventToState(
    //   AuthenticationEvent event,
    // ) async* {

    on<EmailPasswordSigninEvent>((event, emit) async {
      emit(AuthenticatingState());
      try {
        await _auth.signInWithEmailAndPassword(
            email: event.email, password: event.password);
      } on FirebaseAuthException catch (err) {
        // print(err.toString());
        emit(AuthenticationFailedState(errorMessage: err.message.toString()));
      }
    });

    on<RegisterEvent>((event, emit) async {
      String password;
      if (event.password1 == event.password2) {
        password = event.password1;

        emit(AuthenticatingState());

        try {
          await _auth.createUserWithEmailAndPassword(
            email: event.email,
            password: password,
          );
        } on FirebaseAuthException catch (err) {
          emit(AuthenticationFailedState(errorMessage: err.message.toString()));
        }
      } else {
        emit(const AuthenticationFailedState(
            errorMessage: 'Passwords not consistent'));
      }
    });

    on<ResetPasswordEvent>((event, emit) async {
      String email = event.email;
      emit(AuthenticatingState());

      try {
        await _auth.sendPasswordResetEmail(email: email);
      } on FirebaseAuthException catch (err) {
        emit(AuthenticationFailedState(errorMessage: err.message.toString()));
      }
      emit(AuthEmailSentState());
    });

    on<SignOutEvent>((event, emit) {
      _auth.signOut();
    });
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
