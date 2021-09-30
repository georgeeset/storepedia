part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  
  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {
  @override
  String toString() {
    return 'AuthenticaitonInitial';
  }
}

class UnauthenticatedState extends AuthenticationState{
  @override
  String toString() {
    return 'UnauthenticatedState';
  }
}

class AuthenticatingState extends AuthenticationState{

  @override
  String toString() {
    return 'AuthenticatingState';
  }
}

class AuthenticationFailedState extends AuthenticationState{
  final String errorMessage;
  final StackTrace? moreInfo;
  AuthenticationFailedState({required this.errorMessage, this.moreInfo});

  @override
  String toString() {
    return 'AuthenticationFiled';
  }
}

class AuthenticatedState extends AuthenticationState{
  final User user;
  AuthenticatedState({required this.user});
}

