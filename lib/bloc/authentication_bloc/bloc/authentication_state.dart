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
  @override
  List<Object> get props => [];
}

class UnauthenticatedState extends AuthenticationState{
  @override
  String toString() {
    return 'UnauthenticatedState';
  }
  @override
  List<Object> get props => [];
}

class AuthenticatingState extends AuthenticationState{

  @override
  String toString() {
    return 'AuthenticatingState';
  }
  @override
  List<Object> get props => [];
}

class AuthenticationFailedState extends AuthenticationState{
  final String errorMessage;
  final StackTrace? moreInfo;
  const AuthenticationFailedState({required this.errorMessage, this.moreInfo});

  @override
  String toString() {
    return 'AuthenticationFiled';
  }
  @override
  List<Object> get props => [errorMessage];
}

class AuthenticatedState extends AuthenticationState{
  final User user;
  const AuthenticatedState({required this.user});
  @override
  List<Object> get props => [user];
}

